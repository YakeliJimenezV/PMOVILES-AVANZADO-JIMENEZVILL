//
//  ViewController.swift
//  Semana06_03
//
//  Created by Tecsup on 5/10/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var electrodomesticoTextField: UITextField!
    @IBOutlet weak var precioUnitarioTextField: UITextField!
    @IBOutlet weak var cantidadTextField: UITextField!
    @IBOutlet weak var mesesTextField: UITextField!
    @IBOutlet weak var tasaInteresMensualTextField: UITextField!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResultado" {
            let precioUnitario = Double(precioUnitarioTextField.text ?? "") ?? 0
            let cantidad = Double(cantidadTextField.text ?? "") ?? 0
            let meses = Double(mesesTextField.text ?? "") ?? 1
            let tasaInteresMensual = Double(tasaInteresMensualTextField.text ?? "") ?? 0

            let subtotal = precioUnitario * cantidad
            let igv = subtotal * 0.18
            let base = subtotal + igv
            let intereses = base * (tasaInteresMensual / 100) * meses
            let total = base + intereses
            let cuota = total / meses

            let venta = VentaModel()
            venta.subtotal = subtotal
            venta.igv = igv
            venta.base = base
            venta.intereses = intereses
            venta.total = total
            venta.cuota = cuota

            let resultado = segue.destination as! ResultadoViewController
            resultado.venta = venta
        }
    }
}
