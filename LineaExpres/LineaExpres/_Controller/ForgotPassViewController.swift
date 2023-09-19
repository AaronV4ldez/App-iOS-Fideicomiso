//
//  ForgotPassViewController.swift
//  LineaExpres
//

import UIKit

class ForgotPassViewController: UIViewController {

    @IBOutlet weak var Container: UIStackView!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var msgLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRadius()
    }
    
    @IBAction func reqForgotPassClicked(_ sender: Any) {
        requestPass()
    }
    
    func startRadius() {
        
        Container.layer.cornerRadius = 20
        Container.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        Container.isLayoutMarginsRelativeArrangement = true
        
        emailInput.tintColor = UIColor.black
        emailInput.applyTextFieldStyle()
    }
    
    
    func requestPass() {
    
        let json: [String: Any] = ["email": emailInput.text!]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/resetpass")!
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
                
                let message:String? = responseJSON["message"] as? String
                if message != nil {
                    DispatchQueue.main.async {
                        self.msgLbl.text = message
                        if ((message!.contains("Proceso de reseteo de contraseña fue iniciado"))) {
                            self.msgLbl.text = "Contraseña generada exitosamente. \n Revise su email, ahí podrá realizar el cambio de contraseña y podrá iniciar sesión en la app rápidamente."
                        }
                       
                    }
                    
                }
                
                
            }
        }
          task.resume()
    }
    
}
