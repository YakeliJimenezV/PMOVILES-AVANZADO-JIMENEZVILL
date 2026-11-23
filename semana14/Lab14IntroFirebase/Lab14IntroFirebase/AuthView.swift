import SwiftUI

struct AuthView: View {
    @ObservedObject var session: AuthSession
    @State private var isCreatingAccount = false
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showsPassword = false

    private enum Field: Hashable {
        case name, email, password
    }

    @FocusState private var focusedField: Field?
    @ScaledMetric(relativeTo: .title) private var badgeSize = 88

    var body: some View {
        GeometryReader { viewport in
            ScrollView {
                VStack(spacing: 24) {
                    header

                    VStack(spacing: 12) {
                        if isCreatingAccount {
                            inputRow("person") {
                                TextField("Nombre completo", text: $fullName,
                                          prompt: Text("Nombre completo").foregroundStyle(.white.opacity(0.8)))
                                    .textContentType(.name)
                                    .textInputAutocapitalization(.words)
                                    .submitLabel(.next)
                                    .focused($focusedField, equals: .name)
                                    .onSubmit { focusedField = .email }
                            }
                        }

                        inputRow("envelope") {
                            TextField("Correo electrónico", text: $email,
                                      prompt: Text("Correo electrónico").foregroundStyle(.white.opacity(0.8)))
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .submitLabel(.next)
                                .focused($focusedField, equals: .email)
                                .onSubmit { focusedField = .password }
                        }

                        inputRow("lock") {
                            Group {
                                if showsPassword {
                                    TextField("Contraseña", text: $password, prompt: passwordPrompt)
                                } else {
                                    SecureField("Contraseña", text: $password, prompt: passwordPrompt)
                                }
                            }
                            .textContentType(isCreatingAccount ? .newPassword : .password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .submitLabel(.go)
                            .focused($focusedField, equals: .password)
                            .onSubmit { submit() }

                            Button {
                                let wasFocused = focusedField == .password
                                showsPassword.toggle()
                                if wasFocused {
                                    Task { @MainActor in focusedField = .password }
                                }
                            } label: {
                                Image(systemName: showsPassword ? "eye.slash" : "eye")
                                    .font(.title3)
                                    .frame(width: 44, height: 48)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(showsPassword ? "Ocultar contraseña" : "Mostrar contraseña")
                        }
                    }
                    .disabled(session.isWorking)

                    VStack(spacing: 12) {
                        Button {
                            submit()
                        } label: {
                            Text(isCreatingAccount ? "Crear cuenta" : "Iniciar sesión")
                                .font(.headline)
                                .foregroundStyle(Color(red: 0.17, green: 0.09, blue: 0.31))
                                .padding(.vertical, 13)
                                .frame(maxWidth: .infinity, minHeight: 52)
                                .background(
                                    LinearGradient(colors: [
                                        Color(red: 1, green: 0.83, blue: 0.94),
                                        Color(red: 0.79, green: 0.61, blue: 0.98)
                                    ], startPoint: .topLeading, endPoint: .bottomTrailing),
                                    in: Capsule()
                                )
                                .shadow(color: .black.opacity(0.24), radius: 8, y: 4)
                        }

                        Button {
                            focusedField = nil
                            isCreatingAccount.toggle()
                            fullName = ""
                            password = ""
                            showsPassword = false
                        } label: {
                            Text(isCreatingAccount ? "Ya tengo cuenta" : "Crear cuenta")
                                .font(.headline)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(.white.opacity(0.06), in: Capsule())
                                .overlay { Capsule().strokeBorder(Color(red: 0.86, green: 0.72, blue: 0.98), lineWidth: 1.5) }
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(session.isWorking)
                    .opacity(session.isWorking ? 0.65 : 1)

                    if session.isWorking {
                        ProgressView(isCreatingAccount ? "Creando cuenta…" : "Comprobando credenciales…")
                            .tint(.white)
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 23)
                .padding(.vertical, 24)
                .frame(maxWidth: 420)
                .frame(minHeight: max(0, viewport.size.height - 88))
                .frame(maxWidth: .infinity)
            }
            .scrollBounceBehavior(.basedOnSize)
            .scrollDismissesKeyboard(.interactively)
        }
        .background {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [
                    Color(red: 0.14, green: 0.09, blue: 0.27),
                    Color(red: 0.23, green: 0.16, blue: 0.41),
                    Color(red: 0.15, green: 0.10, blue: 0.29)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)

                RadialGradient(colors: [Color.purple.opacity(0.3), .clear],
                               center: .trailing, startRadius: 0, endRadius: 300)

                LabWaves(dark: true)
                    .frame(height: 142)
            }
            .ignoresSafeArea()
        }
        .environment(\.colorScheme, .dark)
    }

    private var header: some View {
        VStack(spacing: 12) {
            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.title.weight(.semibold))
                .frame(width: badgeSize, height: badgeSize)
                .background(
                    LinearGradient(colors: [
                        Color(red: 0.77, green: 0.54, blue: 0.98),
                        Color(red: 0.39, green: 0.17, blue: 0.66),
                        Color(red: 0.58, green: 0.26, blue: 0.52)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 23)
                )
                .overlay { RoundedRectangle(cornerRadius: 23).strokeBorder(.white.opacity(0.35)) }
                .shadow(color: .black.opacity(0.25), radius: 12, y: 7)
                .accessibilityHidden(true)
                .padding(.bottom, 4)

            Text("Zavia-Lab14")
                .font(.largeTitle.bold())
                .accessibilityAddTraits(.isHeader)
            VStack(spacing: 6) {
                Text("Conecta, conversa y comparte.")
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.9))
                Text(isCreatingAccount
                     ? "Crea una cuenta para participar en el chat."
                     : "Inicia sesión para participar en el chat.")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.8))
            }
        }
        .multilineTextAlignment(.center)
    }

