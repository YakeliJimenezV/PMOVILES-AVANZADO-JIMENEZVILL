import UIKit

final class DetalleCulturaViewController: UIViewController {
    @IBOutlet private weak var culturaImageView: UIImageView!
    @IBOutlet private weak var nombreLabel: UILabel!
    @IBOutlet private weak var regionLabel: UILabel!
    @IBOutlet private weak var descripcionLabel: UILabel!
    @IBOutlet private weak var imagenAlturaConstraint: NSLayoutConstraint!
    @IBOutlet private weak var historiaLabel: UILabel!
    @IBOutlet private weak var temasStackView: UIStackView!

    var cultura: Cultura?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let cultura else {
            preconditionFailure("El detalle requiere una cultura seleccionada")
        }
        title = "Nuestro patrimonio"
        nombreLabel.text = cultura.nombre
        regionLabel.text = cultura.region
        descripcionLabel.text = cultura.descripcion
        culturaImageView.image = UIImage(named: cultura.nombreImagen)
        culturaImageView.accessibilityLabel = cultura.patrimonio
        culturaImageView.isAccessibilityElement = true
        culturaImageView.layer.cornerRadius = 20
        culturaImageView.clipsToBounds = true
        for label in [nombreLabel, regionLabel, descripcionLabel, historiaLabel] {
            if let label {
                label.font = UIFontMetrics.default.scaledFont(for: label.font)
                label.adjustsFontForContentSizeCategory = true
            }
        }
        configurarTemas(cultura.temas)
    }

    private func configurarTemas(_ temas: [String]) {
        for tema in temas {
            // Tarjetas con respuesta visual al toque
            let tarjeta = TarjetaTemaButton(type: .custom)
            tarjeta.backgroundColor = .white
            tarjeta.layer.cornerRadius = 16
            tarjeta.layer.borderWidth = 0.5
            tarjeta.layer.borderColor = UIColor(named: "Dorado")?.withAlphaComponent(0.45).cgColor
            tarjeta.accessibilityLabel = tema
            tarjeta.accessibilityIdentifier = "tema-\(temasStackView.arrangedSubviews.count)"

            let titulo = UILabel()
            titulo.text = tema
            titulo.textColor = UIColor(named: "Granate")
            titulo.font = UIFontMetrics(forTextStyle: .headline).scaledFont(
                for: .systemFont(ofSize: 17, weight: .semibold))
            titulo.adjustsFontForContentSizeCategory = true
            titulo.numberOfLines = 0

            let flecha = UIImageView(image: UIImage(systemName: "chevron.right"))
            flecha.tintColor = UIColor(named: "Granate")
            flecha.contentMode = .scaleAspectFit
            let contenido = UIStackView(arrangedSubviews: [titulo, flecha])
            contenido.axis = .horizontal
            contenido.alignment = .center
            contenido.spacing = 16
            contenido.isUserInteractionEnabled = false
            contenido.isAccessibilityElement = false
            titulo.isAccessibilityElement = false
            flecha.isAccessibilityElement = false
            contenido.translatesAutoresizingMaskIntoConstraints = false
            tarjeta.addSubview(contenido)
            NSLayoutConstraint.activate([
                tarjeta.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
                contenido.leadingAnchor.constraint(equalTo: tarjeta.leadingAnchor, constant: 20),
                contenido.trailingAnchor.constraint(equalTo: tarjeta.trailingAnchor, constant: -20),
                contenido.topAnchor.constraint(equalTo: tarjeta.topAnchor, constant: 20),
                contenido.bottomAnchor.constraint(equalTo: tarjeta.bottomAnchor, constant: -20),
                flecha.widthAnchor.constraint(equalToConstant: 12),
                flecha.heightAnchor.constraint(equalToConstant: 18)
            ])
            temasStackView.addArrangedSubview(tarjeta)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let imagen = culturaImageView.image,
              imagen.size.width > 0, culturaImageView.bounds.width > 0 else { return }
        // Ajusta la altura a cada fotografía para mostrarla completa sin franjas vacías.
        let altura = culturaImageView.bounds.width * imagen.size.height / imagen.size.width
        if abs(imagenAlturaConstraint.constant - altura) > 0.5 {
            imagenAlturaConstraint.constant = altura
        }
    }
}

private final class TarjetaTemaButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted
                ? UIColor(named: "Dorado")?.withAlphaComponent(0.18)
                : .white
        }
    }
}
