//
//  ChangeEmailViewController.swift
//  LineaExpres
//
//

import UIKit

class ChangeEmailViewController: UIViewController {

    @IBOutlet weak var CurrentEmail: UITextField!
    @IBOutlet weak var NewEmail: UITextField!
    @IBOutlet weak var Container: UIView!
    @IBOutlet weak var MessageAlert: UILabel!
    
    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MessageAlert.isHidden = true
        CurrentEmail.applyTextFieldStyle()
        NewEmail.applyTextFieldStyle()
        CurrentEmail.tintColor = UIColor.black
        NewEmail.tintColor = UIColor.black
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let validationPass:Bool = verifyLogging()
        if (validationPass) {
            startRounding()

            CurrentEmail.text = Email
 
        }else {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
    }
    
    @IBAction func ConfirmClicked(_ sender: Any) {
        
        
        let uNewEmail:String = NewEmail.text!
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValidEmail = emailPredicate.evaluate(with: uNewEmail)
        
        if isValidEmail {
            NewEmail.textColor = .green
            if uNewEmail.isEmpty {
                DispatchQueue.main.async {
                    self.showAlert(title: "¡Atención!", message: "Debes colocar el nuevo Email.")
                    self.NewEmail.layer.borderColor = UIColor.red.cgColor
                    self.NewEmail.layer.borderWidth = 1.0
                    self.NewEmail.layer.cornerRadius = 5.0
                }
                return
            }
            MessageAlert.isHidden = false
            
            requestChange(newEmail: uNewEmail)
        } else {
            DispatchQueue.main.async {
                self.showAlert(title: "¡Atención!", message: "El nuevo email debe ser válido.")
                self.NewEmail.layer.borderColor = UIColor.red.cgColor
                self.NewEmail.layer.borderWidth = 1.0
                self.NewEmail.layer.cornerRadius = 5.0
            }
        }
        
        
        
        
    }
    
    func requestChange(newEmail:String) {
        let json: [String: Any] = ["newemail": newEmail]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/emailchangereq")!
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
                DispatchQueue.main.async() {
                    self.view.endEditing(true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        NotificationCenter.default.post(name: Notification.Name("Logout"), object: "Logout")
                        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"HomeViewController")
                    }
                    
                    if message != nil {
                        self.MessageAlert.text = message
                    }else {
                        self.MessageAlert.text = message
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

  
    
}
