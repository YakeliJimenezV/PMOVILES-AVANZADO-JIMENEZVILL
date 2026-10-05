import UIKit

class ResultadoViewController: UIViewController {
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var igvLabel: UILabel!
    @IBOutlet weak var baseLabel: UILabel!
    @IBOutlet weak var interesesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var cuotaLabel: UILabel!

    var venta = VentaModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        subtotalLabel.text = String(format: "S/. %.2f", venta.subtotal)
        igvLabel.text = String(format: "S/. %.2f", venta.igv)
        baseLabel.text = String(format: "S/. %.2f", venta.base)
        interesesLabel.text = String(format: "S/. %.2f", venta.intereses)
        totalLabel.text = String(format: "S/. %.2f", venta.total)
        cuotaLabel.text = String(format: "S/. %.2f", venta.cuota)
    }
}
