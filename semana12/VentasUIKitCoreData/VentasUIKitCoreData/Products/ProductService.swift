import CoreData

enum ProductError: LocalizedError {
    case permission, requiredFields, invalidPrice, invalidStock, associatedSales, notFound, persistence
    var errorDescription: String? {
        switch self {
        case .permission: return "Solo el Supervisor puede modificar productos."
        case .requiredFields: return "Completa el nombre y la categoría."
        case .invalidPrice: return "El precio debe ser un número mayor que cero."
        case .invalidStock: return "El stock debe ser un entero no negativo."
        case .associatedSales: return "No se puede eliminar este producto porque tiene ventas asociadas."
        case .notFound: return "El producto ya no está disponible. Actualiza la lista."
        case .persistence: return "No se pudo acceder a los productos. Inténtalo nuevamente."
        }
    }
}

enum StockLevel {
    case available, low, outOfStock
    // A3 rule: 1–10 units = low; zero = out of stock; above 10 = available.
    static func level(for stock: Int64) -> StockLevel {
        stock == 0 ? .outOfStock : (stock <= 10 ? .low : .available)
    }
}

struct ProductItem {
    let id: NSManagedObjectID
    let name: String
    let category: String
    let price: Double
    let stock: Int64
    var stockLevel: StockLevel { StockLevel.level(for: stock) }
}

/// SQLite-backed queries and mutations. No seeded products or in-memory storage.
@MainActor
final class ProductService {
    private let context: NSManagedObjectContext
    private let roleProvider: () -> UserRole?
    var canManage: Bool { roleProvider() == .supervisor }

    init(container: NSPersistentContainer, roleProvider: @escaping () -> UserRole?) {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        context.mergePolicy = NSErrorMergePolicy
        context.automaticallyMergesChangesFromParent = true
        self.roleProvider = roleProvider
    }

    func products(search: String = "", category: String? = nil) throws -> [ProductItem] {
        try requireStore()
        let request = NSFetchRequest<Producto>(entityName: "Producto")
        var predicates: [NSPredicate] = []
        let search = clean(search)
        if !search.isEmpty { predicates.append(NSPredicate(format: "nombre CONTAINS[cd] %@", search)) }
        if let category { predicates.append(NSPredicate(format: "categoria ==[c] %@", category)) }
        if !predicates.isEmpty { request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates) }
        request.sortDescriptors = [NSSortDescriptor(key: "nombre", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
        do { return try context.fetch(request).map(item) }
        catch { throw ProductError.persistence }
    }

    func categories() throws -> [String] {
        try requireStore()
        let request = NSFetchRequest<NSDictionary>(entityName: "Producto")
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = ["categoria"]
        request.returnsDistinctResults = true
        do {
            let values = try context.fetch(request).compactMap { $0["categoria"] as? String }
            // Group category labels without case differences, preserving a stored label.
            var unique: [String: String] = [:]
            for value in values.sorted() where unique[value.lowercased()] == nil { unique[value.lowercased()] = value }
            return unique.values.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        } catch { throw ProductError.persistence }
    }

    @discardableResult
    func save(id: NSManagedObjectID? = nil, name: String, category: String, price: Double, stock: Int64) throws -> ProductItem {
        try requireSupervisor()
        let name = clean(name), category = clean(category)
        guard !name.isEmpty, !category.isEmpty else { throw ProductError.requiredFields }
        guard price.isFinite, price > 0 else { throw ProductError.invalidPrice }
        guard stock >= 0 else { throw ProductError.invalidStock }
        let product = try id.map(existing) ?? Producto(context: context)
        product.nombre = name
        product.categoria = category
        product.precio = price
        product.stock = stock
        do {
            try context.save()
            return item(product)
        } catch {
            context.rollback()
            throw ProductError.persistence
        }
    }

    func delete(id: NSManagedObjectID) throws {
        try requireSupervisor()
        let product = try existing(id)
        // Give a clear message, while retaining the model's Deny rule as the final guard.
        context.refresh(product, mergeChanges: false)
        guard product.ventas?.count ?? 0 == 0 else { throw ProductError.associatedSales }
        context.delete(product)
        do { try context.save() }
        catch {
            context.rollback()
            let error = error as NSError
            let details = error.userInfo[NSDetailedErrorsKey] as? [NSError] ?? [error]
            if details.contains(where: { $0.code == NSValidationRelationshipDeniedDeleteError }) {
                throw ProductError.associatedSales
            }
            throw ProductError.persistence
        }
    }

    private func existing(_ id: NSManagedObjectID) throws -> Producto {
        do {
            guard let product = try context.existingObject(with: id) as? Producto, !product.isDeleted else { throw ProductError.notFound }
            return product
        } catch { throw ProductError.notFound }
    }

    private func requireStore() throws {
        guard roleProvider() != nil else { throw ProductError.permission }
        guard context.persistentStoreCoordinator?.persistentStores.isEmpty == false else { throw ProductError.persistence }
    }

    private func requireSupervisor() throws {
        guard canManage else { throw ProductError.permission }
        try requireStore()
    }

    private func item(_ product: Producto) -> ProductItem {
        ProductItem(id: product.objectID, name: product.nombre ?? "", category: product.categoria ?? "", price: product.precio, stock: product.stock)
    }

    private func clean(_ text: String) -> String { text.trimmingCharacters(in: .whitespacesAndNewlines) }
}
