//
//  ContactanosViewController.swift
//  LineaExpres
//

import UIKit

class ContactanosViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ScrollContainer: UIScrollView!
    @IBOutlet weak var StackContainer: UIStackView!
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var lastnameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var numberInput: UITextField!
    @IBOutlet weak var commentInput: UITextView!
    
    var Email:String = ""
    var Name:String = ""
    var LoginToken:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        numberInput.delegate = self
        
        design()
        
    }
    
    @IBAction func trySendComment(_ sender: Any) {
        var isValid = true

        let inputArray = [nameInput, lastnameInput, emailInput, numberInput]

        for input in inputArray {
            if let text = input!.text, text.isEmpty {
                print("Entra?")
                input!.layer.borderColor = UIColor.red.cgColor
                isValid = false
            }
            if commentInput.text!.isEmpty {
                commentInput!.layer.borderColor = UIColor.red.cgColor
                isValid = false
            }
        }
        
        
        

        if isValid {
            design()
            
            sendComments(nombre: inputArray[0]?.text ?? "", apellido: inputArray[1]?.text ?? "", email: inputArray[2]?.text ?? "", number: inputArray[3]?.text ?? "", comment: commentInput.text ?? "")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           guard let text = textField.text else { return true }
           let newLength = text.count + string.count - range.length
           
           // Impedir que se ingresen más caracteres una vez que se alcance el límite de 9
           return newLength <= 10
       }
    
    func sendComments(nombre: String, apellido: String, email: String, number: String, comment: String) {
        let json: [String: Any] = ["nombre": nombre, "apellido": apellido, "email": email, "tel": number, "mensaje": comment]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/contact")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")
        request.setValue("text", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let statusCode = httpResponse.statusCode
            print("Status code:", statusCode)
            
            if statusCode == 200 {
                // El código de respuesta es 200, lo cual indica éxito
                print("Obtenemos respuesta 200")
                DispatchQueue.main.async {
                    self.showAlert(title: "¡Listo!", message: "Nos contactaremos con usted lo más pronto posible.")
                    NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HomeViewController")
                }
                

            } else {
                // El código de respuesta no es 200, hay un error
                DispatchQueue.main.async {
                    self.showAlert(title: "¡Error!", message: "Ha habido un error, revisa tus datos y/o intentalo más tarde.")
                }
                print("Error:", statusCode)
            }
        }
        task.resume()
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
    
    func design() {
        
        StackContainer.layer.cornerRadius = 20
        StackContainer.layer.masksToBounds = true
        //Ajustar padding a StackView
        StackContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        StackContainer.isLayoutMarginsRelativeArrangement = true
        
        nameInput.applyTextFieldStyle()
        lastnameInput.applyTextFieldStyle()
        emailInput.applyTextFieldStyle()
        numberInput.applyTextFieldStyle()
        
        commentInput.layer.borderWidth = 1.0
        commentInput.layer.cornerRadius = 5.0
        commentInput.layer.borderColor = UIColor.black.cgColor
        commentInput.backgroundColor = UIColor.white
    }
    
    
    
}
