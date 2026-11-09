import CoreData

struct SellerItem {
    let id: NSManagedObjectID
    let name: String
}
struct TeamSaleItem {
    let id: NSManagedObjectID
    let sellerID: NSManagedObjectID
    let seller: String
    let client: String
    let product: String
    let quantity: Int64
    let total: Decimal
    let date: Date
    let cancelled: Bool
    let reason: String?
}
struct DailySales {
    let date: Date
    let total: Decimal
}
struct SellerRanking {
    let sellerID: NSManagedObjectID
    let name: String
    let total: Decimal
}
struct SupervisorSummary {
    let soldToday: Decimal
    let monthlyTax: Decimal
    let days: [DailySales]
    let ranking: [SellerRanking]
    let lowStock: [ProductItem]
}
enum SupervisorError: LocalizedError {
    case permission, reasonRequired, alreadyCancelled, invalidStock, notFound, persistence
    var errorDescription: String? {
        switch self {
        case .permission: return "Solo el Supervisor puede acceder a esta operación."
        case .reasonRequired: return "Ingresa el motivo de la anulación."
        case .alreadyCancelled: return "Esta venta ya fue anulada. El stock no se modificó."
        case .invalidStock: return "No se puede restaurar el stock de esta venta. Revisa la cantidad del producto."
        case .notFound: return "La venta o sus relaciones ya no están disponibles. Actualiza la lista."
        case .persistence: return "No se pudo consultar o guardar la información. Actualiza e inténtalo nuevamente."
        }
    }
}

@MainActor
final class SupervisorService {
    private let context: NSManagedObjectContext
    private let sessionProvider: () -> SessionUser?
    var session: SessionUser? { sessionProvider() }

    init(container: NSPersistentContainer, sessionProvider: @escaping () -> SessionUser?) {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        context.mergePolicy = NSErrorMergePolicy
        self.sessionProvider = sessionProvider
    }

