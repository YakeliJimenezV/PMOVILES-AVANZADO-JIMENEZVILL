import CoreData

enum UserRole: String, CaseIterable {
    case vendedor = "Vendedor"
    case supervisor = "Supervisor"

    var tabs: [String] {
        switch self {
        case .vendedor: return ["Productos", "Clientes", "Ventas", "Mis ventas", "Cuenta"]
        case .supervisor: return ["Resumen", "Ventas", "Productos", "Clientes", "Cuenta"]
        }
    }
}

struct SessionUser {
    let objectID: NSManagedObjectID
    let name: String
    let username: String
    let role: UserRole
}

/// The session lasts only while the application process is alive.
@MainActor
final class SessionManager {
    static let shared = SessionManager()
    private(set) var currentUser: SessionUser?

    func start(_ user: SessionUser) { currentUser = user }
    func end() { currentUser = nil }
}
