import XCTest
import CoreData
import UIKit
@testable import VentasUIKitCoreData

@MainActor
final class CommerceWorkflowTests: XCTestCase {
    // Use the compiled production model and SQLite so fetch predicates and delete
    // rules execute against the same store type used by the application.
    private func store() throws -> NSPersistentContainer {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let app = try XCTUnwrap(UIApplication.shared.delegate as? AppDelegate)
        let container = NSPersistentContainer(name: "VentasUIKitCoreData",
                                              managedObjectModel: app.persistentContainer.managedObjectModel)
        try container.persistentStoreCoordinator.addPersistentStore(
            ofType: NSSQLiteStoreType, configurationName: nil,
            at: directory.appendingPathComponent("ventas.sqlite"), options: nil)
        addTeardownBlock { try FileManager.default.removeItem(at: directory) }
        return container
    }

    private func user(_ auth: AuthenticationService, _ name: String, _ role: UserRole) throws -> SessionUser {
        try auth.register(name: name, username: name, password: "123456", confirmation: "123456", role: role)
    }

    func testAuthenticationCataloguesAndRoleRestrictions() throws {
        let container = try store()
        let auth = AuthenticationService(container: container)
        let supervisor = try user(auth, "María Paz", .supervisor)
        var session: SessionUser? = supervisor
        let commerce = CommerceService(container: container) { session }
        let inventory = ProductService(container: container) { session?.role }
        let reports = SupervisorService(container: container) { session }
        let account = AccountService(container: container) { session }

        XCTAssertEqual(try account.profile().initials, "MP")
        XCTAssertEqual(try auth.login(username: "  MARÍA PAZ ", password: "123456").objectID, supervisor.objectID)
        XCTAssertFalse(try auth.isUsernameAvailable("maría paz"))
        XCTAssertThrowsError(try user(auth, "MARÍA PAZ", .vendedor))
        XCTAssertThrowsError(try auth.login(username: supervisor.username, password: "bad"))
        XCTAssertThrowsError(try auth.register(name: "a", username: "a", password: "123", confirmation: "123", role: .vendedor))
        XCTAssertThrowsError(try auth.register(name: "a", username: "a", password: "123456", confirmation: "654321", role: .vendedor))

        let product = try inventory.save(name: "Lápiz", category: "Útiles", price: 10, stock: 12)
        XCTAssertEqual(product.stockLevel, .available)
        let edited = try inventory.save(id: product.id, name: "Lápiz negro", category: "Útiles", price: 15, stock: 3)
        XCTAssertEqual(edited.stockLevel, .low)
        XCTAssertEqual(StockLevel.level(for: 0), .outOfStock)
        XCTAssertEqual(try inventory.products(search: "lapiz", category: "útiles").map(\.name), ["Lápiz negro"])
        XCTAssertEqual(try inventory.categories(), ["Útiles"])
        XCTAssertThrowsError(try inventory.save(name: "Inválido", category: "x", price: 0, stock: 0))
        XCTAssertThrowsError(try inventory.save(name: "Inválido", category: "x", price: 1, stock: -1))
        let client = try commerce.saveClient(name: "José", document: "AB1")
        XCTAssertThrowsError(try commerce.saveClient(name: "Otro", document: " ab1 "))
        let updated = try commerce.saveClient(id: client.id, name: "José Ruiz", document: "AB2")
        XCTAssertEqual(try commerce.clients(search: "jose").first?.name, updated.name)
        XCTAssertEqual(try commerce.clients(search: "ab2").map(\.id), [client.id])

        session = try user(auth, "Ana", .vendedor)
        XCTAssertThrowsError(try inventory.delete(id: product.id))
        XCTAssertThrowsError(try inventory.save(name: "X", category: "X", price: 1, stock: 4))
        XCTAssertThrowsError(try commerce.deleteClient(id: client.id))
        XCTAssertThrowsError(try reports.sales())
        XCTAssertThrowsError(try reports.dashboard())
        session = supervisor
        XCTAssertThrowsError(try commerce.mySales())
        try commerce.deleteClient(id: client.id)
        try inventory.delete(id: product.id)
        XCTAssertTrue(try commerce.clients().isEmpty)
        XCTAssertTrue(try inventory.products().isEmpty)
        session = nil
        XCTAssertThrowsError(try account.profile())
        XCTAssertThrowsError(try commerce.clients())
    }

