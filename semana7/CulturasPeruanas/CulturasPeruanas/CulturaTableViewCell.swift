import UIKit

final class CulturaTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CulturaCell"

    @IBOutlet private weak var tarjetaView: UIView!
    @IBOutlet private weak var culturaImageView: UIImageView!
    @IBOutlet private weak var nombreLabel: UILabel!
    @IBOutlet private weak var regionLabel: UILabel!
    @IBOutlet private weak var explorarLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        tarjetaView.layer.cornerRadius = 20
        tarjetaView.layer.borderWidth = 0.5
        tarjetaView.layer.borderColor = UIColor(named: "Dorado")?.withAlphaComponent(0.45).cgColor
        culturaImageView.layer.cornerRadius = 14
        culturaImageView.clipsToBounds = true
        for label in [nombreLabel, regionLabel, explorarLabel] {
            if let label {
                label.font = UIFontMetrics.default.scaledFont(for: label.font)
                label.adjustsFontForContentSizeCategory = true
            }
        }
        isAccessibilityElement = true
        accessibilityTraits = .button
    }

    func configurar(con cultura: Cultura) {
        nombreLabel.text = cultura.nombre
        regionLabel.text = cultura.region
        culturaImageView.image = UIImage(named: cultura.nombreImagen)
        accessibilityLabel = "\(cultura.nombre), \(cultura.region)"
        accessibilityHint = "Abre la historia y el patrimonio de esta cultura"
        accessibilityIdentifier = cultura.nombreImagen
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        tarjetaView.alpha = highlighted ? 0.75 : 1
    }
}
