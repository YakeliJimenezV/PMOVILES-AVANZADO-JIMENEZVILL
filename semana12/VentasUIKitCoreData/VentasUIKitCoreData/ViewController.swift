import UIKit

final class ViewController: AuthFormViewController {
    @IBOutlet private weak var usernameField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    override var fields: [UITextField] { [usernameField, passwordField] }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        passwordField.text = nil
        errorLabel.isHidden = true
    }

    @IBAction private func login() {
        do {
            let user = try authentication.login(username: usernameField.text ?? "", password: passwordField.text ?? "")
            completeAuthentication(user)
        } catch { showError(error) }
    }

    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === passwordField { login(); return true }
        return super.textFieldShouldReturn(textField)
    }
}
