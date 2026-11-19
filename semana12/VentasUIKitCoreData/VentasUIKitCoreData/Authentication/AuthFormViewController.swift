import UIKit

class AuthFormViewController: UIViewController, UITextFieldDelegate {
    static let background = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
    static let blue = UIColor(red: 0.02, green: 0.43, blue: 1, alpha: 1)

    @IBOutlet private weak var scroll: UIScrollView!
    @IBOutlet private var fieldCards: [UIStackView]!
    @IBOutlet weak var errorLabel: UILabel!

    var fields: [UITextField] { [] }
    var authentication: AuthenticationService {
        (UIApplication.shared.delegate as! AppDelegate).authentication
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        for card in fieldCards {
            card.layer.borderWidth = 1
            card.layer.borderColor = UIColor(white: 0.87, alpha: 1).cgColor
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardChanged(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func keyboardChanged(_ notification: Notification) {
        guard let window = view.window,
              let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardFrame = scroll.convert(frame, from: window.screen.coordinateSpace)
        let overlap = scroll.bounds.intersection(keyboardFrame).height
        scroll.contentInset.bottom = overlap
        scroll.verticalScrollIndicatorInsets.bottom = overlap
        if overlap > 0, let active = fields.first(where: { $0.isFirstResponder }) {
            scroll.scrollRectToVisible(scroll.convert(active.bounds.insetBy(dx: 0, dy: -12), from: active), animated: false)
        }
    }

    @objc private func dismissKeyboard() { view.endEditing(true) }

    func showError(_ error: Error) {
        view.endEditing(true)
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
        UIAccessibility.post(notification: .announcement, argument: errorLabel.text)
    }

    func completeAuthentication(_ user: SessionUser) {
        view.endEditing(true)
        SessionManager.shared.start(user)
        let segue = user.role == .supervisor ? "enterSupervisorMenu" : "enterSellerMenu"
        performSegue(withIdentifier: segue, sender: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let index = fields.firstIndex(of: textField), index + 1 < fields.count {
            fields[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
