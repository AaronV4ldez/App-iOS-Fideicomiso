//
//  EscogerCantidadViewController.swift
//  LineaExpres
//

import UIKit
import DropDown

class EscogerCantidadViewController: UIViewController {

    @IBOutlet weak var qtyPayInput: UITextField!
    @IBOutlet weak var checkoutBtn: UIButton!
    var LoginToken:String = ""
    
    @IBOutlet weak var UITagSelected: UILabel!
   
    @IBOutlet weak var UICheckout: UIButton!
    
   
    
    @IBOutlet weak var StackViewContainer: UIStackView!
   
    
    //Getting interface to change
    @IBOutlet weak var seleccionarTarifa: UIButton!
    @IBOutlet weak var selectCountry: UISegmentedControl!
    @IBOutlet weak var UICantidadACargar: UITextField!
    @IBOutlet weak var SeleccioneElOrigen: UILabel!
    @IBOutlet weak var msg: UILabel!
    
    
    var positionCountry = 0
    let dropDown = DropDown()
    
    var tag = ""
    var puente = ""
    var tipoContrato = ""
    
    var pais = "Mexico"
    
    var anual_zaragoza_mx:String = ""
    var anual_lerdo_mx:String = ""
    var anual_zaragoza_us:String = ""
    var anual_lerdo_us:String = ""
    var anual_mixto_mx:String = ""
    var anual_mixto_us:String = ""
    var saldo_zaragoza1_mx:String = ""
    var saldo_zaragoza2_mx:String = ""
    var saldo_zaragoza1_us:String = ""
    var saldo_zaragoza2_us:String = ""
    var pago_minimotp_mx:String = ""
    
    var Cantidad = ""
    
    var DropSelector: [String] = []
    var vehType: String = "0"
    
    var NotificationCatch:Bool = false
 
    override func viewDidLoad() {
        
        super.viewDidLoad()

        desing()
       
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("TagSelected"), object: nil)
        
