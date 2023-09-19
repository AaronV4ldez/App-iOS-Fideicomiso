//
//  PostRegisterViewController.swift
//  LineaExpres
//

import UIKit
import AVFoundation
import SwiftyJSON

class PostRegisterViewController: UIViewController {

    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var LineaExpresBtn: UIButton!
    @IBOutlet weak var goToSolTitle: UILabel!
    @IBOutlet weak var goToSolBtn: UIButton!
    
    
    var Email:String = ""
    var Name:String = ""
    var LoginToken:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.LineaExpresBtn.isHidden = true
        self.goToSolTitle.isHidden = true
        self.goToSolBtn.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        TitleLabel.text = "\(Name), gracias por registrarte con nosotros."
        desing()
        getVehicles()
    }
    
    @IBAction func LEClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LineaExpresAddVehViewController")
    }
    
    @IBAction func TPClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "TelepeajeAddVehViewController")
    }
    
    @IBAction func goToSoli(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "SolInscripcionViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoTramite"), object: "0,0,0,0,0,0,0")
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
    }
    
    func getVehicles() {
        // create post request
        let session = URLSession.shared
         
       

         var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/vehicles")!)
         request.httpMethod = "GET"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("Json Raw = \(jsonArray) además \(jsonArray.count)" )
                    
                    if jsonArray.count <= 0 {
                        DispatchQueue.main.async {
                            print("El usuario no tiene vehiculos")
                            self.LineaExpresBtn.isHidden = false
                            self.goToSolTitle.isHidden = false
                            self.goToSolBtn.isHidden = false
                        }
                    }else {
                        DispatchQueue.main.async {
                            print("El usuario tiene vehiculos")
                            
                            for i in 0..<(jsonArray.count) {
                                let tipoVeh: Int? = jsonArray[i]["tipo"] as? Int
                                if tipoVeh == 1 {
                                    self.LineaExpresBtn.isHidden = true
                                    self.goToSolTitle.isHidden = true
                                    self.goToSolBtn.isHidden = true
                                }else {
                                    self.LineaExpresBtn.isHidden = false
                                    self.goToSolTitle.isHidden = false
                                    self.goToSolBtn.isHidden = false
                                }
                                
                            }
                            
                            
                            
                            
                            
                        }
                    }
                    
                }else {
                    print("No se pudo obtener el Array ni el Object")
                }
                
                
            }
        }

         task.resume()
         

    }
    
    
}

class LineaExpresAddVehViewController: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var SentriInput: UITextField!
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var imgSel: UIImageView!
    
    @IBOutlet weak var msgAdvert: UILabel!
    var Email:String = ""
    var Name:String = ""
    var LoginToken:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        desing()
        msgAdvert.isHidden = true
        imgSel.isUserInteractionEnabled = false
        SentriInput.tintColor = UIColor.black
        SentriInput.applyTextFieldStyle()
        
        SentriInput.delegate = self
        
    }
    
    @IBAction func agregarClicked(_ sender: Any) {
        //uploadCar(sentri: SentriInput.text!)
        checkSentri(sentri: SentriInput.text!, user: Email)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let text = textField.text else { return true }
           let newLength = text.count + string.count - range.length
           
           // Impedir que se ingresen más caracteres una vez que se alcance el límite de 9
           return newLength <= 9
       }
    
    func checkSentri(sentri: String, user: String) {
        var message: String = ""
        
        
        // create post request
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/le/user/\(sentri)/\(user)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")
        request.setValue("text", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

            if let responseArray = responseJSON as? [Any] {
                // El JSON es un array
                print(responseArray)
                
                // Llamar a la función uploadVeh aquí
                self.uploadCar(sentri: sentri);
            }
            else if let responseObject = responseJSON as? [String: Any] {
                // El JSON es un objeto
                print(responseObject)
                let msgString = responseObject["message"] as? String ?? "noMessage"
                DispatchQueue.main.async {
                    self.msgAdvert.isHidden = false
                    self.msgAdvert.text = msgString
                }
               
                print(msgString)
               
            }
            else {
                // No se pudo convertir a objeto o array
                print("Can't convert string to JSON")
              
            }

        }
        task.resume()
    }
    
    func uploadCar(sentri: String) {
        var message: String = ""
        let json: [String: Any] = ["sentri": sentri]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/sentri")!
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
                
                message = responseJSON["message"] as? String ?? "noMessage"
                
                if !message.contains("noMessage") {
                    if message.contains("Cambio realizado exitosamente.") {
                        DispatchQueue.main.async() {
                            self.msgAdvert.isHidden = false
                            self.msgAdvert.text = message + "Espere un momento, por favor."
                            print(message)
                            DB_Manager().updateOnlySentri(Sentri: sentri)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                if ChecaInternet.Connection() {
                                    NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "showVehiclesViewController")
                                }	}
                            
                           
                        }
                    }else {
                        self.msgAdvert.isHidden = false
                        self.msgAdvert.text = message
                        print(message)
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
    }
    
}

