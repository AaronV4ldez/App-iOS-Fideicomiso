//
//  HamburgerViewController.swift
//  LineaExpres
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet var BackgroundHamburger: UIView!
    @IBOutlet weak var HomeBtn: UIButton!
    
    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
      
        

    }
    
    @IBAction func HomeBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HomeViewController")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func CamerasBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"CamerasViewController")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func ChangeEmailBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"ChangeEmailViewController")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func ChangePasswordBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"ChangePassViewController")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func FactDataBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"DatosFacturacionViewController")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func ServiciosBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "Services")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func LineamientosBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "https://noticias.fpfch.gob.mx/wp-json/wp/v2/pages/1305?_embed")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func DerechosYOblig(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "https://noticias.fpfch.gob.mx/wp-json/wp/v2/pages/1445?_embed")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func QuieneSomosBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "https://noticias.fpfch.gob.mx/wp-json/wp/v2/pages/647?_embed")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func ObjetivoBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "https://noticias.fpfch.gob.mx/wp-json/wp/v2/pages/662?_embed")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func MisionBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "https://noticias.fpfch.gob.mx/wp-json/wp/v2/pages/724?_embed")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func VisionBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "https://noticias.fpfch.gob.mx/wp-json/wp/v2/pages/730?_embed")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func AvisoBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "https://noticias.fpfch.gob.mx/wp-json/wp/v2/pages/3?_embed")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    @IBAction func TramitesBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "VehiculosViewController")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    
    @IBAction func ContactanosBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ContactanosViewController")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    
    @IBAction func TarifasBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "https://noticias.fpfch.gob.mx/wp-json/wp/v2/pages/1119?_embed")
        NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
    }
    
    
    private func setupHamburgerUI(){
        self.BackgroundHamburger.layer.cornerRadius = 20
        self.BackgroundHamburger.clipsToBounds = true
    }
 
   
    @IBAction func CloseSession(_ sender: Any) {
        if (verifyLogging()) {
            DB_Manager().addUser(EmailVal: "", NameVal: "", LoginTokenVal: "", UserSetPwdVal: "", Sentri: "", SentriFecha: "")
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
            NotificationCenter.default.post(name: Notification.Name("LogoutFunc"), object: "")
            NotificationCenter.default.post(name: Notification.Name("closeMenu"), object: "0")
        }

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
                if Name == "" {
                    pass = false
                }else {
                    pass = true
                }
               
            }
        }else {
            pass = false
        }
        return pass

    }
}
