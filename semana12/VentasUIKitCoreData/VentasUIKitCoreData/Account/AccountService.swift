import CoreData

struct AccountProfile {
    let name: String
    let username: String
    let role: UserRole
    var initials: String { String(name.split(whereSeparator: \.isWhitespace).prefix(2).compactMap(\.first)).uppercased() }
}

enum AccountError: LocalizedError {
    case signedOut, unavailable
    var errorDescription: String? {
        switch self {
        case .signedOut: return "La sesión ya no está disponible. Inicia sesión nuevamente."
        case .unavailable: return "No se pudo consultar tu cuenta. Inténtalo nuevamente."
        }
    }
}

@MainActor
final class AccountService {
    private let context: NSManagedObjectContext
    private let sessionProvider: () -> SessionUser?
    init(container: NSPersistentContainer, sessionProvider: @escaping () -> SessionUser?) {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        self.sessionProvider = sessionProvider
    }
    func profile() throws -> AccountProfile {
        guard let session = sessionProvider() else { throw AccountError.signedOut }
        guard context.persistentStoreCoordinator?.persistentStores.isEmpty == false else { throw AccountError.unavailable }
        context.reset()
        do {
            guard let user = try context.existingObject(with: session.objectID) as? Usuario,
                  !user.isDeleted, let role = UserRole(rawValue: user.rol ?? ""), role == session.role else {
                throw AccountError.signedOut
            }
            return AccountProfile(name: user.nombre ?? "", username: user.usuario ?? "", role: role)
        } catch let error as AccountError { throw error }
        catch { throw AccountError.unavailable }
    }
}
