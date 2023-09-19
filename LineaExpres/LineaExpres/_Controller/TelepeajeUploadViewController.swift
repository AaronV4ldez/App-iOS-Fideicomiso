//
//  TelepeajeUploadViewController.swift
//  LineaExpres
//

import UIKit

class TelepeajeUploadViewController: UIViewController {
    
    
    
    @IBOutlet weak var Container: UIStackView!
    
    @IBOutlet weak var YearInput: UITextField!
    @IBOutlet weak var BrandInput: UITextField!
    @IBOutlet weak var ModelInput: UITextField!
    @IBOutlet weak var ColorInput: UITextField!
    @IBOutlet weak var PlatesInput: UITextField!
    @IBOutlet weak var NoSerieInput: UITextField!
    @IBOutlet weak var TagInput: UITextField!
    @IBOutlet weak var BridgeInput: UITextField!
    
    @IBOutlet weak var lblDatos: UILabel!
    @IBOutlet weak var lblMainTitle: UILabel!
    
    @IBOutlet weak var lblAnio: UILabel!
    @IBOutlet weak var lblMarca: UILabel!
    
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    
    
    
    @IBOutlet weak var lblPlacas: UILabel!
    @IBOutlet weak var lblSerieVN: UILabel!
    @IBOutlet weak var lblTag: UILabel!
    
    @IBOutlet weak var loaderGif: UIImageView!
    @IBOutlet weak var loaderContainer: UIView!
    var barcode:String = ""
    
    @IBOutlet weak var msgAdvert: UILabel!
    @IBOutlet weak var btnAddTag: UIButton!
    
    var Email:String = ""
    var Name:String = ""
    var LoginToken:String = ""
    
    var TPADP = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderGif.image = UIImage.gif(asset: "linea_expres_loader")
        desing()
        
        YearInput.tintColor = UIColor.black
        BrandInput.tintColor = UIColor.black
        ModelInput.tintColor = UIColor.black
        ColorInput.tintColor = UIColor.black
        PlatesInput.tintColor = UIColor.black
        NoSerieInput.tintColor = UIColor.black
        TagInput.tintColor = UIColor.black
       // BridgeInput.tintColor = UIColor.black
        
        YearInput.applyTextFieldStyle()
        BrandInput.applyTextFieldStyle()
        ModelInput.applyTextFieldStyle()
        ColorInput.applyTextFieldStyle()
        PlatesInput.applyTextFieldStyle()
        NoSerieInput.applyTextFieldStyle()
        TagInput.applyTextFieldStyle()
       // BridgeInput.applyTextFieldStyle()
        
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("TagTranslator"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TPADPNotification(_:)), name: Notification.Name("TPADPTranslator"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.loaderContainer.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String
       
        barcode = text
        print(text)
        
        self.TagInput.text = self.barcode
        
    }
    
    @objc func TPADPNotification(_ notification: Notification) {
        let text:String = notification.object as! String
        TPADP = Int(text)!
        print("Al menos entra auqi????????? \(TPADP)")
        if self.TPADP == 1 {
            
            self.lblMainTitle.text = "Acceso Digital Peatonal"
            self.lblDatos.text = "Datos del usuario"
            self.lblTag.text = "Acceso Digital"
            self.lblAnio.text = "Nombre(s)"
            self.lblMarca.text = "Apellido(s)"
            self.ModelInput.isHidden = true
            self.lblModel.isHidden = true
            self.ColorInput.isHidden = true
            self.lblColor.isHidden = true
            self.YearInput.keyboardType = .default
            
            self.lblPlacas.isHidden = true
            self.lblSerieVN.isHidden = true
            self.lblTag.text = "Acceso Peatonal"
            self.PlatesInput.isHidden = true
            self.NoSerieInput.isHidden = true
            
            self.btnAddTag.setTitle("Agregar TAG", for: .normal)
        }
        print("Se supone debe ser un 1 \(TPADP)")
    }
    
    @IBAction func agregarClicked(_ sender: Any) {
        uploadCar()
    }
    
    func uploadCar() {
        var json: [String: Any] = [:]
        if TPADP == 1 {
            //ADP
            json = ["marca": YearInput.text!, "linea": BrandInput.text!, "modelo": "N/A", "color": "N/A", "placa": "N/A", "tag": barcode, "puente": "N/A", "tt": "2"]
        }else {
            //Telepeaje
            json = ["marca": BrandInput.text!, "linea": ModelInput.text!, "modelo": YearInput.text!, "color": ColorInput.text!, "placa": PlatesInput.text!, "tag": barcode, "puente": "N/A", "tt": "0"]
        }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/vehicles")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")
        request.setValue("text", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                
                let message:String? = responseJSON["message"] as? String
                let puente:String? = responseJSON["puente"] as? String
                
                if puente != nil {
                    DispatchQueue.main.async() {
                        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "successfullyViewController")
                        NotificationCenter.default.post(name: Notification.Name("FinishMSG"), object: "Tag '\(self.barcode)' ha sido dado de alta a tu perfil, revisa tus vehículos")
                    }
                }
                
                if message != nil {
                    if message!.contains("No se recibieron") {
                        DispatchQueue.main.async() {
                            self.msgAdvert.text = message
                        }
                    }else {
                        DispatchQueue.main.async() {
                            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "successfullyViewController")
                            NotificationCenter.default.post(name: Notification.Name("FinishMSG"), object: message!)
                        }
                    }
                }
                
            }else {
                print("Can't convert string to json")
            }
        }
        task.resume()
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
                if (LoginToken.isEmpty) {
                    NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
                }
                pass = true
            }
        }else {
            print("Está entrando a aqui?zasd")
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
            pass = false
        }
        return pass

    }
    
    func desing() {
        Container.layer.cornerRadius = 20
        Container.layer.masksToBounds = true
        //Ajustar padding a StackView
        Container.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        Container.isLayoutMarginsRelativeArrangement = true
        
    }
    
}
