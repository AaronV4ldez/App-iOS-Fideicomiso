//
//  TramitesViewController.swift
//  LineaExpres
//

import UIKit

class TramitesViewController: UIViewController {

    
    @IBOutlet weak var solicitudInscripcion: UIView!
    @IBOutlet weak var inscripcionPuente: UIView!
    @IBOutlet weak var solicitudCambioVeh: UIView!
    @IBOutlet weak var solicitudTransferenciaSaldo: UIView!
    @IBOutlet weak var solicitudBajaTagOVeh: UIView!

    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    var PswdCheck:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startRounding()
        
       
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        if PswdCheck == 0 {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "PreChangePassViewController")
        }
    }
    
    func startRounding() {
        self.solicitudInscripcion.layer.cornerRadius = 5
        self.inscripcionPuente.layer.cornerRadius = 5
        self.solicitudCambioVeh.layer.cornerRadius = 5
        self.solicitudTransferenciaSaldo.layer.cornerRadius = 5
        self.solicitudBajaTagOVeh.layer.cornerRadius = 5
    }
    
    
    
    @IBAction func SolicitudInscripcionVeh(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "SolInscripcionViewController")
    }
    
    @IBAction func InscripcionOtroVehClicked(_ sender: Any) {
    }
    
    @IBAction func SolicitudCambioVehClicked(_ sender: Any) {
    }
    
   
    @IBAction func SolicitudTransferenciaSaldoClicked(_ sender: Any) {
    }
    
    @IBAction func SolicitudBajaVehOTagClicked(_ sender: Any) {
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
