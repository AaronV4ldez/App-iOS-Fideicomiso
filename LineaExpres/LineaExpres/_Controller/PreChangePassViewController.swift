//
//  PreChangePassViewController.swift
//  LineaExpres
//

import UIKit

class PreChangePassViewController: UIViewController {

    
    @IBOutlet weak var MessageLbl: UILabel!
    
    
    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    var PswdCheck:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        MessageLbl.text = "Hola, \(Name) \n Gracias por registrarte a Línea Exprés \n para continuar con cualquier trámite en Línea Exprés debes cambiar tu contraseña por una personalizada. \n presiona el botón \"Cambiar contraseña\" para continuar el proceso "
    }
    

    @IBAction func goToChangePassClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ChangePassViewController")
    }
    
    func verifyLogging() -> Bool {
        
        var pass:Bool = false
        let Lista:Array<String> = DB_Manager().getUsuario()
        print("Lista = \(Lista.count) ")
        if (Lista.count != 0) {
            for i in 0..<(Lista.count) {
                
                let Usuario = Lista[i].components(separatedBy: "∑")
                
                Email = Usuario[0]
                Name = Usuario[1]
                LoginToken = Usuario[3]
                if (!LoginToken.isEmpty) {
                    PswdCheck = Int(Usuario[4])!
                    pass = true
                }
            }
        }else {
            pass = false
        }
        return pass

    }
   

}
