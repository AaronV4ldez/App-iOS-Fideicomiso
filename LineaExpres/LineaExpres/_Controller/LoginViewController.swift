//
//  LoginViewController.swift
//  LineaExpres
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController {


    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loginContainer: UIStackView!
    
    @IBOutlet weak var CorreoInput: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var btnIngresar: UIButton!
    
    let redColor = UIColor.red
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
        startRadius()
        
        
        
    }


    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @IBAction func ForgotPassBtnClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ForgotPassViewController")
    }
    
    @IBAction func Ingresar(_ sender: Any) {
        let CorreoText: String = CorreoInput.text!
        let PasswordText: String = PasswordInput.text!
        var valor: Int = 0
        
        for _ in 1...2{
            if CorreoText.isEmpty {
                CorreoInput.layer.borderColor = redColor.cgColor
                CorreoInput.layer.borderWidth = 1
                valor = 1
                print("Correo no debe estar empty")
            }else {
                CorreoInput.layer.borderWidth = 0
            }
            if PasswordText.isEmpty {
                PasswordInput.layer.borderColor = redColor.cgColor
                PasswordInput.layer.borderWidth = 1
                valor = 2
                print("Password no debe estar empty")
            }else {
                PasswordInput.layer.borderWidth = 0
            }
        }
        if valor > 0 {
            print("No podemos continuar")
            return;
        }

        doLogin(email: CorreoText, Password: PasswordText)
       
    }
    
    func startRadius() {
        self.loginContainer.layer.cornerRadius = 20
        //Ajustar padding a StackView
        self.loginContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.loginContainer.isLayoutMarginsRelativeArrangement = true
        
        CorreoInput.tintColor = UIColor.black
        PasswordInput.tintColor = UIColor.black
        CorreoInput.applyTextFieldStyle()
        PasswordInput.applyTextFieldStyle()
    }
    
    func doLogin(email:String, Password:String) {
    
        let json: [String: Any] = ["userlogin": email, "password": Password]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        //let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/session/login")!
        let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/session/login")!
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
                print("Detalles de login \(responseJSON)")
                
                if responseJSON["name"] as? String == nil {
                    let error: String? = responseJSON["message"] as? String
                    if ((error?.contains("invalidas")) != nil) {
                        print("Username es null")
                        
                        DispatchQueue.main.async() {
                            self.PasswordInput.layer.borderColor = self.redColor.cgColor
                            self.PasswordInput.layer.borderWidth = 1
                        }
                        
                       
                    }
                    return
                }
                
                
                let UserName:String? = responseJSON["name"] as? String
                let AccessToken:String? = responseJSON["access_token"] as? String
                let UserSetPwd:String = String(responseJSON["user_set_pwd"] as? Int ?? 0)
                let sentri:String = String(responseJSON["sentri"] as? String ?? "")
                let sentri_exp_date:String = String(responseJSON["sentri_exp_date"] as? String ?? "")
                
                let fac_razon_social:String = String(responseJSON["fac_razon_social"] as? String ?? "")
                let fac_dom_fiscal:String = String(responseJSON["fac_dom_fiscal"] as? String ?? "")
                let fac_email:String = String(responseJSON["fac_email"] as? String ?? "")
                let fac_telefono:String = String(responseJSON["fac_telefono"] as? String ?? "")
                let fac_rfc:String = String(responseJSON["fac_rfc"] as? String ?? "")
                let fac_cp:String = String(responseJSON["fac_cp"] as? String ?? "")
                
                
                
                print("Datos de fact")
                
                DB_Manager().addUser(EmailVal: email, NameVal: UserName!, LoginTokenVal: AccessToken!, UserSetPwdVal: UserSetPwd, Sentri: sentri, SentriFecha: sentri_exp_date)
                DB_Manager().addBillingData(RazonSocial: fac_razon_social, RFC: fac_rfc, DomFiscal: fac_dom_fiscal, CP: fac_cp, Email: fac_email, Telefono: fac_telefono)
                
                if !UserSetPwd.contains("0") {
                    DispatchQueue.main.async() {
                        self.view.endEditing(true)
                        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ProfileViewController")
                    }
                }else {
                    DispatchQueue.main.async() {
                        self.view.endEditing(true)
                        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ProfileViewController")
                    }
                }
                
                
                //let usuario:Array = DB_Manager().getUser()
                //print(usuario)
            }
        }
          task.resume()
    }
    

    
    @IBAction func goToRegister(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "RegisterViewController")
    }
    @IBAction func goToTermsAndConds(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HamburgerTabsViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoServicio"), object: "https://lineaexpress.desarrollosenlanube.net/wp-json/wp/v2/pages/1445?_embed")
    }
    
    
}
