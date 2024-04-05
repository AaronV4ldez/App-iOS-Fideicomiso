//
//  showVehiclesViewController.swift
//  LineaExpres
//

import UIKit

class showVehiclesViewController: UIViewController {

    @IBOutlet weak var ModeloLbl: UILabel!
    @IBOutlet weak var YearLbl: UILabel!
    @IBOutlet weak var PlacasLbl: UILabel!
    @IBOutlet weak var SaldoLbl: UILabel!
    
    @IBOutlet weak var TelepeajeView: UIStackView!
    @IBOutlet weak var LineaExpresView: UIStackView!
    @IBOutlet weak var adpView: UIStackView!
    
    @IBOutlet weak var ConstantMain: NSLayoutConstraint!
    @IBOutlet weak var ViewMain: UIStackView!
    
    @IBOutlet weak var TelepeajeContraint: NSLayoutConstraint!
    @IBOutlet weak var LineaEContraint: NSLayoutConstraint!
    @IBOutlet weak var adpContraint: NSLayoutConstraint!
    //Si, ya se que le puse Constraint a los 3, pero como le puse a 2 sin darme cuenta, el 3ro debe seguir igual para verse bonito...
    
    @IBOutlet weak var ScrollContainer: UIScrollView!
    
    var hasLineaVeh: Int = 0
    
    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    var TagSelected:String = ""
    var tamañoTele = 0
    var tamañoLinea = 0
    var tamañoadp = 0
    let vistaVehiculo = vistaVehRecargar()
    var tipoLinea: Int = 0
    
