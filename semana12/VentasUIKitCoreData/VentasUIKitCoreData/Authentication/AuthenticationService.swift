import CoreData

enum AuthenticationError: LocalizedError {
    case requiredFields, duplicateUsername, shortPassword, passwordMismatch
    case invalidCredentials, invalidRole, persistence

    var errorDescription: String? {
        switch self {
        case .requiredFields: return "Completa todos los campos."
        case .duplicateUsername: return "Este usuario ya está registrado."
        case .shortPassword: return "La clave debe tener al menos seis caracteres."
        case .passwordMismatch: return "Las claves no coinciden."
        case .invalidCredentials: return "Usuario o clave incorrectos"
        case .invalidRole: return "El usuario no tiene un rol válido."
        case .persistence: return "No se pudo acceder a los datos. Inténtalo nuevamente."
        }
    }
}

@MainActor
final class AuthenticationService {
    // A separate main-queue context prevents a failed registration from
    // discarding pending edits in the application's viewContext.
    private let context: NSManagedObjectContext

    init(container: NSPersistentContainer) {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = container.persistentStoreCoordinator
        context.mergePolicy = NSErrorMergePolicy
    }

    func isUsernameAvailable(_ username: String) throws -> Bool {
        let username = clean(username)
        guard !username.isEmpty else { return false }
        return try findUser(username) == nil
    }

    func login(username: String, password: String) throws -> SessionUser {
        let username = clean(username)
        guard !username.isEmpty, !clean(password).isEmpty else {
            throw AuthenticationError.requiredFields
        }
        guard let user = try findUser(username), user.clave == password else {
            throw AuthenticationError.invalidCredentials
        }
        return try sessionUser(user)
    }

    func register(name: String, username: String, password: String,
                  confirmation: String, role: UserRole) throws -> SessionUser {
        let name = clean(name)
        let username = clean(username)
        guard !name.isEmpty, !username.isEmpty,
              !clean(password).isEmpty, !clean(confirmation).isEmpty else {
            throw AuthenticationError.requiredFields
        }
        guard password.count >= 6 else { throw AuthenticationError.shortPassword }
        guard password == confirmation else { throw AuthenticationError.passwordMismatch }
        guard try isUsernameAvailable(username) else { throw AuthenticationError.duplicateUsername }

        let user = Usuario(context: context)
        user.nombre = name
        user.usuario = username
        user.clave = password
        user.rol = role.rawValue
        do {
            try context.save()
        } catch {
            context.rollback()
            throw AuthenticationError.persistence
        }
        return try sessionUser(user)
    }

    private func findUser(_ username: String) throws -> Usuario? {
        guard context.persistentStoreCoordinator?.persistentStores.isEmpty == false else {
            throw AuthenticationError.persistence
        }
        let request = NSFetchRequest<Usuario>(entityName: "Usuario")
        request.predicate = NSPredicate(format: "usuario ==[c] %@", username)
        request.fetchLimit = 1
        do { return try context.fetch(request).first }
        catch { throw AuthenticationError.persistence }
    }

    private func sessionUser(_ user: Usuario) throws -> SessionUser {
        guard let role = UserRole(rawValue: user.rol ?? "") else {
            throw AuthenticationError.invalidRole
        }
        return SessionUser(objectID: user.objectID, name: user.nombre ?? "",
                           username: user.usuario ?? "", role: role)
    }

    private func clean(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