    private var passwordPrompt: Text {
        Text("Contraseña").foregroundStyle(.white.opacity(0.8))
    }

    private func inputRow<Content: View>(_ icon: String, @ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 24)
                .accessibilityHidden(true)
            content()
        }
        .padding(.leading, 17)
        .padding(.trailing, 8)
        .frame(minHeight: 50)
        .background(.white.opacity(0.10), in: Capsule())
        .overlay { Capsule().strokeBorder(.white.opacity(0.18)) }
    }

    private func submit() {
        focusedField = nil
        Task {
            await session.authenticate(email: email, password: password, fullName: isCreatingAccount ? fullName : nil)
        }
    }
}

struct LabWaves: View {
    let dark: Bool

    var body: some View {
        ZStack {
            Wave(offset: 0)
                .fill(LinearGradient(colors: dark
                     ? [Color(red: 0.98, green: 0.64, blue: 0.89), Color(red: 0.40, green: 0.25, blue: 0.70)]
                     : [Color(red: 0.99, green: 0.79, blue: 0.97), Color(red: 0.78, green: 0.65, blue: 0.96)],
                     startPoint: .topTrailing, endPoint: .bottomLeading))
            Wave(offset: 0.27)
                .fill(Color(red: 0.48, green: 0.32, blue: 0.76).opacity(dark ? 0.65 : 0.24))
        }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }

    private struct Wave: Shape {
        let offset: CGFloat

        func path(in rect: CGRect) -> Path {
            let width = rect.width
            let height = rect.height
            return Path { path in
                path.move(to: CGPoint(x: 0, y: height * (0.42 + offset)))
                path.addCurve(to: CGPoint(x: width * 0.56, y: height * (0.58 + offset)),
                              control1: CGPoint(x: width * 0.27, y: height * (-0.12 + offset)),
                              control2: CGPoint(x: width * 0.39, y: height * (0.65 + offset)))
                path.addCurve(to: CGPoint(x: width, y: height * (0.08 + offset)),
                              control1: CGPoint(x: width * 0.79, y: height * (0.49 + offset)),
                              control2: CGPoint(x: width * 0.81, y: height * (0.12 + offset)))
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.closeSubpath()
            }
        }
    }
}
