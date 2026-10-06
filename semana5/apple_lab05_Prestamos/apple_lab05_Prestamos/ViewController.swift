import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var capitalTextField: UITextField!
    @IBOutlet weak var tasaTextField: UITextField!
    @IBOutlet weak var aniosTextField: UITextField!
    @IBOutlet weak var cuotaLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    @IBAction func calcular(_ sender: UIButton) {
        view.endEditing(true)

        guard let capital = valorPositivo(capitalTextField.text),
              let tasaAnual = valorPositivo(tasaTextField.text),
              let anios = valorPositivo(aniosTextField.text) else {
            cuotaLabel.text = "Ingresa valores numéricos mayores que cero en los tres campos."
            totalLabel.text = ""
            return
        }

        let tasaMensual = (tasaAnual / 100) / 12
        let numeroDePagos = anios * 12
        let factor = pow(1 + tasaMensual, numeroDePagos)
        // M = P × [r(1+r)^n / ((1+r)^n - 1)]
        let cuotaMensual = capital * (tasaMensual * factor / (factor - 1))
        let montoTotal = cuotaMensual * numeroDePagos

        guard cuotaMensual.isFinite, montoTotal.isFinite,
              cuotaMensual > 0, montoTotal > 0 else {
            cuotaLabel.text = "Los valores ingresados no permiten calcular el préstamo."
            totalLabel.text = ""
            return
        }

        let formato = NumberFormatter()
        formato.locale = Locale(identifier: "en_US")
        formato.numberStyle = .decimal
        formato.minimumFractionDigits = 2
        formato.maximumFractionDigits = 2

        guard let cuota = formato.string(from: NSNumber(value: cuotaMensual)),
              let total = formato.string(from: NSNumber(value: montoTotal)) else {
            cuotaLabel.text = "No se pudieron mostrar los resultados."
            totalLabel.text = ""
            return
        }
        cuotaLabel.text = "Cuota mensual: S/ \(cuota)"
        totalLabel.text = "Monto total a pagar: S/ \(total)"
    }

    private func valorPositivo(_ texto: String?) -> Double? {
        let normalizado = (texto ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        guard let valor = Double(normalizado), valor.isFinite, valor > 0 else {
            return nil
        }
        return valor
    }
}
