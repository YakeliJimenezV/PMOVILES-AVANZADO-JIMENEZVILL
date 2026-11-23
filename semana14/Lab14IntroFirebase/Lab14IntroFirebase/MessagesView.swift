import SwiftUI

struct MessagesView: View {
    let userID: String
    @ObservedObject var session: AuthSession
    @StateObject private var database = DatabaseService()
    @State private var draft = ""
    @State private var isSending = false
    @State private var isNearLatest = true
    @State private var shouldFollowUpdate = false

    private let timelineSpace = "messageTimeline"
    private let bottomAnchor = "timelineBottom"

    private let ink = Color(red: 0.13, green: 0.08, blue: 0.26)
    private let violet = Color(red: 0.44, green: 0.19, blue: 0.65)
    private let surface = Color(red: 1, green: 0.98, blue: 1)
    private let pink = Color(red: 1, green: 0.93, blue: 0.96)
    private let lavender = Color(red: 0.91, green: 0.83, blue: 0.99)

    var body: some View {
        VStack(spacing: 0) {
            header
            timeline
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(alignment: .bottom) {
                    LabWaves(dark: false)
                        .frame(height: 145)
                }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            composer
        }
        .foregroundStyle(ink)
        .background {
            LinearGradient(colors: [lavender, pink, lavender],
                           startPoint: .topTrailing, endPoint: .bottomLeading)
                .ignoresSafeArea()
        }
        .environment(\.colorScheme, .light)
        .onAppear { database.startListening(userID: userID) }
        .onDisappear { database.stopListening() }
    }

