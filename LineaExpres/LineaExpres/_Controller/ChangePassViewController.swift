//
//  ChangePassViewController.swift
//  LineaExpres
//

import UIKit

class ChangePassViewController: UIViewController {

    @IBOutlet weak var MsgLabel: UILabel!
    @IBOutlet weak var Container: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var CurrentEmail: UITextField!
    @IBOutlet weak var temporalPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordConfirm: UITextField!
    
    let borderWidth: CGFloat = 1.0
    let borderColor: UIColor = .black
    let cornerRadius: CGFloat = 5.0
    
    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    var alreadyChangePass:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MsgLabel.isHidden = true
        
        // Aplica el borde a cada uno de los text fields
        CurrentEmail.tintColor = UIColor.black
        CurrentEmail.applyTextFieldStyle()
        temporalPassword.tintColor = UIColor.black
        temporalPassword.applyTextFieldStyle()
        newPassword.tintColor = UIColor.black
        newPassword.applyTextFieldStyle()
        newPasswordConfirm.tintColor = UIColor.black
        newPasswordConfirm.applyTextFieldStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let validationPass:Bool = verifyLogging()
        if (validationPass) {
            startRounding()

            CurrentEmail.text = Email
            
            if alreadyChangePass.contains("1") {
                temporalPassword.attributedPlaceholder = NSAttributedString(string: "Contraseña actual", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                titleLabel.isHidden = true
            }
           

 
        }else {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
    }
    
    @IBAction func ContinueClicked(_ sender: Any) {
        MsgLabel.isHidden = false
        
        let arrayPass: [UITextField] = [temporalPassword, newPassword, newPasswordConfirm]
        var passwordCorrect: Int = 0

        for textField in arrayPass {
            if textField.text!.isEmpty {
                passwordCorrect = passwordCorrect + 1
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
                textField.layer.cornerRadius = 5.0
            }
        }
        
        if newPassword.text!.elementsEqual(newPasswordConfirm.text!) {
            if passwordCorrect == 0 {
                requestChange(currentEmail: Email, temporalPass: temporalPassword.text!, newPass: newPassword.text!)
            }else {
                DispatchQueue.main.async {
                    self.showAlert(title: "¡Atención!", message: "Debe llenar todos los campos.")
                }
            }
        }else {
            DispatchQueue.main.async {
                self.showAlert(title: "¡Atención!", message: "Debe confirmar su contraseña.")
            }
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
    
    func requestChange(currentEmail:String, temporalPass:String, newPass: String) {
        let json: [String: Any] = ["email": currentEmail, "current_password": temporalPass, "new_password": newPass]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        //let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/resetpass")!
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/changepass")!
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
                
                if message != nil {
                    if message!.contains("Contraseña cambiada exitosamente.") {
                        DispatchQueue.main.async() {
                            self.view.endEditing(true)
                            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "successfullyViewController")
                            NotificationCenter.default.post(name: Notification.Name("FinishMSG"), object: message!)
                            
                            DB_Manager().addUser(EmailVal: "", NameVal: "", LoginTokenVal: "", UserSetPwdVal: "", Sentri: "", SentriFecha: "")
                        }
                    }else {
                        DispatchQueue.main.async {
                            self.showAlert(title: "¡Atención!", message: message!)
                        }
                    }
                    
                }
            }
        }
          task.resume()
    }
    
    func startRounding() {
        self.Container.layer.cornerRadius = 20
        Container.layer.masksToBounds = true
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
                alreadyChangePass = Usuario[4]
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

    

}
