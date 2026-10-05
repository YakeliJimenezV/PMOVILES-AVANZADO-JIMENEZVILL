//
//  ViewController.swift
//  Semana06_02
//
//  Created by Tecsup on 1/10/26.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtApellidos: UITextField!
    
    @IBOutlet weak var txtNombres: UITextField!
    
    @IBOutlet weak var txtDni: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnContinuar(_ sender: Any) {
        let cliente = ClienteModel()

        cliente.Apellido = txtApellidos.text!
        cliente.Nombre = txtNombres.text!
        cliente.Dni = txtDni.text!
        
        let controlador = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerConfirmacion") as! ViewControllerConfirmacion

        controlador.pCliente = cliente

        self.present(controlador, animated: true, completion: nil)
        
    }
    
    @IBAction func regresarPantalla1(_ segue: UIStoryboardSegue) {
    }

}

