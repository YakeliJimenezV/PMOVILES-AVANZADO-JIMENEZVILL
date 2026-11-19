import UIKit

final class CancelSaleViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet private weak var summary: UILabel!
    @IBOutlet private weak var reason: UITextField!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var confirm: UIButton!
    @IBOutlet private weak var panel: UIScrollView!

    private var sale: TeamSaleItem?
    private var service: SupervisorService?
    private var onCancelled: (() -> Void)?
    private var isSubmitting = false

    func configure(sale: TeamSaleItem, service: SupervisorService, onCancelled: @escaping () -> Void) {
        self.sale = sale
        self.service = service
        self.onCancelled = onCancelled
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        panel.bottomAnchor.constraint(lessThanOrEqualTo: view.keyboardLayoutGuide.topAnchor, constant: -12).isActive = true
        guard let sale else {
            confirm.isEnabled = false
            summary.text = SupervisorError.notFound.localizedDescription
            return
        }
        summary.text = "\(sale.client) · \(sale.product) × \(sale.quantity) · \(Money.text(sale.total))\nEl stock se devolverá: +\(sale.quantity) u."
    }
    @IBAction private func close(_ sender: UIButton) { guard !isSubmitting else { return }; dismiss(animated: true) }
    @IBAction private func submit(_ sender: UIButton) {
        guard !isSubmitting, let service, let sale else { return }
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
