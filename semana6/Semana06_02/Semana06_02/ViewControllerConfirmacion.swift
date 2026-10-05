//
//  ViewControllerConfirmacion.swift
//  Semana06_02
//
//  Created by Tecsup on 1/10/26.
//

import UIKit

class ViewControllerConfirmacion: UIViewController {
    var pCliente: ClienteModel = ClienteModel()

    
    @IBOutlet weak var lblApellidos: UILabel!
    
    
    @IBOutlet weak var lblNombres: UILabel!
    
    
    @IBOutlet weak var lblDni: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblApellidos.text = pCliente.Apellido
        lblNombres.text = pCliente.Nombre
        lblDni.text = pCliente.Dni
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
