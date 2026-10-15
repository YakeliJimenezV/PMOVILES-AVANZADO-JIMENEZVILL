import UIKit

final class DetalleCulturaViewController: UIViewController {
    @IBOutlet private weak var culturaImageView: UIImageView!
    @IBOutlet private weak var nombreLabel: UILabel!
    @IBOutlet private weak var regionLabel: UILabel!
    @IBOutlet private weak var descripcionLabel: UILabel!
    @IBOutlet private weak var imagenAlturaConstraint: NSLayoutConstraint!

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
        for label in [nombreLabel, regionLabel, descripcionLabel] {
            if let label {
                label.font = UIFontMetrics.default.scaledFont(for: label.font)
                label.adjustsFontForContentSizeCategory = true
            }
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
