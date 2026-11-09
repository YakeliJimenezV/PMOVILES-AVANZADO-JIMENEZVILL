import UIKit

@MainActor
private enum CommerceEnvironment {
    static let service = CommerceService(container: (UIApplication.shared.delegate as! AppDelegate).persistentContainer) {
        SessionManager.shared.currentUser
    }
}

class CommerceViewController: UIViewController {
    var service: CommerceService { CommerceEnvironment.service }
    let content = UIStackView()

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
        content.axis = .vertical
        content.spacing = 10
        content.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            content.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6),
            content.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func searchField(_ placeholder: String, id: String, action: Selector) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.accessibilityLabel = placeholder
        field.accessibilityIdentifier = id
        field.font = .systemFont(ofSize: 14)
        field.backgroundColor = UIColor(white: 0.89, alpha: 1)
        field.layer.cornerRadius = 10
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        field.autocorrectionType = .no
        field.heightAnchor.constraint(equalToConstant: 36).isActive = true
        let box = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 36))
        let icon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        icon.tintColor = .secondaryLabel
        icon.frame = CGRect(x: 10, y: 10, width: 16, height: 16)
        box.addSubview(icon)
        field.leftView = box
        field.leftViewMode = .always
        field.addTarget(self, action: action, for: .editingChanged)
        field.addAction(UIAction { [weak field] _ in field?.resignFirstResponder() }, for: .editingDidEndOnExit)
        return field
    }

    func configureTable(_ table: UITableView) {
        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 75
        table.keyboardDismissMode = .onDrag
        table.register(CommerceRowCell.self, forCellReuseIdentifier: "CommerceRow")
    }

    func message(_ message: String, title: String = "Aviso", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }

    func addButton(action: Selector, id: String) {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: action)
        item.tintColor = AuthFormViewController.blue
        item.accessibilityIdentifier = id
        if #available(iOS 26.0, *) { item.hidesSharedBackground = true }
        navigationItem.rightBarButtonItem = item
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
    static func card(_ views: [UIView], color: UIColor = .white, spacing: CGFloat = 12) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.spacing = spacing
        stack.backgroundColor = color
        stack.layer.cornerRadius = 14
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = .init(top: 12, leading: 14, bottom: 12, trailing: 14)
        return stack
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

final class CommerceRowCell: UITableViewCell {
    private let icon = UILabel()
    private let name = UILabel()
    private let detail = UILabel()
    private let amount = UILabel()
    private let badge = UILabel()
    private var badgeWidth: NSLayoutConstraint!
    private let amountCaption = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 13
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)
        icon.textAlignment = .center
        icon.textColor = .white
        icon.font = .systemFont(ofSize: 14, weight: .bold)
        icon.clipsToBounds = true
        icon.layer.cornerRadius = 10
        icon.widthAnchor.constraint(equalToConstant: 36).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 36).isActive = true
        name.font = .systemFont(ofSize: 14, weight: .semibold)
        name.lineBreakMode = .byTruncatingTail
        detail.font = .systemFont(ofSize: 11)
        detail.textColor = .secondaryLabel
        detail.numberOfLines = 2
        let info = UIStackView(arrangedSubviews: [name, detail])
        info.axis = .vertical
        info.spacing = 3
        info.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        amount.font = .systemFont(ofSize: 13, weight: .bold)
        amount.textAlignment = .right
        amount.adjustsFontSizeToFitWidth = true
        amount.minimumScaleFactor = 0.7
        amount.widthAnchor.constraint(lessThanOrEqualToConstant: 115).isActive = true
        amount.setContentCompressionResistancePriority(.required, for: .horizontal)
        badge.font = .systemFont(ofSize: 10, weight: .semibold)
        badge.textAlignment = .center
        badge.textColor = .white
        badge.layer.cornerRadius = 8
        badge.clipsToBounds = true
        badge.setContentCompressionResistancePriority(.required, for: .horizontal)
        badgeWidth = badge.widthAnchor.constraint(equalToConstant: 45)
        badgeWidth.priority = UILayoutPriority(999)
        badgeWidth.isActive = true
        amountCaption.text = "comprado"
        amountCaption.font = .systemFont(ofSize: 10)
        amountCaption.textAlignment = .right
        amountCaption.textColor = .secondaryLabel
        let amountColumn = UIStackView(arrangedSubviews: [amount, amountCaption])
        amountColumn.axis = .vertical
        amountColumn.spacing = 2
        amountColumn.setContentCompressionResistancePriority(.required, for: .horizontal)
        let row = UIStackView(arrangedSubviews: [icon, info, amountColumn, badge])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 8
        row.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(row)
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor), card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2), card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            row.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12), row.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12),
            row.topAnchor.constraint(equalTo: card.topAnchor, constant: 12), row.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12)
        ])
        isAccessibilityElement = true
    }
    required init?(coder: NSCoder) { fatalError("Use the registered cell") }

    func configure(client: ClientItem) {
        amountCaption.isHidden = false
        name.text = client.name
        name.textColor = .label
        detail.attributedText = nil
        detail.text = client.document
        amount.text = Money.text(client.purchased)
        badge.text = client.tier.rawValue
        badgeWidth.constant = ceil((client.tier.rawValue as NSString).size(withAttributes: [.font: badge.font!]).width) + 14
        badge.isHidden = false
        badge.backgroundColor = CommerceUI.tierColor(client.tier)
        icon.backgroundColor = CommerceUI.tierColor(client.tier)
        icon.text = String(client.name.split(separator: " ").prefix(2).compactMap(\.first)).uppercased()
        accessibilityLabel = "\(client.name), \(client.document), comprado \(Money.text(client.purchased)), \(client.tier.rawValue)"
        accessibilityHint = "Toca para editar"
    }
    func configure(sale: SaleItem) {
        amountCaption.isHidden = true
        name.text = sale.client
        name.textColor = sale.cancelled ? .secondaryLabel : .label
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        detail.text = "\(formatter.string(from: sale.date)) · \(sale.product) × \(sale.quantity)" + (sale.cancelled ? "\nAnulada" : "")
        if sale.cancelled, let text = detail.text {
            let attributed = NSMutableAttributedString(string: text)
            attributed.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (text as NSString).range(of: "Anulada"))
            detail.attributedText = attributed
        }
        amount.text = Money.text(sale.total)
        badge.isHidden = true
        icon.text = sale.cancelled ? "×" : "✓"
        icon.backgroundColor = sale.cancelled ? .systemRed : .systemGreen
        accessibilityLabel = "\(sale.client), \(detail.text ?? ""), \(Money.text(sale.total)), \(sale.cancelled ? "Anulada" : "Vigente")"
        accessibilityHint = nil
    }
}