    @IBOutlet weak var loaderContainer: UIView!
       @IBOutlet weak var loaderGif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaderGif.image = UIImage.gif(asset: "linea_expres_loader")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.loaderContainer.isHidden = true
                }
        
        
        if (!verifyLogging()) {
            print("Este es el ShowVehiclesViewController")
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
            }
        }else {
            
            print("Estamos hablando del mismo?")
            
            ConstantMain.constant = 0
            LineaEContraint.constant = 0
            TelepeajeContraint.constant = 0
            adpContraint.constant = 0
           
            desing()
            
            TelepeajeView.isHidden = true
            LineaExpresView.isHidden = true
            adpView.isHidden = true
            let heig = 450
            
            let data = requestVehicles()
            if (data.count != 0) {
                for i in 0..<(data.count) {
                    let Vehiculos = data[i].components(separatedBy: "∑")
                
                    
                    tipoLinea = Int(Vehiculos[0])!
                    let MarcaVeh:String = Vehiculos[1]
                    let Linea:String = Vehiculos[2]
                    let TagVeh:String = Vehiculos[3]
                    let imgurl:String = Vehiculos[4]
                    let ctl_contract_type:String = Vehiculos[5]
                    let clt_expiration_date:String = Vehiculos[6]
                    let SaldoVeh:String = Vehiculos[7]
                    let PlacasVeh:String = Vehiculos[8]
                    let ctl_stall_id:String = Vehiculos[9]
                    let ctl_user_id:String = Vehiculos[10]
                    let ctl_id:String = Vehiculos[11]
                    let anio:String = Vehiculos[12]
                    let id:String = Vehiculos[13]
                    
                    var a:UIStackView = UIStackView()
                    a.layer.masksToBounds = true
                    a.heightAnchor.constraint(equalToConstant: CGFloat(heig)).isActive = true
                   
                    print("realmente Linea es 1? : \(tipoLinea)")
                    if tipoLinea == 1 {
                        print("realmente Linea es 1 dentro de tipoLinea?? : \(tipoLinea)")
                        hasLineaVeh = hasLineaVeh + 1
                        tamañoLinea = tamañoLinea+heig
                        LineaExpresView.isHidden = false
                        let datos = [String(heig) , imgurl, MarcaVeh, Linea, PlacasVeh, TagVeh, ctl_contract_type, SaldoVeh, clt_expiration_date, ctl_stall_id, "1", ctl_user_id, ctl_id, anio, id, LoginToken, String(tipoLinea)]
                        
                        a = vistaVehiculo.generarVistaVehiculos(conDatos: datos)
                       
                        LineaExpresView.addArrangedSubview(a)
                 
                        LineaEContraint.constant = CGFloat(tamañoLinea + 80)
                    }
                    
                  
                    
                    if tipoLinea == 0 {
                        
                        
                        tamañoTele = tamañoTele+heig
                        TelepeajeView.isHidden = false
                        let datos = [String(heig) , imgurl, MarcaVeh, Linea, PlacasVeh, TagVeh, ctl_contract_type, SaldoVeh, clt_expiration_date, ctl_stall_id, "0", ctl_user_id, ctl_id, anio, id, LoginToken, String(tipoLinea)]
                        
                        a = vistaVehiculo.generarVistaVehiculos(conDatos: datos)
                        
                        TelepeajeView.addArrangedSubview(a)
                        TelepeajeContraint.constant = CGFloat(tamañoTele + 80)
                        
                    
                   
                        
                    }
                    
                    if tipoLinea == 2 {
                        
                        
                        tamañoadp = tamañoadp+heig
                        adpView.isHidden = false
                        let datos = [String(heig) , imgurl, MarcaVeh, Linea, PlacasVeh, TagVeh, ctl_contract_type, SaldoVeh, clt_expiration_date, ctl_stall_id, "2", ctl_user_id, ctl_id, anio, id, LoginToken, String(tipoLinea)]
                        
                        a = vistaVehiculo.generarVistaVehiculos(conDatos: datos)
                        
                        adpView.addArrangedSubview(a)
                        adpContraint.constant = CGFloat(tamañoadp + 80)
                        
                        
                        
                  
                    }
                  
                }
                print("HasLineaVeh: \(hasLineaVeh)")
                //if hasLineaVeh == 0 {
                //    DispatchQueue.main.async {
                //        self.showAlert(title: "Linea Exprés", message: "No tienes vehículos de Linea Expres, agrega algunos.")
                //        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ProfileViewController")
                //    }
                //}
            } else {
                DispatchQueue.main.async {
                         self.showAlert(title: "Puentes Fronterizos", message: "No tienes vehículos, agrega algunos.")
                         NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ProfileViewController")
                     }
            }
            ConstantMain.constant = CGFloat(tamañoTele + tamañoLinea + tamañoadp + 150)
        }
    
        
    }
    
    func showAlert(title: String, message: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        window.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    
    
    @IBAction func recharge(_ sender: Any) {
       
        
    }
    
    func desing(){
        //Ajustar padding a StackView
        TelepeajeView.layoutMargins = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
        TelepeajeView.isLayoutMarginsRelativeArrangement = true
        LineaExpresView.layoutMargins = UIEdgeInsets(top: 15, left: 5, bottom: 15, right: 5)
        LineaExpresView.isLayoutMarginsRelativeArrangement = true
        
        
        
        ViewMain.layer.cornerRadius = 20
        ScrollContainer.layer.cornerRadius = 20
        ViewMain.layer.masksToBounds = true
        ScrollContainer.layer.masksToBounds = true
    }
    
    @objc func didBtnRecharge(_ sender: UIButton) {
        let tag:String? = sender.accessibilityLabel
        
        //Las notificaciones se mandan desde "ViewController" en el generador de vistas
    }
    
    func requestVehicles() -> Array<String> {
        // create post request
        let session = URLSession.shared
         var dataReceived: Array<String> = []
         let sem = DispatchSemaphore.init(value: 0)

         //var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/vehicles")!)
         var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx/api/v1/vehicles")!)
         request.httpMethod = "GET"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                
                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("Json Raw = \(jsonArray) además \(jsonArray.count)" )
                    for i in 0..<(jsonArray.count) {
                        let tipoVeh: Int? = jsonArray[i]["tipo"] as? Int
                        let Marca: String? = jsonArray[i]["marca"] as? String
                        let Linea: String? = jsonArray[i]["linea"] as? String
                        let tag: String? = jsonArray[i]["tag"] as? String
                        let imgurl: String? = jsonArray[i]["imgurl"] as? String ?? "noImg"
                        let ctl_contract_type: String? = jsonArray[i]["ctl_contract_type"] as? String ?? "undefined"
                        let clt_expiration_date: String? = jsonArray[i]["clt_expiration_date"] as? String ?? "undefined"
                        let saldo: String? = jsonArray[i]["saldo"] as? String ?? "undefined"
                        let placa: String? = jsonArray[i]["placa"] as? String ?? "undefined"
                        let ctl_stall_id: String? = jsonArray[i]["ctl_stall_id"] as? String ?? "undefined"
                        let ctl_user_id: String? = jsonArray[i]["ctl_user_id"] as? String ?? "undefined"
                        let ctl_id: String? = jsonArray[i]["ctl_id"] as? String ?? "undefined"
                        let anio: String? = jsonArray[i]["modelo"] as? String ?? "undefined"
                        let id: Int? = jsonArray[i]["id"] as? Int
                        
                        let Vehicle:String = String(tipoVeh!) + "∑" + Marca! + "∑" + Linea! + "∑" + tag! + "∑" + imgurl! + "∑" + ctl_contract_type! + "∑" + clt_expiration_date! + "∑" + saldo! + "∑" + placa! + "∑" + ctl_stall_id! + "∑" + ctl_user_id! + "∑" + ctl_id! + "∑" + anio! + "∑" + String(id!)
                        print("el vehiculo es: \(Vehicle)")
                        dataReceived.append(Vehicle)
                        
                        
                    }
                    
                } else {
                    print("Error: Could not convert JSON string to")
                }
                
                
            }
        }

         task.resume()

         // This line will wait until the semaphore has been signaled
         // which will be once the data task has completed
         sem.wait()

         return dataReceived
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
                //FirebaseToken = Usuario[2]
                LoginToken = Usuario[3]
                print("LoginToken esta: \(LoginToken)")
                if (LoginToken.isEmpty) {
                    NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
                    pass = false
                }else {
                    pass = true
                }
                
            }
        }else {
            print("Está entrando a aqui?zasd")
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
            pass = false
        }
        return pass

    }

}
