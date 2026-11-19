import UIKit

final class AccountViewController: CommerceViewController {
    private lazy var account = AccountService(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        SessionManager.shared.currentUser
    }
    @IBOutlet private weak var avatar: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var roleLabel: UILabel!
    @IBOutlet private weak var errorLabel: UILabel!

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
    @IBAction private func confirmLogout() {
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