    func testVIPStockCancellationAndSummariesAcrossSellers() throws {
        let container = try store()
        let auth = AuthenticationService(container: container)
        let manager = try user(auth, "Gerente", .supervisor)
        let first = try user(auth, "Ana", .vendedor)
        let second = try user(auth, "Luis", .vendedor)
        var session = manager
        let commerce = CommerceService(container: container) { session }
        let inventory = ProductService(container: container) { session.role }
        let supervisor = SupervisorService(container: container) { session }
        let item = try inventory.save(name: "Equipo", category: "Oficina", price: 5000, stock: 5)
        let client = try commerce.saveClient(name: "Alicia", document: "100")
        session = first
        let request = UUID()
        XCTAssertThrowsError(try commerce.registerSale(clientID: client.id, productID: item.id, quantity: 6, requestID: request))
        XCTAssertEqual(try commerce.products().first?.stock, 5)
        let original = try commerce.registerSale(clientID: client.id, productID: item.id, quantity: 1, requestID: request)
        XCTAssertThrowsError(try commerce.registerSale(clientID: client.id, productID: item.id, quantity: 1, requestID: request))
        XCTAssertEqual(original.total, 5900)
        XCTAssertEqual(try commerce.clients().first?.tier, .vip)
        session = second
        XCTAssertTrue(try commerce.mySales().isEmpty)
        let quote = try commerce.quote(clientID: client.id, productID: item.id, quantity: 2)
        XCTAssertEqual(quote.amounts.subtotal, 10000)
        XCTAssertEqual(quote.amounts.discount, 1000)
        XCTAssertEqual(quote.amounts.tax, 1620)
        XCTAssertEqual(quote.amounts.total, 10620)
        let sale = try commerce.registerSale(clientID: client.id, productID: item.id, quantity: 2, requestID: UUID())
        XCTAssertEqual(try commerce.products().first?.stock, 2)
        XCTAssertEqual(try commerce.mySales(search: "ali", period: .month).map(\.id), [sale.id])
        XCTAssertEqual(try commerce.summary(period: .today).total, 10620)
        XCTAssertThrowsError(try supervisor.cancelSale(id: sale.id, reason: "error"))

        session = manager
        XCTAssertEqual(try supervisor.sales(period: .today, sellerID: second.objectID, search: "ali").map(\.id), [sale.id])
        let dashboard = try supervisor.dashboard()
        XCTAssertEqual(dashboard.soldToday, 16520)
        XCTAssertEqual(dashboard.monthlyTax, 2520)
        XCTAssertEqual(dashboard.days.count, 7)
        XCTAssertEqual(dashboard.days.last?.total, dashboard.soldToday)
        XCTAssertEqual(dashboard.ranking.map(\.name), ["Luis", "Ana"])
        XCTAssertEqual(dashboard.lowStock.map(\.stock), [2])
        XCTAssertThrowsError(try supervisor.cancelSale(id: sale.id, reason: "  "))
        XCTAssertEqual(try commerce.products().first?.stock, 2)
        try supervisor.cancelSale(id: sale.id, reason: "  Devolución  ")
        XCTAssertThrowsError(try supervisor.cancelSale(id: sale.id, reason: "otra"))
        XCTAssertEqual(try commerce.products().first?.stock, 4)
        XCTAssertEqual(try supervisor.sales(sellerID: second.objectID).first?.reason, "Devolución")
        XCTAssertEqual(try supervisor.dashboard().soldToday, 5900)
        XCTAssertEqual(try supervisor.dashboard().ranking.map(\.name), ["Ana"])
        try supervisor.cancelSale(id: original.id, reason: "Corrección")
        XCTAssertEqual(try commerce.clients().first?.tier, .regular)
        XCTAssertEqual(try commerce.products().first?.stock, 5)
        XCTAssertThrowsError(try inventory.delete(id: item.id))
        XCTAssertThrowsError(try commerce.deleteClient(id: client.id))
        session = second
        XCTAssertTrue(try XCTUnwrap(commerce.mySales().first).cancelled)
        XCTAssertEqual(try commerce.summary(period: .month).count, 0)
    }
}
