import UIKit

@MainActor
private enum CommerceEnvironment {
    static let service = CommerceService(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        SessionManager.shared.currentUser
    }
}

class CommerceViewController: UIViewController {
    var service: CommerceService { CommerceEnvironment.service }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        view.backgroundColor = AuthFormViewController.background
        view.tintColor = AuthFormViewController.blue
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AuthFormViewController.background
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }

    func configureTable(_ table: UITableView) {
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 75
        table.keyboardDismissMode = .onDrag
    }

    func message(_ message: String, title: String = "Aviso", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }
}

@MainActor
enum CommerceUI {
    static func label(_ text: String = "", size: CGFloat = 14, bold: Bool = false, color: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: size, weight: bold ? .semibold : .regular)
        label.textColor = color
        label.numberOfLines = 0
        return label
    }
    static func row(_ left: UIView, _ right: UIView) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [left, right])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }
    static func tierColor(_ tier: ClientTier) -> UIColor {
        switch tier {
        case .regular: return .systemGray
        case .frequent: return AuthFormViewController.blue
        case .vip: return .systemPurple
        }
    }
    static func empty(_ table: UITableView, text: String?) {
        guard let text else { table.backgroundView = nil; return }
        let label = self.label(text, color: .secondaryLabel)
        label.textAlignment = .center
        label.accessibilityIdentifier = "commerce.empty"
        table.backgroundView = label
    }
}

final class SaleHistoryCell: UITableViewCell {
    @IBOutlet private weak var icon: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var detail: UILabel!
    @IBOutlet private weak var cancelledLabel: UILabel!
    @IBOutlet private weak var amount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        isAccessibilityElement = true
    }

    func configure(sale: SaleItem) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        display(client: sale.client, total: sale.total, cancelled: sale.cancelled,
                description: "\(formatter.string(from: sale.date)) · \(sale.product) × \(sale.quantity)")
        icon.text = sale.cancelled ? "×" : "✓"
        icon.backgroundColor = sale.cancelled ? .systemRed : .systemGreen
        accessibilityHint = nil
    }

    func configure(teamSale sale: TeamSaleItem) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        display(client: sale.client, total: sale.total, cancelled: sale.cancelled,
                description: "\(sale.seller) · \(sale.product) × \(sale.quantity) · \(formatter.string(from: sale.date))")
        icon.text = String(sale.client.split(separator: " ").prefix(2).compactMap(\.first)).uppercased()
        icon.backgroundColor = sale.cancelled ? .systemRed : .systemPurple
        accessibilityHint = sale.cancelled ? "Toca para consultar el motivo" : "Toca o desliza para anular"
    }

    private func display(client: String, total: Decimal, cancelled: Bool, description: String) {
        nameLabel.text = client
        nameLabel.textColor = cancelled ? .secondaryLabel : .label
        detail.text = description
        cancelledLabel.isHidden = !cancelled
        let formattedTotal = Money.text(total)
        amount.text = formattedTotal
        accessibilityLabel = "\(client), \(description), \(formattedTotal), \(cancelled ? "Anulada" : "Vigente")"
    }
}
