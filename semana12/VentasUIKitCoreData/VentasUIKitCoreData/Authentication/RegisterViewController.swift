import UIKit

final class RegisterViewController: AuthFormViewController {
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var confirmationField: UITextField!
    @IBOutlet private weak var availability: UILabel!
    @IBOutlet private weak var roleControl: UISegmentedControl!

    override var fields: [UITextField] { [nameField, usernameField, passwordField, confirmationField] }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @IBAction private func checkAvailability() {
        let username = (usernameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !username.isEmpty else { availability.text = nil; return }
        do {
            let available = try authentication.isUsernameAvailable(username)
            availability.text = available ? "✓ Disponible" : "No disponible"
            availability.textColor = available ? .systemGreen : .systemRed
        } catch {
            availability.text = "Sin conexión a datos"
            availability.textColor = .systemRed
        }
    }

    @IBAction private func register() {
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
