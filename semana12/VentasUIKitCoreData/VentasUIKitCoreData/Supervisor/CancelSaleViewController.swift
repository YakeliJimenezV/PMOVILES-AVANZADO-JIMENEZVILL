import UIKit

final class CancelSaleViewController: UIViewController, UITextFieldDelegate {
    private let sale: TeamSaleItem
    private let service: SupervisorService
    private let onCancelled: () -> Void
    private let reason = UITextField()
    private let errorLabel = CommerceUI.label(size: 12, color: .systemRed)
    private let confirm = UIButton(type: .system)
    private var isSubmitting = false
    init(sale: TeamSaleItem, service: SupervisorService, onCancelled: @escaping () -> Void) {
        self.sale = sale; self.service = service; self.onCancelled = onCancelled
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("Use init(sale:service:onCancelled:)") }
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        let title = CommerceUI.label("Anular venta", size: 19, bold: true); title.textAlignment = .center
        let summary = CommerceUI.label("\(sale.client) · \(sale.product) × \(sale.quantity) · \(Money.text(sale.total))\nEl stock se devolverá: +\(sale.quantity) u.", size: 13, color: .secondaryLabel)
        summary.textAlignment = .center
        reason.placeholder = "Escribe el motivo"
        reason.font = .preferredFont(forTextStyle: .body)
        reason.accessibilityIdentifier = "cancel.reason"
        reason.accessibilityLabel = "Motivo obligatorio"
        reason.returnKeyType = .done
        reason.delegate = self
        let field = CommerceUI.card([CommerceUI.label("MOTIVO (OBLIGATORIO)", size: 10, bold: true, color: .secondaryLabel), reason], spacing: 5)
        field.layer.borderWidth = 1; field.layer.borderColor = UIColor.systemGray4.cgColor
        errorLabel.isHidden = true; errorLabel.accessibilityIdentifier = "cancel.error"
        let cancel = UIButton(type: .system); cancel.setTitle("Cancelar", for: .normal); cancel.setTitleColor(.secondaryLabel, for: .normal)
        cancel.addTarget(self, action: #selector(close), for: .touchUpInside)
        confirm.setTitle("Anular", for: .normal); confirm.setTitleColor(.systemRed, for: .normal)
        confirm.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        confirm.accessibilityIdentifier = "cancel.confirm"
        confirm.addTarget(self, action: #selector(submit), for: .touchUpInside)
        let actions = UIStackView(arrangedSubviews: [cancel, confirm]); actions.distribution = .fillEqually
        actions.heightAnchor.constraint(equalToConstant: 44).isActive = true
        let body = CommerceUI.card([title, summary, field, errorLabel, actions], spacing: 14)
        let panel = UIScrollView(); panel.backgroundColor = .white; panel.layer.cornerRadius = 20
        panel.translatesAutoresizingMaskIntoConstraints = false; body.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(panel); panel.addSubview(body)
        let width = panel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64); width.priority = .defaultHigh
        let height = panel.heightAnchor.constraint(equalTo: body.heightAnchor); height.priority = .defaultHigh
        let center = panel.centerYAnchor.constraint(equalTo: view.centerYAnchor); center.priority = .defaultLow
        NSLayoutConstraint.activate([
            panel.centerXAnchor.constraint(equalTo: view.centerXAnchor), width, panel.widthAnchor.constraint(lessThanOrEqualToConstant: 420),
            panel.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            panel.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16), height, center,
            panel.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            panel.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor, constant: -16),
            body.leadingAnchor.constraint(equalTo: panel.contentLayoutGuide.leadingAnchor), body.trailingAnchor.constraint(equalTo: panel.contentLayoutGuide.trailingAnchor),
            body.topAnchor.constraint(equalTo: panel.contentLayoutGuide.topAnchor), body.bottomAnchor.constraint(equalTo: panel.contentLayoutGuide.bottomAnchor),
            body.widthAnchor.constraint(equalTo: panel.frameLayoutGuide.widthAnchor)
        ])
    }
    @objc private func close() { guard !isSubmitting else { return }; dismiss(animated: true) }
    @objc private func submit() {
        guard !isSubmitting else { return }
        isSubmitting = true; confirm.isEnabled = false
        do {
            try service.cancelSale(id: sale.id, reason: reason.text ?? "")
            view.endEditing(true)
            dismiss(animated: true, completion: onCancelled)
        } catch {
            isSubmitting = false; confirm.isEnabled = true
            errorLabel.text = error.localizedDescription; errorLabel.isHidden = false
            UIAccessibility.post(notification: .announcement, argument: errorLabel.text)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { textField.resignFirstResponder(); return true }
}
