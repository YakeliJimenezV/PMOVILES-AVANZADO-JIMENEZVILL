import UIKit

final class DetalleTemaViewController: UIViewController {
    @IBOutlet private weak var temaImageView: UIImageView!
    @IBOutlet private weak var nombreCulturaLabel: UILabel!
    @IBOutlet private weak var tituloTemaLabel: UILabel!
    @IBOutlet private weak var descripcionLabel: UILabel!
    @IBOutlet private weak var imagenAlturaConstraint: NSLayoutConstraint!

    var nombreCultura: String?
    var tema: TemaCultural?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let tema, let detalle = tema.detalle else { return }
        nombreCulturaLabel.text = nombreCultura
        tituloTemaLabel.text = tema.titulo
        temaImageView.image = UIImage(named: detalle.nombreImagen)
        temaImageView.layer.cornerRadius = 20
        temaImageView.clipsToBounds = true
        for label in [nombreCulturaLabel, tituloTemaLabel, descripcionLabel] {
            guard let label else { continue }
            label.font = UIFontMetrics.default.scaledFont(for: label.font)
            label.adjustsFontForContentSizeCategory = true
        }
        let parrafo = NSMutableParagraphStyle()
        parrafo.lineSpacing = 5
        parrafo.paragraphSpacing = 8
        descripcionLabel.attributedText = NSAttributedString(
            string: detalle.descripcion, attributes: [.paragraphStyle: parrafo])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let imagen = temaImageView.image,
              imagen.size.width > 0, temaImageView.bounds.width > 0 else { return }
        let altura = temaImageView.bounds.width * imagen.size.height / imagen.size.width
        if abs(imagenAlturaConstraint.constant - altura) > 0.5 {
            imagenAlturaConstraint.constant = altura
        }
    }
}
