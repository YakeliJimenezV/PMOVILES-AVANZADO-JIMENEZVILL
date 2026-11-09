import UIKit

/// A2: Registration, reached through the storyboard's showRegistration segue.
final class RegisterViewController: AuthFormViewController {
    private var nameField: UITextField!
    private var usernameField: UITextField!
    private var passwordField: UITextField!
    private var confirmationField: UITextField!
    private let availability = UILabel()
    private let roleControl = UISegmentedControl(items: UserRole.allCases.map(\.rawValue))

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Crear cuenta"
        nameField = field("Nombre completo", placeholder: "Nombre completo", id: "register.name", contentType: .name)
        usernameField = field("Usuario", placeholder: "Usuario", id: "register.username", contentType: .username)
        availability.font = .systemFont(ofSize: 12)
        availability.accessibilityIdentifier = "register.availability"
        usernameField.rightView = availability
        usernameField.rightViewMode = .always
        usernameField.addTarget(self, action: #selector(checkAvailability), for: .editingChanged)
        passwordField = field("Clave (mínimo 6 caracteres)", placeholder: "Clave", id: "register.password", secure: true, contentType: .newPassword)
        confirmationField = field("Confirmar clave", placeholder: "Confirmar clave", id: "register.confirmation", secure: true, contentType: .newPassword)
        confirmationField.returnKeyType = .done
        let roleLabel = UILabel()
        roleLabel.text = "TU ROL"
        roleLabel.textColor = .secondaryLabel
        roleLabel.font = .systemFont(ofSize: 12)
        stack.addArrangedSubview(roleLabel)
        roleControl.selectedSegmentIndex = 0
        roleControl.accessibilityIdentifier = "register.role"
        roleControl.heightAnchor.constraint(greaterThanOrEqualToConstant: 34).isActive = true
        stack.addArrangedSubview(roleControl)
        stack.addArrangedSubview(errorLabel)
        _ = primaryButton("Registrarme", id: "register.submit", action: #selector(register))
        let note = UILabel()
        note.text = "Al registrarte entrarás directamente a la app con las pestañas de tu rol."
        note.font = .systemFont(ofSize: 13)
        note.textColor = .secondaryLabel
        note.textAlignment = .center
        note.numberOfLines = 0
        stack.addArrangedSubview(note)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func checkAvailability() {
        let username = (usernameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !username.isEmpty else { availability.text = nil; availability.sizeToFit(); return }
        do {
            let available = try authentication.isUsernameAvailable(username)
            availability.text = available ? "✓ Disponible" : "No disponible"
            availability.textColor = available ? .systemGreen : .systemRed
        } catch {
            availability.text = "Sin conexión a datos"
            availability.textColor = .systemRed
        }
        availability.sizeToFit()
    }

    @objc private func register() {
        do {
            let role = UserRole.allCases[roleControl.selectedSegmentIndex]
            let user = try authentication.register(name: nameField.text ?? "", username: usernameField.text ?? "",
                                                   password: passwordField.text ?? "", confirmation: confirmationField.text ?? "", role: role)
            completeAuthentication(user)
        } catch { showError(error); checkAvailability() }
    }

    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === confirmationField { register(); return true }
        return super.textFieldShouldReturn(textField)
    }
}