    func sellers() throws -> [SellerItem] {
        try prepare()
        let request = NSFetchRequest<Usuario>(entityName: "Usuario")
        request.predicate = NSPredicate(format: "rol == %@", UserRole.vendedor.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        do { return try context.fetch(request).map { SellerItem(id: $0.objectID, name: $0.nombre ?? "") } }
        catch { throw SupervisorError.persistence }
    }

    func sales(period: SalePeriod = .all, sellerID: NSManagedObjectID? = nil, search: String = "",
               now: Date = Date(), calendar: Calendar = .current) throws -> [TeamSaleItem] {
        try prepare()
        let request = NSFetchRequest<Venta>(entityName: "Venta")
        var predicates = [NSPredicate(format: "vendedor.rol == %@", UserRole.vendedor.rawValue)]
        if let sellerID {
            let seller: Usuario = try object(sellerID)
            predicates.append(NSPredicate(format: "vendedor == %@", seller))
        }
        if let interval = period.interval(now: now, calendar: calendar) {
            predicates.append(NSPredicate(format: "fecha >= %@ AND fecha < %@", interval.start as NSDate, interval.end as NSDate))
        }
        let search = search.trimmingCharacters(in: .whitespacesAndNewlines)
        if !search.isEmpty { predicates.append(NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", search)) }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        request.relationshipKeyPathsForPrefetching = ["cliente", "producto", "vendedor"]
        do { return try context.fetch(request).map(item) }
        catch { throw SupervisorError.persistence }
    }

    /// Keeps the sale and its monetary history; one save commits cancellation and stock.
    func cancelSale(id: NSManagedObjectID, reason: String) throws {
        try prepare()
        let reason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !reason.isEmpty else { throw SupervisorError.reasonRequired }
        let sale: Venta = try object(id)
        guard !sale.anulada else { throw SupervisorError.alreadyCancelled }
        guard let product = sale.producto, sale.cantidad > 0, product.stock >= 0 else { throw SupervisorError.invalidStock }
        let restored = product.stock.addingReportingOverflow(sale.cantidad)
        guard !restored.overflow else { throw SupervisorError.invalidStock }
        product.stock = restored.partialValue
        sale.anulada = true
        sale.motivoAnulacion = reason
        do { try context.save() }
        catch { context.rollback(); throw SupervisorError.persistence }
    }

    func dashboard(now: Date = Date(), calendar: Calendar = .current) throws -> SupervisorSummary {
        try prepare()
        let today = calendar.startOfDay(for: now)
        guard let firstDay = calendar.date(byAdding: .day, value: -6, to: today),
              let tomorrow = calendar.date(byAdding: .day, value: 1, to: today),
              let month = calendar.dateInterval(of: .month, for: now) else { throw SupervisorError.persistence }
        let request = NSFetchRequest<Venta>(entityName: "Venta")
        request.predicate = NSPredicate(format: "anulada == NO AND vendedor.rol == %@ AND fecha >= %@ AND fecha < %@",
                                        UserRole.vendedor.rawValue, min(firstDay, month.start) as NSDate, max(tomorrow, month.end) as NSDate)
        request.relationshipKeyPathsForPrefetching = ["vendedor"]
        do {
            let sales = try context.fetch(request)
            let daily = (0..<7).map { offset -> DailySales in
                let date = calendar.date(byAdding: .day, value: offset, to: firstDay)!
                let end = calendar.date(byAdding: .day, value: 1, to: date)!
                let valid = sales.filter { ($0.fecha ?? .distantPast) >= date && ($0.fecha ?? .distantPast) < end }
                return DailySales(date: date, total: total(valid))
            }
            let monthly = sales.filter { ($0.fecha ?? .distantPast) >= month.start && ($0.fecha ?? .distantPast) < month.end }
            let tax = Money.rounded(monthly.reduce(Decimal.zero) { $0 + Money.decimal($1.igv) })
            var groups: [NSManagedObjectID: (String, Decimal)] = [:]
            for sale in monthly {
                guard let seller = sale.vendedor else { continue }
                let previous = groups[seller.objectID]?.1 ?? 0
                groups[seller.objectID] = (seller.nombre ?? "", previous + Money.decimal(sale.total))
            }
            let ranking = groups.map { SellerRanking(sellerID: $0.key, name: $0.value.0, total: Money.rounded($0.value.1)) }.sorted {
                if $0.total != $1.total { return $0.total > $1.total }
                if $0.name != $1.name { return $0.name < $1.name }
                return $0.sellerID.uriRepresentation().absoluteString < $1.sellerID.uriRepresentation().absoluteString
            }
            let stockRequest = NSFetchRequest<Producto>(entityName: "Producto")
            stockRequest.predicate = NSPredicate(format: "stock <= 5")
            stockRequest.sortDescriptors = [NSSortDescriptor(key: "stock", ascending: true), NSSortDescriptor(key: "nombre", ascending: true)]
            let lowStock = try context.fetch(stockRequest).map {
                ProductItem(id: $0.objectID, name: $0.nombre ?? "", category: $0.categoria ?? "", price: $0.precio, stock: $0.stock)
            }
            return SupervisorSummary(soldToday: daily.last?.total ?? 0, monthlyTax: tax, days: daily, ranking: ranking, lowStock: lowStock)
        } catch { throw SupervisorError.persistence }
    }

    private func prepare() throws {
        guard let session, session.role == .supervisor else { throw SupervisorError.permission }
        guard context.persistentStoreCoordinator?.persistentStores.isEmpty == false else { throw SupervisorError.persistence }
        context.reset()
        let supervisor: Usuario = try object(session.objectID)
        guard supervisor.rol == UserRole.supervisor.rawValue else { throw SupervisorError.permission }
    }
    private func object<T: NSManagedObject>(_ id: NSManagedObjectID) throws -> T {
        do {
            guard let result = try context.existingObject(with: id) as? T, !result.isDeleted else { throw SupervisorError.notFound }
            return result
        } catch { throw SupervisorError.notFound }
    }
    private func total(_ sales: [Venta]) -> Decimal { Money.rounded(sales.reduce(Decimal.zero) { $0 + Money.decimal($1.total) }) }
    private func item(_ sale: Venta) -> TeamSaleItem {
        TeamSaleItem(id: sale.objectID, sellerID: sale.vendedor!.objectID, seller: sale.vendedor?.nombre ?? "", client: sale.cliente?.nombre ?? "",
                     product: sale.producto?.nombre ?? "", quantity: sale.cantidad, total: Money.decimal(sale.total), date: sale.fecha ?? .distantPast,
                     cancelled: sale.anulada, reason: sale.motivoAnulacion)
    }
}
