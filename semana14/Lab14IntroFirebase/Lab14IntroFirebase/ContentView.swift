import FirebaseAuth
import SwiftUI

struct ContentView: View {
    @StateObject private var session = AuthSession()

    var body: some View {
        Group {
            if !session.isReady {
                ProgressView("Comprobando sesión…")
            } else if let userID = session.userID, !session.isWorking {
                SessionTabs(userID: userID, session: session)
                    .id(userID)
            } else {
                AuthView(session: session)
            }
        }
        .alert("Ocurrió un error", isPresented: Binding(
            get: { session.errorMessage != nil },
            set: { if !$0 { session.errorMessage = nil } }
        )) {
            Button("Aceptar", role: .cancel) {}
        } message: {
            Text(session.errorMessage ?? "")
        }
    }
}

private struct SessionTabs: View {
    let userID: String
    @ObservedObject var session: AuthSession
    @State private var selection = Section.messages

    private enum Section {
        case messages, profile
    }

    var body: some View {
        TabView(selection: $selection) {
            MessagesView(userID: userID, session: session)
                .tabItem { Label("Mensajes", systemImage: "bubble.left.and.bubble.right") }
                .tag(Section.messages)

            ProfileView(session: session)
                .tabItem { Label("Mi perfil", systemImage: "person.crop.circle") }
                .tag(Section.profile)
        }
        .tint(Color(red: 0.44, green: 0.19, blue: 0.65))
        .environment(\.colorScheme, .light)
        .alert("¿Quieres cerrar sesión?", isPresented: $session.confirmSignOut) {
            Button("Cerrar sesión", role: .destructive) { session.signOut() }
            Button("Cancelar", role: .cancel) {}
        }
    }
}

@MainActor
final class AuthSession: ObservableObject {
    @Published private(set) var isReady = false
    @Published private(set) var userID: String?
    @Published private(set) var isWorking = false
    @Published private(set) var pendingName: String?
    @Published private(set) var isSavingName = false
    @Published var errorMessage: String?
    @Published var confirmSignOut = false

    private let auth: Auth
    private var listener: AuthStateDidChangeListenerHandle?

    var currentUser: User? { auth.currentUser }

    init() {
        let auth = Auth.auth()
        self.auth = auth
        listener = auth.addStateDidChangeListener { [weak self] _, _ in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let userID = self.currentUser?.uid
                self.pendingName = userID.flatMap {
                    UserDefaults.standard.string(forKey: self.pendingNameKey(for: $0))
                }
                self.userID = userID
                self.isReady = true
            }
        }
    }

    deinit {
        if let listener {
            auth.removeStateDidChangeListener(listener)
        }
    }

    func authenticate(email: String, password: String, fullName: String?) async {
        guard !isWorking else { return }

        let name = fullName?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard name != "" else {
            errorMessage = "Ingresa tu nombre completo."
            return
        }
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard email.range(of: #"^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$"#,
                          options: .regularExpression) != nil else {
            errorMessage = "Ingresa un correo electrónico válido."
            return
        }
        guard !password.isEmpty else {
            errorMessage = "Ingresa tu contraseña."
            return
        }
        guard name == nil || password.count >= 6 else {
            errorMessage = "La contraseña debe tener al menos seis caracteres."
            return
        }

        isWorking = true
        defer { isWorking = false }
        do {
            if let name {
                let result = try await auth.createUser(withEmail: email, password: password)
                UserDefaults.standard.set(name, forKey: pendingNameKey(for: result.user.uid))
                pendingName = name
                await savePendingName()
            } else {
                _ = try await auth.signIn(withEmail: email, password: password)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func savePendingName() async {
        guard !isSavingName, let user = currentUser,
              let name = UserDefaults.standard.string(forKey: pendingNameKey(for: user.uid)) else { return }

        isSavingName = true
        defer { isSavingName = false }
        let request = user.createProfileChangeRequest()
        request.displayName = name

        do {
            try await request.commitChanges()
            UserDefaults.standard.removeObject(forKey: pendingNameKey(for: user.uid))
            if currentUser?.uid == user.uid {
                pendingName = nil
            }
        } catch {
            if currentUser?.uid == user.uid {
                errorMessage = "Tu cuenta está registrada. Puedes reintentar guardar tu nombre desde Mi perfil.\n\n\(error.localizedDescription)"
            }
        }
    }

    func signOut() {
        guard !isSavingName else { return }
        do {
            try auth.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func pendingNameKey(for userID: String) -> String {
        "registration.pendingDisplayName.\(userID)"
    }
}
