//
//  PaymentViewController.swift
//  LineaExpres
//

import UIKit
import StripePaymentSheet
import Stripe

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var qtyPayInput: UITextField!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var UITagSel: UITextField!
    var paymentSheet: PaymentSheet?
    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    var payment_intent: String = ""
    var payment_intent_client_secret: String = ""
    @IBOutlet weak var StackViewContainer: UIStackView!
    
    var qtyToPay:Int = 0
    var Tag:String = ""
    var Valor:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
            
        }
        
        
        checkoutBtn.addTarget(self, action: #selector(didTapCheckoutButton), for: .touchUpInside)
        checkoutBtn.isEnabled = false
        
        desing()
       
   
    }
     
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(didQty(_:)), name: Notification.Name("QtyToPay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didTag(_:)), name: Notification.Name("TagSelected"), object: nil)
        
        
    }
    
    @objc func didQty(_ notification: Notification) {
        let text:Int? = notification.object as? Int
        let multiply = text! * 100
        let Valorra = String(multiply)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.requestCert(amount: Valorra)
        }
        let Val = String(text!)
        
        self.qtyPayInput.text = "$\(Val).00 MXN"
    }
    
    @objc func didTag(_ notification: Notification) {
        let text:String = notification.object as! String
        Tag = text
        self.UITagSel.text = text
    }
    
    func requestCert(amount: String) {
        let json: [String: Any] = ["amount": amount]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        //let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/stripe/createpi")!
        let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/stripe/createpi")!
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
                let client_secret: String? = responseJSON["client_secret"] as? String
                let pi: String? = responseJSON["pi"] as? String
                let publishableKey: String? = responseJSON["publishableKey"] as? String
                if client_secret != nil || publishableKey != nil {
                    self.payment_intent = pi!
                    self.payment_intent_client_secret = client_secret!
                    self.requestPayment(clientSecret: client_secret!, publishKey: publishableKey!)
                }else {
                    print("Surgió un problema")
                }
                
               
            }
        }
          task.resume()
    }
    
    func requestPayment(clientSecret: String, publishKey: String) {
        STPAPIClient.shared.publishableKey = publishKey
        // MARK: Create a PaymentSheet instance
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Línea Exprés"
        configuration.allowsDelayedPaymentMethods = true
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: clientSecret, configuration: configuration)
       
        
        DispatchQueue.main.async {
            self.checkoutBtn.isEnabled = true
        }
        
    }
    
    @objc
    func didTapCheckoutButton() {
      // MARK: Start the checkout process
      paymentSheet?.present(from: self) { paymentResult in
          
        // MARK: Handle the payment result
        switch paymentResult {
        case .completed:
          print("Your order is confirmed")
            self.confirmarOrden(TipoConfirmacion: "succeeded")
        case .canceled:
          print("Canceled!")
            self.confirmarOrden(TipoConfirmacion: "denied")
        case .failed(let error):
          print("Payment failed: \(error)")
            self.confirmarOrden(TipoConfirmacion: "denied")
        }
      }
    }
    
    func confirmarOrden(TipoConfirmacion: String) {
        // create post request
        //let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/stripe/confirm/TP\(Tag)?payment_intent=\(payment_intent)&payment_intent_client_secret=\(payment_intent_client_secret)&redirect_status=\(TipoConfirmacion)")!
        let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/stripe/confirm/TP\(Tag)?payment_intent=\(payment_intent)&payment_intent_client_secret=\(payment_intent_client_secret)&redirect_status=\(TipoConfirmacion)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")
        request.setValue("text", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                  print(error)
                  return
              }
            
            guard let httpResponse = response as? HTTPURLResponse,
                     (100...599).contains(httpResponse.statusCode) else {
                   print("HTTP request failed")
                   return
               }

            
            if let data = data, let string = String(data: data, encoding: .utf8) {

                 if let data = string.data(using: .utf8) {
                     if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                         
                         if TipoConfirmacion.contains("succeeded") {
                             DispatchQueue.main.async {
                                 NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"showVehiclesViewController")
                             }
                            
                         }
                
                         
                     } else {
                         print("Error: Could not convert JSON string to")
                     }
                 }
                 
            }
        }
          task.resume()
    }
    
    func desing() {
        //Ajustar padding a StackView
        StackViewContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        StackViewContainer.isLayoutMarginsRelativeArrangement = true
        
        StackViewContainer.layer.cornerRadius = 20
        StackViewContainer.layer.masksToBounds = true
        
        qtyPayInput.tintColor = UIColor.black
        UITagSel.tintColor = UIColor.black
        
        qtyPayInput.applyTextFieldStyle()
        UITagSel.applyTextFieldStyle()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
  


    func verifyLogging() -> Bool {
        
        var pass:Bool = false
        let Lista:Array<String> = DB_Manager().getUsuario()
        if (Lista.count != 0) {
            for i in 0..<(Lista.count) {
                let Usuario = Lista[i].components(separatedBy: "∑")
                LoginToken = Usuario[3]
     
                pass = true
            }
        }
        return pass

    }
    
}