        selectCountry.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
      
    }
    
    @IBAction func clickCantidad(_ sender: Any) {
       
        dropDown.anchorView = sender as? any AnchorView //5
        dropDown.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            (sender as AnyObject).setTitle(item, for: .normal) //9
            self!.UICantidadACargar.text = item
            self!.Cantidad = item
        }
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String

        let sel = text.components(separatedBy: ",")
        
        NotificationCatch = true

        tag = sel[0]
        puente = sel[1]
        tipoContrato = sel[2]
       
        
        
        print("Tipos = \(puente) \(tipoContrato)")
        
        if tipoContrato.contains("0") {
            seleccionarTarifa.isHidden = true
            selectCountry.isHidden = true
            UICantidadACargar.isEnabled = true
            SeleccioneElOrigen.isHidden = true
            vehType = sel[3]
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.UICantidadACargar.text = self.pago_minimotp_mx
            }
            requestMob()
        }else {
            vehType = sel[3]
            requestMob()
        }
       
    
        UITagSelected.text = tag
       
        NotificationCenter.default.removeObserver(self, name: Notification.Name("viewChanger"), object: nil)
    }
    
    @objc func segmentedControlValueChanged(sender: UISegmentedControl) {
        positionCountry = sender.selectedSegmentIndex
        self.UICantidadACargar.text = ""
        self.Cantidad = ""
        self.seleccionarTarifa.setTitle("Seleccionar tarifa", for: .normal)
        if positionCountry == 0 {
                    pais = "Mexico"
                    if (tipoContrato.contains("V")) {
                        if puente.contains("104") {
                            DropSelector = [anual_lerdo_mx]
                        }
                        if puente.contains("105") {
                            DropSelector = [anual_zaragoza_mx]
                            
                        }
                    }
                    if (tipoContrato.contains("C")) {
                        if puente.contains("104") {
                            DropSelector = [saldo_zaragoza1_mx, saldo_zaragoza2_mx]
                        }
                        if puente.contains("105") {
                            DropSelector = [saldo_zaragoza1_mx, saldo_zaragoza2_mx]
                        }
                    }
                    if (tipoContrato.contains("M")) {
                        DropSelector = [anual_mixto_mx]
                    }
                    
                    
                }else {
                    pais = "USA"
                    if (tipoContrato.contains("V")) {
                        if puente.contains("104") {
                            DropSelector = [anual_lerdo_us]
                        }
                        if puente.contains("105") {
                            DropSelector = [anual_zaragoza_us]
                        }
                    }
                    if (tipoContrato.contains("C")) {
                        if puente.contains("104") {
                            DropSelector = [saldo_zaragoza1_us, saldo_zaragoza2_us]
                        }
                        if puente.contains("105") {
                            DropSelector = [saldo_zaragoza1_us, saldo_zaragoza2_us]
                        }
                    }
                    if (tipoContrato.contains("M")) {
                        DropSelector = [anual_mixto_us]
                    }
                }

        
        dropDown.dataSource = DropSelector
        
        
       
    }
    
    
    @IBAction func CheckoutBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
       
        Cantidad = UICantidadACargar.text!
        
        if Cantidad.isEmpty {
            return
        }
  
        print("El monto del usuario es: \(Cantidad) ")
        print("El monto minimo es: \(pago_minimotp_mx) ")
        
        let numero = Double(Cantidad) ?? 0.0

        // Convertir el número de punto flotante a un número entero
        
        
        let MontoPorUsuario = Int(numero)
        var MontoMinimoTelepeaje: Int = 100
        
        if let dotIndex = pago_minimotp_mx.firstIndex(of: ".") {
            let intString = String(pago_minimotp_mx[..<dotIndex])
            MontoMinimoTelepeaje = Int(intString)! as Int
        }
        
        
        if (MontoPorUsuario < MontoMinimoTelepeaje) {
            DispatchQueue.main.async {
                self.msg.text = "El monto mínimo es de $\(self.pago_minimotp_mx)"
            }
           
            return
        }
        
       
        
        
        print("Tipo de contrato es: \(tipoContrato)")
        print("Tipo de vehType es: \(vehType)")
        if tipoContrato.contains("0") {
            if vehType.contains("2") {
                vehType = "5"
            }
            if vehType.contains("0"){
                vehType = "0"
            }

            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"BanortePaymentViewController")
            NotificationCenter.default.post(name: Notification.Name("QtyToPay"), object: Cantidad)
            NotificationCenter.default.post(name: Notification.Name("TagSelected2"), object:UITagSelected.text)
            NotificationCenter.default.post(name: Notification.Name("ContractTypeTagSel"), object:tipoContrato)
            NotificationCenter.default.post(name: Notification.Name("vehicletype"), object:vehType)
        }else if vehType.contains("1") {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"BanortePaymentViewController")
            NotificationCenter.default.post(name: Notification.Name("QtyToPay"), object: Cantidad)
            NotificationCenter.default.post(name: Notification.Name("TagSelected2"), object:UITagSelected.text)
            NotificationCenter.default.post(name: Notification.Name("ContractTypeTagSel"), object:tipoContrato)
            NotificationCenter.default.post(name: Notification.Name("vehicletype"), object:"1")
        }
       
        
    }
    
    func desing() {
        //Ajustar padding a StackView
        StackViewContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        StackViewContainer.isLayoutMarginsRelativeArrangement = true
        
        StackViewContainer.layer.cornerRadius = 20
        StackViewContainer.layer.masksToBounds = true
        
        UICantidadACargar.tintColor = UIColor.black
        //qtyPayInput.tintColor = UIColor.black
        UICantidadACargar.applyTextFieldStyle()
        //qtyPayInput.applyTextFieldStyle()
        
    }
    
    func requestMob() {
        // create post request
        let session = URLSession.shared
       
         let sem = DispatchSemaphore.init(value: 0)

         var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/config/mobile")!)
         request.httpMethod = "GET"
         request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    
                    self.anual_zaragoza_mx = dictionary["anual_zaragoza_mx"] as? String ?? "undefined"
                    self.anual_lerdo_mx = dictionary["anual_lerdo_mx"] as? String ?? "undefined"
                    self.anual_zaragoza_us = dictionary["anual_zaragoza_us"] as? String ?? "undefined"
                    self.anual_lerdo_us = dictionary["anual_lerdo_us"] as? String ?? "undefined"
                    self.anual_mixto_mx = dictionary["anual_mixto_mx"] as? String ?? "undefined"
                    self.anual_mixto_us = dictionary["anual_mixto_us"] as? String ?? "undefined"
                    self.saldo_zaragoza1_mx = dictionary["saldo_zaragoza1_mx"] as? String ?? "undefined"
                    self.saldo_zaragoza2_mx = dictionary["saldo_zaragoza2_mx"] as? String ?? "undefined"
                    self.saldo_zaragoza1_us = dictionary["saldo_zaragoza1_us"] as? String ?? "undefined"
                    self.saldo_zaragoza2_us = dictionary["saldo_zaragoza2_us"] as? String ?? "undefined"
                    self.pago_minimotp_mx = dictionary["pago_minimotp_mx"] as? String ?? "undefined"
                    
                }
                
            } else {
                print("Error: Could not convert JSON string to")
            }
            
            
            
        }

         task.resume()

         // This line will wait until the semaphore has been signaled
         // which will be once the data task has completed
         sem.wait()
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