class TelepeajeAddVehViewController: UIViewController {
    @IBOutlet weak var BarCodeInput: UITextField!
    @IBOutlet weak var Cautions: UITextView!
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var TelepeajeIMG: UIImageView!
    @IBOutlet weak var LabelTP: UILabel!
    var json: [String: Any] = [:]
    
    var barcode:String = ""
    var Email:String = ""
    var Name:String = ""
    var LoginToken:String = ""
    
    var TPADP = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        Cautions.isHidden = true
        BarCodeInput.tintColor = UIColor.black
        BarCodeInput.applyTextFieldStyle()
        
        desing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("BarCode"), object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.BarCodeInput.text = self.barcode
            if (!self.luhnCheck(self.barcode)) {
                self.Cautions.isHidden = false
                self.Cautions.text = "El TAG ingresado es incorrecto."
            }
        }
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String
        
        barcode = text
        print(text)
    }
    
    @IBAction func ScanClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ScanViewController")
        NotificationCenter.default.post(name: Notification.Name("TPADPTranslator"), object: String(TPADP))
       
    }
    
    @IBAction func validarTagClicked(_ sender: Any) {
        //if luhnCheck(BarCodeInput.text!) {
            if !BarCodeInput.text!.isEmpty {
                barcode = BarCodeInput.text!
                if let firstChar = barcode.first, !firstChar.isLetter {
                    barcode = String(barcode.dropLast())
                }

                if !barcode.isEmpty {
                    verifyTag(tag: barcode)
                }
            }else {
                Cautions.isHidden = false
                Cautions.text = "Debe escribir ó escanear un TAG"
            }
        //}else {
        //    DispatchQueue.main.async() {
        //        self.Cautions.isHidden = false
        //        self.Cautions.text = "Escriba un TAG válido, por favor."
        //    }
        //}
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
    
    func verifyTag(tag: String) {
        
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/tags/exists/\(tag)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Este será el response de validacion de TAG ")
                print(responseJSON)
                if let message = responseJSON["message"] as? String, message == "Tag no encontrado." {
                    // Opción 1: El tag no se encontró en la base de datos
                    DispatchQueue.main.async() {
                        self.Cautions.isHidden = false
                        self.Cautions.text = "Tag no encontrado."
                    }
                } else if let tag = responseJSON["tag"] as? String, let tp = responseJSON["tp"] {
                    if tp is String, tp as? String == "Not Found" {
                        // Opción 2: El tag se encontró en la base de datos, pero no hay información de controles
                        print("No se ha encontrado información en controles.")
                        DispatchQueue.main.async() {
                            self.Cautions.isHidden = false
                            self.Cautions.text = "No se ha encontrado información en nuestra base de datos."
                        }
                       
                    } else if let tpDict = tp as? [String: Any], let saldo = tpDict["saldoActual"] as? Int {
                        // Opción 3: El tag se encontró en la base de datos y hay información de controles
                        let fechaRespuesta = tpDict["fechaRespuesta"] as? String ?? ""
                        let noTag = tpDict["noTag"] as? String ?? ""
                        print("Tag encontrado. Saldo actual: \(saldo), Fecha de respuesta: \(fechaRespuesta), Número de tag: \(noTag)")
                        
                        DispatchQueue.main.async() {
                            self.Cautions.text = "Tag encontrado, esperando respuesta."
                            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "TelepeajeUploadViewController")
                            NotificationCenter.default.post(name: Notification.Name("TagTranslator"), object: self.barcode)
                            print("Tenemos que ver desde acá: \(self.TPADP)")
                           NotificationCenter.default.post(name: Notification.Name("TPADPTranslator"), object: String(0))
                        }
                    }
                }
            }
        }

        task.resume()
    }
    
    func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }

        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1

                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        return sum % 10 == 0
    }
    
    func desing() {
        Container.layer.cornerRadius = 20
        Container.layer.masksToBounds = true
    }
    
}

