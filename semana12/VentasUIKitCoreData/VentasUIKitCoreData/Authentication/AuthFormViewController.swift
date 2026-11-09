import UIKit

/// Shared visual components for the two authentication storyboard scenes.
class AuthFormViewController: UIViewController, UITextFieldDelegate {
    static let background = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)
    static let blue = UIColor(red: 0.02, green: 0.43, blue: 1, alpha: 1)
    let stack = UIStackView()
    let errorLabel = UILabel()
    private let scroll = UIScrollView()
    private var keyboardObservers: [NSObjectProtocol] = []

    var authentication: AuthenticationService {
        (UIApplication.shared.delegate as! AppDelegate).authentication
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = Self.background
        view.tintColor = Self.blue
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.keyboardDismissMode = .interactive
        view.addSubview(scroll)
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stack)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scroll.contentLayoutGuide.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: scroll.contentLayoutGuide.bottomAnchor, constant: -24),
            stack.centerXAnchor.constraint(equalTo: scroll.frameLayoutGuide.centerXAnchor),
            stack.widthAnchor.constraint(equalTo: scroll.frameLayoutGuide.widthAnchor, constant: -40)
        ])
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        errorLabel.font = .preferredFont(forTextStyle: .footnote)
        errorLabel.adjustsFontForContentSizeCategory = true
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true
        errorLabel.accessibilityIdentifier = "auth.error"
        keyboardObservers.append(NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main
        ) { [weak self] notification in
            guard let self, let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            let local = self.view.convert(frame, from: nil)
            let height = max(0, self.view.bounds.maxY - local.minY)
            self.scroll.contentInset.bottom = height
            self.scroll.verticalScrollIndicatorInsets.bottom = height
        })
        keyboardObservers.append(NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main
        ) { [weak self] _ in
            self?.scroll.contentInset.bottom = 0
            self?.scroll.verticalScrollIndicatorInsets.bottom = 0
        })
    }

    deinit { keyboardObservers.forEach(NotificationCenter.default.removeObserver) }

    @objc private func dismissKeyboard() { view.endEditing(true) }

    func field(_ title: String, placeholder: String, id: String,
               secure: Bool = false, contentType: UITextContentType? = nil) -> UITextField {
        let box = UIStackView()
        box.axis = .vertical
        box.spacing = 4
        box.isLayoutMarginsRelativeArrangement = true
        box.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 14, bottom: 10, trailing: 14)
        box.backgroundColor = .white
        box.layer.cornerRadius = 14
        box.layer.borderWidth = 1
        box.layer.borderColor = UIColor(white: 0.87, alpha: 1).cgColor
        let label = UILabel()
        label.text = title.uppercased()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .secondaryLabel
        label.adjustsFontForContentSizeCategory = true
        let field = UITextField()
        field.placeholder = placeholder
        field.font = .preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        field.textColor = .black
        field.isSecureTextEntry = secure
        field.textContentType = contentType
        field.autocapitalizationType = contentType == .name ? .words : .none
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.accessibilityLabel = title
        field.accessibilityIdentifier = id
        field.returnKeyType = .next
        field.delegate = self
        field.heightAnchor.constraint(greaterThanOrEqualToConstant: 24).isActive = true
        box.addArrangedSubview(label)
        box.addArrangedSubview(field)
        stack.addArrangedSubview(box)
        return field
    }

    func primaryButton(_ title: String, id: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.backgroundColor = Self.blue
        button.layer.cornerRadius = 14
        button.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        button.accessibilityIdentifier = id
        button.addTarget(self, action: action, for: .touchUpInside)
        stack.addArrangedSubview(button)
        return button
    }

    func showError(_ error: Error) {
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
        UIAccessibility.post(notification: .announcement, argument: errorLabel.text)
    }

    func completeAuthentication(_ user: SessionUser) {
        view.endEditing(true)
        SessionManager.shared.start(user)
        guard let scene = view.window?.windowScene?.delegate as? SceneDelegate else { return }
        scene.showAuthenticatedContent()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let fields = stack.arrangedSubviews.compactMap { ($0 as? UIStackView)?.arrangedSubviews.last as? UITextField }
        if let index = fields.firstIndex(of: textField), index + 1 < fields.count {
            fields[index + 1].becomeFirstResponder()
        } else { textField.resignFirstResponder() }
        return true
    }
}
