import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!

    @IBAction func CalcularResultado(_ sender: UIButton) {
        view.endEditing(true)

        let weightText = (weightTextField.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        let heightText = (heightTextField.text ?? "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")

        guard let weight = Double(weightText),
              let height = Double(heightText),
              weight.isFinite, height.isFinite,
              weight > 0, height > 0 else {
            resultLabel.text = "Ingresa un peso y una altura válidos, mayores que cero."
            return
        }

        let imc = weight / (height * height)
        guard imc.isFinite, imc > 0 else {
            resultLabel.text = "Ingresa un peso y una altura válidos."
            return
        }

        let classification: String
        if imc < 18.5 {
            classification = "Bajo peso"
        } else if imc < 25 {
            classification = "Peso normal"
        } else if imc < 30 {
            classification = "Sobrepeso"
        } else {
            classification = "Obesidad"
        }

        resultLabel.text = String(format: "IMC: %.2f", imc)
            + " - " + classification
    }
}
