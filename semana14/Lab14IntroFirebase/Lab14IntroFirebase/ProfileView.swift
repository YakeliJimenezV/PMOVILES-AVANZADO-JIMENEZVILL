import FirebaseAuth
import SwiftUI

struct ProfileView: View {
    @ObservedObject var session: AuthSession

    private let ink = Color(red: 0.13, green: 0.08, blue: 0.26)
    private let violet = Color(red: 0.44, green: 0.19, blue: 0.65)
    private let pink = Color(red: 1, green: 0.93, blue: 0.96)
    private let accountLocale = Locale(identifier: "es")
    private let lavender = Color(red: 0.91, green: 0.83, blue: 0.99)

    var body: some View {
        ScrollView {
            if let user = session.currentUser {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Mi perfil")
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)

                    identityCard(for: user)
                    accountCard(for: user)

                    if session.pendingName != nil {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tu nombre está pendiente de guardar.")
                                .font(.subheadline)
                            if session.isSavingName {
                                ProgressView("Guardando nombre…")
                            } else {
                                Button("Reintentar guardar nombre") {
                                    Task { await session.savePendingName() }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }

                    Button {
                        session.confirmSignOut = true
                    } label: {
                        Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                            .font(.headline)
                            .padding(.horizontal, 14)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    .buttonStyle(.bordered)
                    .clipShape(Capsule())
                    .disabled(session.isSavingName)
                }
                .frame(maxWidth: 520)
                .padding(20)
                .frame(maxWidth: .infinity)
            }
        }
        .foregroundStyle(ink)
        .background {
            ZStack(alignment: .bottom) {
                LinearGradient(colors: [lavender, pink, lavender],
                               startPoint: .topTrailing, endPoint: .bottomLeading)
                LabWaves(dark: false)
                    .frame(height: 145)
            }
            .ignoresSafeArea()
        }
    }

    private func identityCard(for user: User) -> some View {
        let name = displayName(for: user)

        return VStack(spacing: 6) {
            Text(name?.prefix(1).uppercased() ?? "?")
                .font(.title.bold())
                .foregroundStyle(violet)
                .frame(width: 64, height: 64)
                .background(
                    LinearGradient(colors: [lavender, pink],
                                   startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: Circle()
                )
                .accessibilityHidden(true)
                .padding(.bottom, 4)

            Text(name ?? "Nombre no disponible")
                .font(.title2.bold())
            Text(email(for: user))
                .font(.subheadline)
                .foregroundStyle(ink.opacity(0.78))

            Label("Cuenta registrada", systemImage: "checkmark.circle.fill")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(violet)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(lavender.opacity(0.65), in: Capsule())
                .padding(.top, 4)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(alignment: .center) { cardBackground }
    }

    private func accountCard(for user: User) -> some View {
        let memberSince = user.metadata.creationDate?.formatted(
            .dateTime.day().month(.wide).year().locale(accountLocale)
        ) ?? "Fecha no disponible"
        let accessMethod = user.providerData.contains { $0.providerID == EmailAuthProvider.id }
            ? "Correo y contraseña"
            : "Método no disponible"

        return VStack(alignment: .leading, spacing: 0) {
            Text("Información de mi cuenta")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom, 6)

            accountRow("Nombre completo", value: displayName(for: user) ?? "Nombre no disponible", icon: "person")
            rowDivider
            accountRow("Correo electrónico", value: email(for: user), icon: "envelope")
            rowDivider
            accountRow("Miembro desde", value: memberSince, icon: "calendar")
            rowDivider
            accountRow("Método de acceso", value: accessMethod, icon: "lock.shield")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(alignment: .center) { cardBackground }
    }

    private func accountRow(_ title: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(violet)
                .frame(width: 30, height: 30)
                .background(lavender.opacity(0.5), in: RoundedRectangle(cornerRadius: 9))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(ink.opacity(0.72))
                Text(value)
                    .font(.subheadline.weight(.medium))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.vertical, 7)
        .accessibilityElement(children: .combine)
    }

    private var rowDivider: some View {
        Rectangle()
            .fill(violet.opacity(0.10))
            .frame(height: 1)
            .padding(.leading, 40)
            .accessibilityHidden(true)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(.white.opacity(0.94))
            .shadow(color: violet.opacity(0.11), radius: 10, y: 4)
    }

    private func email(for user: User) -> String {
        let address = user.email?.trimmingCharacters(in: .whitespacesAndNewlines)
        return address.flatMap { $0.isEmpty ? nil : $0 } ?? "Correo no disponible"
    }

    private func displayName(for user: User) -> String? {
        if let name = user.displayName?.trimmingCharacters(in: .whitespacesAndNewlines),
           !name.isEmpty {
            return name
        }

        let localPart = user.email?.split(separator: "@").first ?? ""
        let words = localPart.split { "._+-".contains($0) }
        return words.isEmpty ? nil : words.joined(separator: " ").capitalized
    }
}
