//
//  DatosFacturacionViewController.swift
//  LineaExpres
//

import UIKit
import Stylist

class DatosFacturacionViewController: UIViewController {
    
    @IBOutlet weak var StackContainer: UIStackView!
    @IBOutlet weak var RazonSocialInput: UITextField!
    @IBOutlet weak var RFCInput: UITextField!
    @IBOutlet weak var DomFiscalInput: UITextField!
    @IBOutlet weak var CodigoPostalInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var TelefonoInput: UITextField!
    @IBOutlet weak var LabelMsg: UILabel!
    
    var Email:String = ""
    var Name:String = ""
    var LoginToken:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        //asignando estilos
        //Redondear stackview
        StackContainer.layer.cornerRadius = 20
        StackContainer.layer.masksToBounds = true
        //Ajustar padding a StackView
        StackContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        StackContainer.isLayoutMarginsRelativeArrangement = true
        
        RazonSocialInput.tintColor = UIColor.black
        RFCInput.tintColor = UIColor.black
        DomFiscalInput.tintColor = UIColor.black
        CodigoPostalInput.tintColor = UIColor.black
        EmailInput.tintColor = UIColor.black
        TelefonoInput.tintColor = UIColor.black
        
        RazonSocialInput.applyTextFieldStyle()
        RFCInput.applyTextFieldStyle()
        DomFiscalInput.applyTextFieldStyle()
        CodigoPostalInput.applyTextFieldStyle()
        EmailInput.applyTextFieldStyle()
        TelefonoInput.applyTextFieldStyle()
        
        //Ajustando tamaño al stackview
        StackContainer.layoutIfNeeded()
        let visibleSubviews = StackContainer.arrangedSubviews.filter { !$0.isHidden }
        let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
        StackContainer.frame.size.height = totalHeight
        
       
    }
    
    
    @IBAction func SaveBtnClicked(_ sender: Any) {
        addFact()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            
            UIView.animate(withDuration: animationDuration) {
                self.view.frame.origin.y = -keyboardHeight/2
                self.StackContainer.layoutMargins = UIEdgeInsets(top: 150, left: 15, bottom: 150, right: 15)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            
            UIView.animate(withDuration: animationDuration) {
                self.view.frame.origin.y = 0
                self.StackContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            }
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

    func addFact() {
        let razonSocial: String = RazonSocialInput.text ?? ""
        let rfcFiscal: String = RFCInput.text ?? ""
        let domFiscal: String = DomFiscalInput.text ?? ""
        let emailFiscal: String = EmailInput.text ?? ""
        let telefonoFiscal: String = TelefonoInput.text ?? ""
        let codigoPostalFiscal: String = CodigoPostalInput.text ?? ""
        
        let json: [String: Any] = ["fac_razon_social": razonSocial, "fac_rfc": rfcFiscal, "fac_dom_fiscal": domFiscal, "fac_email": emailFiscal, "fac_telefono": telefonoFiscal, "fac_cp": codigoPostalFiscal]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        //var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/fac")!)
        var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx/api/v1/user/fac")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                
                let message:String = responseJSON["message"] as? String ?? ""
                print("Datos de facturación \(message)")
                if message != "" {
                    if message.contains("exitosamente") {
                        DB_Manager().addBillingData(RazonSocial: razonSocial, RFC: rfcFiscal, DomFiscal: domFiscal, CP: codigoPostalFiscal, Email: emailFiscal, Telefono: telefonoFiscal)
                    }
                    DispatchQueue.main.async() {
                        self.LabelMsg.isHidden = false
                        self.LabelMsg.text = message
                    }
                }
            }
        }
        
        task.resume()
    }

}
