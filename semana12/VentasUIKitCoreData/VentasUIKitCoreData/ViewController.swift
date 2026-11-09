import UIKit

/// A1: Login. Instantiated by Main.storyboard inside a navigation controller.
final class ViewController: AuthFormViewController {
    private var usernameField: UITextField!
    private var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = "Ingresar"
        let header = UIView()
        let icon = UIImageView(image: UIImage(systemName: "cart"))
        icon.contentMode = .scaleAspectFit
        icon.tintColor = UIColor(red: 0.72, green: 0.85, blue: 1, alpha: 1)
        icon.backgroundColor = Self.blue
        icon.layer.cornerRadius = 20
        icon.clipsToBounds = true
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36, weight: .regular)
        // Leave breathing room around the symbol, like the reference icon.
        let iconBox = UIView()
        iconBox.backgroundColor = Self.blue
        iconBox.layer.cornerRadius = 20
        iconBox.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(iconBox)
        iconBox.addSubview(icon)
        let title = UILabel()
        title.text = "Ventas Tecsup"
        title.font = .systemFont(ofSize: 27, weight: .bold)
        title.textColor = .black
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        let subtitle = UILabel()
        subtitle.text = "Inicia sesión para continuar"
        subtitle.font = .systemFont(ofSize: 15)
        subtitle.textColor = .secondaryLabel
        subtitle.textAlignment = .center
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(title)
        header.addSubview(subtitle)
        NSLayoutConstraint.activate([
            iconBox.topAnchor.constraint(equalTo: header.topAnchor, constant: 12),
            iconBox.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            iconBox.widthAnchor.constraint(equalToConstant: 84), iconBox.heightAnchor.constraint(equalToConstant: 84),
            icon.centerXAnchor.constraint(equalTo: iconBox.centerXAnchor), icon.centerYAnchor.constraint(equalTo: iconBox.centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 49), icon.heightAnchor.constraint(equalToConstant: 49),
            title.topAnchor.constraint(equalTo: iconBox.bottomAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: header.leadingAnchor), title.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 5),
            subtitle.leadingAnchor.constraint(equalTo: header.leadingAnchor), subtitle.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            subtitle.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -12)
        ])
        stack.addArrangedSubview(header)
        usernameField = field("Usuario", placeholder: "Usuario", id: "login.username", contentType: .username)
        passwordField = field("Clave", placeholder: "Clave", id: "login.password", secure: true, contentType: .password)
        passwordField.returnKeyType = .go
        stack.addArrangedSubview(errorLabel)
        _ = primaryButton("Ingresar", id: "login.submit", action: #selector(login))
        let create = UIButton(type: .system)
        let text = NSMutableAttributedString(string: "¿Primera vez? ", attributes: [.foregroundColor: UIColor.secondaryLabel, .font: UIFont.systemFont(ofSize: 14)])
        text.append(NSAttributedString(string: "Crear cuenta", attributes: [.foregroundColor: Self.blue, .font: UIFont.systemFont(ofSize: 14, weight: .bold)]))
        create.setAttributedTitle(text, for: .normal)
        create.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        create.accessibilityIdentifier = "login.createAccount"
        create.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        stack.addArrangedSubview(create)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        passwordField.text = nil
        errorLabel.isHidden = true
    }

    @objc private func login() {
        do {
            let user = try authentication.login(username: usernameField.text ?? "", password: passwordField.text ?? "")
            completeAuthentication(user)
        } catch { showError(error) }
    }

    @objc private func createAccount() { performSegue(withIdentifier: "showRegistration", sender: nil) }

    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === passwordField { login(); return true }
        return super.textFieldShouldReturn(textField)
    }
}
