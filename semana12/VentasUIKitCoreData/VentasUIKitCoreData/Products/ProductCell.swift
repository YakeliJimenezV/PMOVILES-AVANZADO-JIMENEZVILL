import UIKit

final class ProductCell: UITableViewCell {
    @IBOutlet private weak var initials: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var stockLabel: UILabel!
    @IBOutlet private weak var stockWidth: NSLayoutConstraint!

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