    private var header: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) {
                chatIdentity.fixedSize(horizontal: true, vertical: false)
                Spacer(minLength: 0)
                signOutButton.fixedSize(horizontal: true, vertical: false)
            }

            VStack(alignment: .leading, spacing: 8) {
                chatIdentity
                signOutButton
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal, 18)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }

    private var chatIdentity: some View {
        HStack(spacing: 10) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.headline)
                .foregroundStyle(violet)
                .frame(width: 44, height: 44)
                .background(lavender, in: Circle())
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Zavia-Lab14")
                    .font(.title2.bold())
                Text("Chat general")
                    .font(.subheadline)
                    .foregroundStyle(ink.opacity(0.76))
            }
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)
        }
    }

    private var signOutButton: some View {
        Button {
            session.confirmSignOut = true
        } label: {
            Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .frame(minHeight: 44)
                .background(surface, in: Capsule())
                .shadow(color: violet.opacity(0.18), radius: 7, y: 3)
        }
        .buttonStyle(.plain)
        .disabled(session.isSavingName)
    }

    @ViewBuilder
    private var timeline: some View {
        if database.isLoading {
            ProgressView("Cargando mensajes…")
                .tint(violet)
        } else if let error = database.listeningError {
            ScrollView {
                ContentUnavailableView {
                    Label("No se pudieron cargar los mensajes", systemImage: "exclamationmark.bubble")
                } description: {
                    Text(error)
                } actions: {
                    Button("Reintentar") { database.startListening(userID: userID) }
                        .buttonStyle(.bordered)
                        .tint(violet)
                }
            }
        } else if database.messages.isEmpty {
            GeometryReader { viewport in
                ScrollView {
                    emptyState
                        .frame(maxWidth: .infinity, minHeight: viewport.size.height)
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollDismissesKeyboard(.interactively)
            }
        } else {
            conversation
        }
    }

    private var conversation: some View {
        GeometryReader { viewport in
            ScrollViewReader { scroll in
                ScrollView {
                    VStack(spacing: 0) {
                        LazyVStack(spacing: 10) {
                            let email = normalizedEmail(session.currentUser?.email)
                            let bubbleWidth = max(0, min(viewport.size.width, 600) * 0.78)
                            ForEach(database.messages) { message in
                                let isOwn = email != nil && email == normalizedEmail(message.userEmail)
                                messageBubble(message, isOwn: isOwn, maxWidth: bubbleWidth)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 5)
                        .padding(.bottom, 12)

                        Color.clear
                            .frame(height: 1)
                            .background {
                                GeometryReader { marker in
                                    Color.clear.preference(
                                        key: NearLatestKey.self,
                                        value: marker.frame(in: .named(timelineSpace)).maxY
                                            <= viewport.size.height + 72
                                    )
                                }
                            }
                            .id(bottomAnchor)
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: 600)
                    .frame(maxWidth: .infinity)
                }
                .coordinateSpace(name: timelineSpace)
                .scrollDismissesKeyboard(.interactively)
                .onPreferenceChange(NearLatestKey.self) { isNearLatest = $0 }
                .onAppear {
                    isNearLatest = true
                    scroll.scrollTo(bottomAnchor, anchor: .bottom)
                }
                // Capture the reader's position before the snapshot changes the content height.
                .onReceive(database.$messages) { _ in shouldFollowUpdate = isNearLatest }
                .onChange(of: database.messages.last?.id) {
                    guard shouldFollowUpdate else { return }
                    withAnimation(.easeOut(duration: 0.22)) {
                        scroll.scrollTo(bottomAnchor, anchor: .bottom)
                    }
                }
            }
        }
    }

    private struct NearLatestKey: PreferenceKey {
        static let defaultValue = true

        static func reduce(value: inout Bool, nextValue: () -> Bool) {
            value = value && nextValue()
        }
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "ellipsis.bubble.fill")
                .font(.system(size: 58))
                .foregroundStyle(violet.opacity(0.82))
                .frame(width: 142, height: 116)
                .background(lavender.opacity(0.66), in: Ellipse())
                .accessibilityHidden(true)
                .padding(.bottom, 6)

            Text("Aún no hay mensajes")
                .font(.title2.bold())
            Text("Envía un mensaje para comenzar la conversación.")
                .font(.body)
                .foregroundStyle(ink.opacity(0.88))
                .frame(maxWidth: 245)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
    }

    private func messageBubble(_ message: Message, isOwn: Bool, maxWidth: CGFloat) -> some View {
        Grid(alignment: .leading, verticalSpacing: 5) {
            if !isOwn {
                GridRow {
                    Text(message.userEmail)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(violet)
                }
            }

            GridRow {
                Text(message.text)
                    .fixedSize(horizontal: false, vertical: true)
            }

            GridRow {
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(isOwn ? .white.opacity(0.88) : ink.opacity(0.68))
                    .gridCellAnchor(.trailing)
            }
        }
        .multilineTextAlignment(.leading)
        .foregroundStyle(isOwn ? .white : ink)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            isOwn ? violet : surface,
            in: UnevenRoundedRectangle(
                topLeadingRadius: 19,
                bottomLeadingRadius: isOwn ? 19 : 5,
                bottomTrailingRadius: isOwn ? 5 : 19,
                topTrailingRadius: 19
            )
        )
        .frame(maxWidth: maxWidth, alignment: isOwn ? .trailing : .leading)
        .accessibilityElement(children: .combine)
        .frame(maxWidth: .infinity, alignment: isOwn ? .trailing : .leading)
    }

    private func normalizedEmail(_ email: String?) -> String? {
        guard let value = email?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(),
              !value.isEmpty else { return nil }
        return value
    }

    private var composer: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Escribe un mensaje", text: $draft, axis: .vertical)
                .lineLimit(1...4)
                .padding(.horizontal, 16)
                .padding(.vertical, 11)
                .frame(minHeight: 46)
                .background(surface, in: RoundedRectangle(cornerRadius: 23))
                .shadow(color: violet.opacity(0.13), radius: 5, y: 2)
                .disabled(isSending)

            Button(action: send) {
                ZStack {
                    if isSending {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .font(.body.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 48, height: 48)
                .background(
                    LinearGradient(colors: [Color(red: 0.66, green: 0.32, blue: 0.84), violet],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: Circle()
                )
            }
            .buttonStyle(.plain)
            .disabled(isSending || draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(!isSending && draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.72 : 1)
            .accessibilityLabel(isSending ? "Enviando mensaje" : "Enviar")
        }
        .frame(maxWidth: 600)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background {
            LinearGradient(colors: [pink, lavender.opacity(0.9)],
                           startPoint: .leading, endPoint: .trailing)
                .ignoresSafeArea(.container, edges: .bottom)
        }
    }

    private func send() {
        guard !isSending else { return }
        isSending = true
        Task {
            defer { isSending = false }
            do {
                try await database.send(draft, userID: userID)
                draft = ""
            } catch {
                session.errorMessage = error.localizedDescription
            }
        }
    }
}
