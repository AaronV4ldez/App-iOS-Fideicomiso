//
//  RegisterViewController.swift
//  LineaExpres
//

import UIKit
import DropDown


class RegisterViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var curvedContainer: UIView!
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var ladaInput: UILabel!
    @IBOutlet weak var numberInput: UITextField!
    
    let dropDown = DropDown() //2
    @IBOutlet weak var MsgLabel: UILabel!
    let redColor = UIColor.red
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.curvedContainer.layer.cornerRadius = 20
        MsgLabel.isHidden = true
        
        
        fullName.tintColor = UIColor.black
        emailInput.tintColor = UIColor.black
        numberInput.tintColor = UIColor.black
        
        
        fullName.applyTextFieldStyle()
        emailInput.applyTextFieldStyle()
        numberInput.applyTextFieldStyle()
        
        ladaInput.layer.borderWidth = 1.0
        ladaInput.layer.borderColor = UIColor.black.cgColor
        ladaInput.layer.cornerRadius = 5.0
        ladaInput.layer.masksToBounds = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //view.addGestureRecognizer(tap)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapChooseMenuItem(_:)))
        
        ladaInput.isUserInteractionEnabled = true
        ladaInput.addGestureRecognizer(tapGesture)
        
        
        numberInput.delegate = self
    }
    
    
    @IBAction func tapChooseMenuItem(_ sender: UITapGestureRecognizer) {
        dropDown.dataSource = ["MEX", "USA"]
        dropDown.anchorView = sender as? AnchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender.view?.frame.height)! - 25)

        dropDown.width = sender.view?.frame.width

        dropDown.show()
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let _ = self else { return }
            DispatchQueue.main.async() {
                self!.ladaInput.text = item
            }
        }
    }
    
    @IBAction func onRegisterClick(_ sender: Any) {
        let fullNameString:String = fullName.text!
        let emailString:String = emailInput.text!
        let numberString:String = numberInput.text!
        let ladaNumber:String = ladaInput.text!
        var valor:Int = 0
        var lada = "+52"
        
        if ladaNumber.contains("MEX") {
            lada = "+52"
        }else if ladaNumber.contains("USA") {
            lada = "+1"
        }
        
        for _ in 1...3 {
            if fullNameString.isEmpty {
                fullName.layer.borderColor = redColor.cgColor
                fullName.layer.borderWidth = 1
                valor = 1
                print("Nombre no debe estar vacio")
            }else {
                fullName.layer.borderWidth = 0
            }
            if emailString.isEmpty {
                emailInput.layer.borderColor = redColor.cgColor
                emailInput.layer.borderWidth = 1
                valor = 2
                print("Email no debe ser vacio")
            }else {
                emailInput.layer.borderWidth = 0
            }
            if numberString.isEmpty {
                numberInput.layer.borderColor = redColor.cgColor
                numberInput.layer.borderWidth = 1
                valor = 2
                print("Número no debe ser vacio")
            }else {
                numberInput.layer.borderWidth = 0
            }
            if ladaNumber.contains("LADA") {
                ladaInput.layer.borderColor = redColor.cgColor
                ladaInput.layer.borderWidth = 1
                valor = 2
            }
            
            
            if valor > 0 {
                print("No podemos continuar")
                return
            }
            
            
            doRegister(fullName: fullNameString, Email: emailString, Number: numberString, Lada: lada)
        }
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
            // Acción que se ejecuta cuando el texto cambia
            if let text = textField.text {
                let n = text.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "")
                textField.text = n
            }
        }
    
    func doRegister(fullName: String, Email: String, Number: String, Lada: String) {
        let json: [String: Any] = ["fullname": fullName, "email": Email, "phone": Number, "cc": Lada]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
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
                let message: String = responseJSON["message"] as? String ?? ""
                
                if ((message.contains("Usuario ya existe"))) {
                    DispatchQueue.main.async() {
                        self.MsgLabel.text = message
                        self.MsgLabel.isHidden = false
                        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "CodeSMSViewController")
                        NotificationCenter.default.post(name: Notification.Name("email"), object: "\(Email),\(Number)")
                        NotificationCenter.default.post(name: Notification.Name("message"), object: message)
                    }
                }else {
                    DispatchQueue.main.async() {
                        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "CodeSMSViewController")
                        NotificationCenter.default.post(name: Notification.Name("email"), object: "\(Email),\(Number)")
                        NotificationCenter.default.post(name: Notification.Name("message"), object: message)
                    }
                }
            }
        }
        task.resume()
    }
}

class CodeSMSViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var curvedContainer: UIStackView!
    @IBOutlet weak var CodigoInput: UITextField!
    @IBOutlet weak var correoLabel: UILabel!
    @IBOutlet weak var CodeError: UILabel!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var ladaInput: UILabel!
    @IBOutlet weak var btnConfirmCode: UIButton!
    @IBOutlet weak var Container: UIStackView!
    let dropDown = DropDown() //2
    
    
    var phone = ""
    var mail = ""
    
    var wrongNumber = false
    
    let redColor = UIColor.red
    let greenColor = UIColor.green
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneLabel.tintColor = UIColor.black
        phoneLabel.applyTextFieldStyle()
        
        phoneLabel.delegate = self
        
        Container.layer.cornerRadius = 20
        Container.layer.masksToBounds = true
        //Ajustar padding a StackView
        Container.layoutMargins = UIEdgeInsets(top: 15, left: 50, bottom: 15, right: 50)
        Container.isLayoutMarginsRelativeArrangement = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("email"), object: nil)
                
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapChooseMenuItem(_:)))

        ladaInput.isUserInteractionEnabled = true
        ladaInput.addGestureRecognizer(tapGesture)
    }
   
    @IBAction func confirmCode(_ sender: Any) {
       
        phone = phoneLabel.text!
        
        if wrongNumber {
            wrongNumber = false
            phoneLabel.isEnabled = false
            ladaInput.isHidden = true
            btnConfirmCode.setTitle("Confirmar Código", for: .normal)
            generateNewCode(Email: mail, Phone: phone)
        }else {
            let CodigoText:String = CodigoInput.text!
            let Email:String = correoLabel.text!
           
            
            CodigoInput.layer.borderWidth = 1
            if CodigoText.isEmpty {
                CodigoInput.layer.borderColor = redColor.cgColor
               
                return
            }
            CodigoInput.layer.borderColor = greenColor.cgColor
            
            doValidation(Code: CodigoText, Email: Email)
        }
        
       
       
        
    }
    
    @IBAction func wrongNumber(_ sender: Any) {
        wrongNumber = true;
        phoneLabel.isEnabled = true
        ladaInput.isHidden = false
        btnConfirmCode.setTitle("Confirmar número", for: .normal)
    }
    
    @IBAction func newCode(_ sender: Any) {
        generateNewCode(Email: mail, Phone: phone)
    }
    
    func doValidation(Code:String, Email:String){
        let parameters: [String: Any] = ["email": Email, "activation_code": Code]
         
         let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/validate")!
         
         let session = URLSession.shared
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         
         request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         
         do {
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
         } catch let error {
           print(error.localizedDescription)
           return
         }
         
         let task = session.dataTask(with: request) { data, response, error in
           
           if let error = error {
             print("Post Request Error: \(error.localizedDescription)")
             return
           }
           
           guard let responseData = data else {
             print("nil Data received from the server")
             return
           }
           
           do {
             if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
               print(jsonResponse)
                 let message:String? = jsonResponse["message"] as? String
                 if message != nil {
                     DispatchQueue.main.async() {
                         
                         NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "successfullyViewController")
                         NotificationCenter.default.post(name: Notification.Name("FinishMSG"), object: message!)
                     }
                 }
                 
    
             } else {
               print("data maybe corrupted or in wrong format")
               throw URLError(.badServerResponse)
             }
           } catch let error {
             print(error.localizedDescription)
           }
         }
         task.resume()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let text = textField.text else { return true }
           let newLength = text.count + string.count - range.length
           
           // Impedir que se ingresen más caracteres una vez que se alcance el límite de 9
           return newLength <= 10
       }
    
    func generateNewCode(Email:String, Phone:String){
        let parameters: [String: Any] = ["email": Email, "phone": Phone]
         
         let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/newvcode")!
         
         let session = URLSession.shared
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         
         request.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
         request.addValue("application/json", forHTTPHeaderField: "Accept")
         
         do {
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
         } catch let error {
           print(error.localizedDescription)
           return
         }
         
         let task = session.dataTask(with: request) { data, response, error in
           
           if let error = error {
             print("Post Request Error: \(error.localizedDescription)")
             return
           }
           
           guard let responseData = data else {
             print("nil Data received from the server")
             return
           }
           
           do {
             if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
               print("Esta es la respuesta del nuevo código: \(jsonResponse)")
                 let message:String? = jsonResponse["message"] as? String
                 if message != nil {
                     DispatchQueue.main.async() {
                         
                     }
                 }
                 
    
             } else {
               print("data maybe corrupted or in wrong format")
               throw URLError(.badServerResponse)
             }
           } catch let error {
             print(error.localizedDescription)
           }
         }
         task.resume()
    }
    
    @IBAction func tapChooseMenuItem(_ sender: UITapGestureRecognizer) {
           dropDown.dataSource = ["MEX", "USA"]
           
           dropDown.anchorView = sender as? any AnchorView //5
           dropDown.bottomOffset = CGPoint(x: -ladaInput.frame.size.width, y: ladaInput.frame.size.height) //6
           dropDown.show() //7
           dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
               guard let _ = self else { return }
               
               DispatchQueue.main.async() {
                   self!.ladaInput.text = item //9
               }
               
               
           }
       }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String
        let components = text.components(separatedBy: ",")
        
        
        print("Se supone es lo de text: \(text)")
        
        if components.count >= 2 {
            let email = components[0].trimmingCharacters(in: .whitespaces)
            let phoneNumber = components[1].trimmingCharacters(in: .whitespaces)
            
            // Realiza las acciones necesarias con el email y el número de teléfono
            print("Email: \(email)")
            print("Número de teléfono: \(phoneNumber)")
            
            correoLabel.text = email
            phoneLabel.text = phoneNumber
            mail = email
            phone = phoneNumber
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
