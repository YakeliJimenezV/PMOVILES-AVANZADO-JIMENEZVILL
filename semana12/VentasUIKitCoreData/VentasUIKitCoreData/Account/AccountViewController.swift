import UIKit

final class AccountViewController: CommerceViewController {
    private lazy var account = AccountService(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        SessionManager.shared.currentUser
    }
    private let avatar = CommerceUI.label(size: 30, bold: true, color: .white)
    private let nameLabel = CommerceUI.label(size: 23, bold: true)
    private let usernameLabel = CommerceUI.label(size: 16)
    private let roleLabel = CommerceUI.label(size: 16)
    private let errorLabel = CommerceUI.label(size: 13, color: .systemRed)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mi cuenta"
        navigationController?.tabBarItem.title = "Cuenta"
        content.removeFromSuperview()
        let scroll = UIScrollView(); scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll); scroll.addSubview(content)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor), scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 24), content.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            content.centerXAnchor.constraint(equalTo: scroll.frameLayoutGuide.centerXAnchor), content.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -32)
        ])
        let avatarContainer = UIView()
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.textAlignment = .center
        avatar.backgroundColor = AuthFormViewController.blue
        avatar.layer.cornerRadius = 44; avatar.clipsToBounds = true
        avatarContainer.addSubview(avatar)
        NSLayoutConstraint.activate([
            avatar.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor), avatar.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
            avatar.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor), avatar.widthAnchor.constraint(equalToConstant: 88), avatar.heightAnchor.constraint(equalToConstant: 88)
        ])
        avatar.accessibilityIdentifier = "account.initials"
        nameLabel.textAlignment = .center; nameLabel.accessibilityIdentifier = "account.name"
        usernameLabel.accessibilityIdentifier = "account.username"; roleLabel.accessibilityIdentifier = "account.role"
        content.addArrangedSubview(CommerceUI.card([avatarContainer, nameLabel], spacing: 16))
        content.addArrangedSubview(CommerceUI.card([
            CommerceUI.label("USUARIO", size: 11, bold: true, color: .secondaryLabel), usernameLabel,
            CommerceUI.label("ROL", size: 11, bold: true, color: .secondaryLabel), roleLabel
        ]))
        errorLabel.isHidden = true; content.addArrangedSubview(errorLabel)
        let logout = UIButton(type: .system)
        logout.setTitle("Cerrar sesión", for: .normal)
        logout.setTitleColor(.white, for: .normal); logout.backgroundColor = .systemRed
        logout.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        logout.layer.cornerRadius = 13; logout.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logout.accessibilityIdentifier = "account.logout"
        logout.addTarget(self, action: #selector(confirmLogout), for: .touchUpInside)
        content.addArrangedSubview(logout)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            let profile = try account.profile()
            avatar.text = profile.initials; nameLabel.text = profile.name
            usernameLabel.text = profile.username; roleLabel.text = profile.role.rawValue
            errorLabel.isHidden = true
        } catch {
            avatar.text = nil; nameLabel.text = nil; usernameLabel.text = nil; roleLabel.text = nil
            errorLabel.text = error.localizedDescription; errorLabel.isHidden = false
        }
    }
    @objc private func confirmLogout() {
        let alert = UIAlertController(title: "Cerrar sesión", message: "¿Deseas cerrar tu sesión? Tus registros permanecerán guardados.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        let confirm = UIAlertAction(title: "Cerrar sesión", style: .destructive) { [weak self] _ in
            guard let scene = self?.view.window?.windowScene?.delegate as? SceneDelegate else { return }
            scene.logout()
        }
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}