class ADPAddVehViewController: UIViewController {
    @IBOutlet weak var BarCodeInput: UITextField!
    @IBOutlet weak var Cautions: UITextView!
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var TelepeajeIMG: UIImageView!
    @IBOutlet weak var LabelTP: UILabel!
    var json: [String: Any] = [:]
    
    var barcode:String = ""
    var Email:String = ""
    var Name:String = ""
    var LoginToken:String = ""
    
    var TPADP = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        print("Se supone que este es ADP: \(TPADP)" )
        
        Cautions.isHidden = true
        BarCodeInput.tintColor = UIColor.black
        BarCodeInput.applyTextFieldStyle()
        
        desing()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("BarCode"), object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.BarCodeInput.text = self.barcode
            if (!self.luhnCheck(self.barcode)) {
                self.Cautions.isHidden = false
                self.Cautions.text = "El TAG ingresado es incorrecto."
            }
        }
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String
        
        barcode = text
        print(text)
    }
    
    @IBAction func ScanClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ScanViewController")
        NotificationCenter.default.post(name: Notification.Name("TPADPTranslator"), object: String(TPADP))
    }
    
    @IBAction func validarTagClicked(_ sender: Any) {
        //if luhnCheck(BarCodeInput.text!) {
            if !BarCodeInput.text!.isEmpty {
                barcode = BarCodeInput.text!
                if let firstChar = barcode.first, !firstChar.isLetter {
                    barcode = String(barcode.dropLast())
                }

                if !barcode.isEmpty {
                    verifyTag(tag: barcode)
                }
            }else {
                Cautions.isHidden = false
                Cautions.text = "Debe escribir ó escanear un TAG"
            }
        //}else {
        //    DispatchQueue.main.async() {
        //        self.Cautions.isHidden = false
        //        self.Cautions.text = "Escriba un TAG válido, por favor."
        //    }
        //}
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
    
    func verifyTag(tag: String) {
        
    
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/tags/exists/\(tag)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Este será el response de validacion de TAG ")
                print(responseJSON)
                if let message = responseJSON["message"] as? String, message == "Tag no encontrado." {
                    // Opción 1: El tag no se encontró en la base de datos
                    DispatchQueue.main.async() {
                        self.Cautions.isHidden = false
                        self.Cautions.text = "Tag no encontrado."
                    }
                } else if let tag = responseJSON["tag"] as? String, let tp = responseJSON["tp"] {
                    if tp is String, tp as? String == "Not Found" {
                        // Opción 2: El tag se encontró en la base de datos, pero no hay información de controles
                        print("No se ha encontrado información en controles.")
                        DispatchQueue.main.async() {
                            self.Cautions.isHidden = false
                            self.Cautions.text = "No se ha encontrado información en nuestra base de datos."
                        }
                       
                    } else if let tpDict = tp as? [String: Any], let saldo = tpDict["saldoActual"] as? Int {
                        // Opción 3: El tag se encontró en la base de datos y hay información de controles
                        let fechaRespuesta = tpDict["fechaRespuesta"] as? String ?? ""
                        let noTag = tpDict["noTag"] as? String ?? ""
                        print("Tag encontrado. Saldo actual: \(saldo), Fecha de respuesta: \(fechaRespuesta), Número de tag: \(noTag)")
                        
                        DispatchQueue.main.async() {
                            self.Cautions.text = "Tag encontrado, esperando respuesta."
                            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "TelepeajeUploadViewController")
                            NotificationCenter.default.post(name: Notification.Name("TagTranslator"), object: self.barcode)
                            print("Tenemos que ver desde acá: 1")
                            NotificationCenter.default.post(name: Notification.Name("TPADPTranslator"), object: String(1))
                           
                        }
                    }
                }
            }
        }

        task.resume()
    }
    
    func luhnCheck(_ number: String) -> Bool {
        var sum = 0
        let digitStrings = number.reversed().map { String($0) }

        for tuple in digitStrings.enumerated() {
            if let digit = Int(tuple.element) {
                let odd = tuple.offset % 2 == 1

                switch (odd, digit) {
                case (true, 9):
                    sum += 9
                case (true, 0...8):
                    sum += (digit * 2) % 9
                default:
                    sum += digit
                }
            } else {
                return false
            }
        }
        return sum % 10 == 0
    }
    
    func desing() {
        Container.layer.cornerRadius = 20
        Container.layer.masksToBounds = true
    }
    
}
