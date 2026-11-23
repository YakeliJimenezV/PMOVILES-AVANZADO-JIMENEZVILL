import Combine
import FirebaseAuth
import FirebaseFirestore
import Foundation

struct Message: Identifiable, Codable {
    let id: String
    let text: String
    let userEmail: String
    let timestamp: Date
}

@MainActor
final class DatabaseService: ObservableObject {
    @Published private(set) var messages: [Message] = []
    @Published private(set) var isLoading = true
    @Published private(set) var listeningError: String?

    private let collection = Firestore.firestore().collection("messages")
    private var listener: ListenerRegistration?
    private var subscriptionID: UUID?

    deinit {
        listener?.remove()
    }

    func startListening(userID: String) {
        guard listener == nil, Auth.auth().currentUser?.uid == userID else { return }

        let subscriptionID = UUID()
        self.subscriptionID = subscriptionID
        isLoading = true
        listeningError = nil
        listener = collection.order(by: "timestamp").addSnapshotListener { [weak self] snapshot, error in
            let messages = snapshot?.documents.compactMap { try? $0.data(as: Message.self) }
            let errorMessage = error?.localizedDescription

            DispatchQueue.main.async { [weak self] in
                guard let self, self.subscriptionID == subscriptionID,
                      Auth.auth().currentUser?.uid == userID else { return }

                self.isLoading = false
                self.listeningError = errorMessage
                if let messages {
                    self.messages = messages
                }
                if errorMessage != nil {
                    self.stopListening()
                }
            }
        }
    }

    func stopListening() {
        subscriptionID = nil
        listener?.remove()
        listener = nil
    }

    func send(_ text: String, userID: String) async throws {
        guard let user = Auth.auth().currentUser, user.uid == userID,
              let email = user.email else {
            throw SendError.sessionRequired
        }

        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let document = collection.document()
        let message = Message(id: document.documentID, text: text, userEmail: email, timestamp: .now)
        try await document.setData(Firestore.Encoder().encode(message))
    }

    private enum SendError: LocalizedError {
        case sessionRequired

        var errorDescription: String? {
            "Inicia sesión con tu correo para enviar mensajes."
        }
    }
}
