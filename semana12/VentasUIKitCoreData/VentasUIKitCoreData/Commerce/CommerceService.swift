import CoreData

/// All operations run on the main actor. Each mutation uses one isolated context save.
/// NSErrorMergePolicy rejects conflicting stock writes instead of silently overwriting them.
@MainActor
final class CommerceService {
    private let context: NSManagedObjectContext
    private let sessionProvider: () -> SessionUser?
    private var completedRequests: Set<UUID> = []
    var session: SessionUser? { sessionProvider() }
    var canDeleteClients: Bool { session?.role == .supervisor }

    init(container: NSPersistentContainer, sessionProvider: @escaping () -> SessionUser?) {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        context.mergePolicy = NSErrorMergePolicy
        self.sessionProvider = sessionProvider
    }

    func clients(search: String = "") throws -> [ClientItem] {
        try prepare()
        let request = NSFetchRequest<Cliente>(entityName: "Cliente")
        let search = clean(search)
        if !search.isEmpty {
            request.predicate = NSPredicate(format: "nombre CONTAINS[cd] %@ OR documento CONTAINS[cd] %@", search, search)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        do { return try context.fetch(request).map(clientItem) }
        catch { throw CommerceError.persistence }
    }

    @discardableResult
    func saveClient(id: NSManagedObjectID? = nil, name: String, document: String) throws -> ClientItem {
        try prepare()
        let name = clean(name), document = clean(document)
        guard !name.isEmpty, !document.isEmpty else { throw CommerceError.fields }
        let request = NSFetchRequest<Cliente>(entityName: "Cliente")
        request.predicate = NSPredicate(format: "documento ==[c] %@", document)
        do {
            let duplicates = try context.fetch(request)
            guard !duplicates.contains(where: { $0.objectID != id }) else { throw CommerceError.duplicateDocument }
            let client: Cliente = try id.map { try object($0) } ?? Cliente(context: context)
            client.nombre = name
            client.documento = document
            try context.save()
            return clientItem(client)
        } catch { context.rollback(); throw mapped(error) }
    }

    func deleteClient(id: NSManagedObjectID) throws {
        try prepare()
        guard canDeleteClients else { throw CommerceError.permission }
        let client: Cliente = try object(id)
        guard client.ventas?.count ?? 0 == 0 else { throw CommerceError.associatedSales }
        context.delete(client)
        do { try context.save() }
        catch { context.rollback(); throw mapped(error) }
    }

    func products() throws -> [ProductItem] {
        try prepare()
        let request = NSFetchRequest<Producto>(entityName: "Producto")
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true)]
        do { return try context.fetch(request).map(productItem) }
        catch { throw CommerceError.persistence }
    }

    func quote(clientID: NSManagedObjectID, productID: NSManagedObjectID, quantity: Int64) throws -> SaleQuote {
        try prepare(sellerOnly: true)
        return try makeQuote(clientID: clientID, productID: productID, quantity: quantity)
    }

    /// Re-reads stock, price and VIP status; never accepts monetary values from the UI.
    /// Sale insertion and stock decrement are committed in the same SQLite transaction.
    @discardableResult
    func registerSale(clientID: NSManagedObjectID, productID: NSManagedObjectID,
                      quantity: Int64, requestID: UUID) throws -> SaleItem {
        try prepare(sellerOnly: true)
        guard !completedRequests.contains(requestID) else { throw CommerceError.duplicateRequest }
        guard let session else { throw CommerceError.session }
        do {
            let seller: Usuario = try object(session.objectID)
            guard seller.rol == UserRole.vendedor.rawValue else { throw CommerceError.permission }
            let quote = try makeQuote(clientID: clientID, productID: productID, quantity: quantity)
            let product: Producto = try object(productID)
            let client: Cliente = try object(clientID)
            let sale = Venta(context: context)
            sale.vendedor = seller
            sale.producto = product
            sale.cliente = client
            sale.fecha = Date()
            sale.cantidad = quantity
            sale.precioUnitario = product.precio
            sale.descuento = Money.double(quote.amounts.discount)
            sale.igv = Money.double(quote.amounts.tax)
            sale.total = Money.double(quote.amounts.total)
            sale.anulada = false
            sale.motivoAnulacion = nil
            product.stock -= quantity
            try context.save()
            completedRequests.insert(requestID)
            return saleItem(sale)
        } catch { context.rollback(); throw mapped(error) }
    }

    func mySales(search: String = "", period: SalePeriod = .all,
                 now: Date = Date(), calendar: Calendar = .current) throws -> [SaleItem] {
        try prepare(sellerOnly: true)
        let request = try salesRequest(period: period, now: now, calendar: calendar, validOnly: false)
        let search = clean(search)
        if !search.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [request.predicate!, NSPredicate(format: "cliente.nombre CONTAINS[cd] %@", search)])
        }
        request.sortDescriptors = [NSSortDescriptor(key: "fecha", ascending: false)]
        request.relationshipKeyPathsForPrefetching = ["cliente", "producto"]
        do { return try context.fetch(request).map(saleItem) }
        catch { throw CommerceError.persistence }
    }

    /// Summary cards are independent of the list's search and segment selection.
    func summary(period: SalePeriod, now: Date = Date(), calendar: Calendar = .current) throws -> SaleSummary {
        try prepare(sellerOnly: true)
        let request = try salesRequest(period: period, now: now, calendar: calendar, validOnly: true)
        do {
            let sales = try context.fetch(request)
            let sum = sales.reduce(Decimal.zero) { $0 + Money.decimal($1.total) }
            return SaleSummary(total: Money.rounded(sum), count: sales.count)
        } catch { throw CommerceError.persistence }
    }

    private func prepare(sellerOnly: Bool = false) throws {
        guard let session else { throw CommerceError.session }
        if sellerOnly && session.role != .vendedor { throw CommerceError.permission }
        guard context.persistentStoreCoordinator?.persistentStores.isEmpty == false else { throw CommerceError.persistence }
        // Objects never escape this service: resetting ensures each operation uses current data.
        context.reset()
    }

    private func makeQuote(clientID: NSManagedObjectID, productID: NSManagedObjectID, quantity: Int64) throws -> SaleQuote {
        guard quantity > 0 else { throw CommerceError.quantity }
        let client: Cliente = try object(clientID)
        let product: Producto = try object(productID)
        guard product.stock >= quantity else { throw CommerceError.stock }
        let customer = clientItem(client)
        let amounts = try SaleAmounts.calculate(price: product.precio, quantity: quantity, vip: customer.tier == .vip)
        return SaleQuote(client: customer, product: productItem(product), amounts: amounts)
    }

    private func salesRequest(period: SalePeriod, now: Date, calendar: Calendar, validOnly: Bool) throws -> NSFetchRequest<Venta> {
        guard let session else { throw CommerceError.session }
        let seller: Usuario = try object(session.objectID)
        guard seller.rol == UserRole.vendedor.rawValue else { throw CommerceError.permission }
        let request = NSFetchRequest<Venta>(entityName: "Venta")
        var predicates = [NSPredicate(format: "vendedor == %@", seller)]
        if validOnly { predicates.append(NSPredicate(format: "anulada == NO")) }
        if let interval = period.interval(now: now, calendar: calendar) {
            predicates.append(NSPredicate(format: "fecha >= %@ AND fecha < %@", interval.start as NSDate, interval.end as NSDate))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        return request
    }

    private func clientItem(_ client: Cliente) -> ClientItem {
        let valid = (client.ventas as? Set<Venta> ?? []).filter { !$0.anulada }
        let accumulated = valid.reduce(Decimal.zero) { $0 + Money.decimal($1.total) }
        return ClientItem(id: client.objectID, name: client.nombre ?? "", document: client.documento ?? "", purchased: Money.rounded(accumulated))
    }
    private func productItem(_ product: Producto) -> ProductItem {
        ProductItem(id: product.objectID, name: product.nombre ?? "", category: product.categoria ?? "", price: product.precio, stock: product.stock)
    }
    private func saleItem(_ sale: Venta) -> SaleItem {
        SaleItem(id: sale.objectID, client: sale.cliente?.nombre ?? "", product: sale.producto?.nombre ?? "", quantity: sale.cantidad,
                 date: sale.fecha ?? .distantPast, total: Money.decimal(sale.total), cancelled: sale.anulada)
    }
    private func object<T: NSManagedObject>(_ id: NSManagedObjectID) throws -> T {
        do {
            guard let object = try context.existingObject(with: id) as? T, !object.isDeleted else { throw CommerceError.notFound }
            return object
        } catch { throw CommerceError.notFound }
    }
    private func mapped(_ error: Error) -> Error {
        if error is CommerceError { return error }
        let error = error as NSError
        let details = error.userInfo[NSDetailedErrorsKey] as? [NSError] ?? [error]
        if details.contains(where: { $0.code == NSValidationRelationshipDeniedDeleteError }) { return CommerceError.associatedSales }
        return CommerceError.persistence
    }
    private func clean(_ text: String) -> String { text.trimmingCharacters(in: .whitespacesAndNewlines) }
}
