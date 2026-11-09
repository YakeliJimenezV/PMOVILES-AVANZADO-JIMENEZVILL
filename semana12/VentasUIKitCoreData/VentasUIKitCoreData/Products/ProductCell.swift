import UIKit

final class ProductCell: UITableViewCell {
    private let card = UIView()
    private let initials = UILabel()
    private let nameLabel = UILabel()
    private let categoryLabel = UILabel()
    private let priceLabel = UILabel()
    private let stockLabel = UILabel()
    private var stockWidth: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        card.backgroundColor = .white
        card.layer.cornerRadius = 13
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)
        initials.font = .systemFont(ofSize: 14, weight: .bold)
        initials.textColor = .white
        initials.textAlignment = .center
        initials.layer.cornerRadius = 11
        initials.clipsToBounds = true
        initials.widthAnchor.constraint(equalToConstant: 38).isActive = true
        initials.heightAnchor.constraint(equalToConstant: 38).isActive = true
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.lineBreakMode = .byTruncatingTail
        categoryLabel.font = .systemFont(ofSize: 12)
        categoryLabel.textColor = .secondaryLabel
        let text = UIStackView(arrangedSubviews: [nameLabel, categoryLabel])
        text.axis = .vertical
        text.spacing = 3
        text.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        priceLabel.font = .systemFont(ofSize: 14, weight: .bold)
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.7
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 110).isActive = true
        stockLabel.adjustsFontSizeToFitWidth = true
        stockLabel.minimumScaleFactor = 0.6
        stockWidth = stockLabel.widthAnchor.constraint(equalToConstant: 44)
        stockWidth.isActive = true
        stockLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        stockLabel.textColor = .white
        stockLabel.textAlignment = .center
        stockLabel.layer.cornerRadius = 9
        stockLabel.clipsToBounds = true
        stockLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stockLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        let row = UIStackView(arrangedSubviews: [initials, text, priceLabel, stockLabel])
        row.axis = .horizontal
        row.alignment = .center
        row.spacing = 9
        row.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(row)
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            row.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            row.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            row.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            row.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12)
        ])
        isAccessibilityElement = true
    }

    required init?(coder: NSCoder) { fatalError("ProductCell is created in code") }

    func configure(_ product: ProductItem, editable: Bool) {
        nameLabel.text = product.name
        categoryLabel.text = product.category
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "es_PE")
        formatter.numberStyle = .currency
        formatter.currencyCode = "PEN"
        formatter.currencySymbol = "S/ "
        priceLabel.text = formatter.string(from: NSNumber(value: product.price))
        stockLabel.text = "\(product.stock) u."
        let stockSize = (stockLabel.text! as NSString).size(withAttributes: [.font: stockLabel.font!]).width
        stockWidth.constant = min(100, max(44, ceil(stockSize) + 14))
        let state: String
        switch product.stockLevel {
        case .available: stockLabel.backgroundColor = .systemGreen; state = "Disponible"
        case .low: stockLabel.backgroundColor = .systemOrange; state = "Stock bajo"
        case .outOfStock: stockLabel.backgroundColor = .systemRed; state = "Agotado"
        }
        initials.text = String(product.name.split(separator: " ").prefix(2).compactMap(\.first)).uppercased()
        let colors: [UIColor] = [.systemIndigo, .systemPurple, .systemTeal, .systemPink]
        let index = product.category.unicodeScalars.reduce(0) { ($0 + Int($1.value)) % colors.count }
        initials.backgroundColor = colors[index]
        accessibilityLabel = "\(product.name), \(product.category), \(priceLabel.text ?? ""), \(product.stock) unidades, \(state)"
        accessibilityHint = editable ? "Toca para editar. Desliza para ver acciones." : "Solo consulta"
        accessibilityIdentifier = "product.row.\(product.id.uriRepresentation().lastPathComponent)"
    }
}
