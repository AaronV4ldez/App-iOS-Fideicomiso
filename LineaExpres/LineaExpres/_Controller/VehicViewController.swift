//
//  VehicleViewController.swift
//  LineaExpres
//
//  Created by Victor Lazaro on 21/12/22.
//

import UIKit

class VehicleViewController: UIViewController {
    
    @IBOutlet weak var VerticalStackViewContainer: UIStackView!
    @IBOutlet weak var LineaExpresContainer: UIStackView!
    @IBOutlet weak var TelepeajeContainer: UIStackView!
    
    @IBOutlet weak var HeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var TelepeajeHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var LineaExpresHeightConstant: NSLayoutConstraint!
    
    
    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Ajustar padding a StackView
        VerticalStackViewContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        VerticalStackViewContainer.isLayoutMarginsRelativeArrangement = true
        
        VerticalStackViewContainer.layer.cornerRadius = 20
        VerticalStackViewContainer.layer.masksToBounds = true
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        
        let aContainer:UIButton = UIButton()
        
        aContainer.layer.cornerRadius = 20
        aContainer.layer.masksToBounds = true
        aContainer.backgroundColor = .black
        aContainer.setTitle("hoala", for: .normal)
    
        
        LineaExpresContainer.addArrangedSubview(aContainer)
        
        //requestVehicles()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(loadViews(_:)), name: Notification.Name("TipoEx"), object: nil)
        
    }
    
    @objc func loadViews(_ notification: Notification) {
        let text:String = notification.object as! String
        let Usuario = text.components(separatedBy: "∑")
        
        let TipoEx:String = Usuario[0]
        let Marca:String = Usuario[1]
        let Año:String = Usuario[2]
        let Placas:String = Usuario[3]
        
        var tamañoTwo = 0
        var tamaño = 0
        DispatchQueue.main.async {
            if TipoEx.contains("0") {
                tamaño = tamaño+305
                
                print("Entrando aqui")
                let BrandLbl:UILabel = UILabel()
                let YearLbl:UILabel = UILabel()
                let PlateLbl:UILabel = UILabel()
                let BalanceLbl:UILabel = UILabel()
                BrandLbl.text = Marca
                YearLbl.text = Año
                PlateLbl.text = Placas
                BalanceLbl.text = "2000"
                
                BrandLbl.textColor = .black
                YearLbl.textColor = .black
                PlateLbl.textColor = .black
                BalanceLbl.textColor = .black
                
                let a:UIStackView = UIStackView()
                a.axis = .vertical
                a.distribution = .fillEqually
                a.backgroundColor = .blue
                a.layer.cornerRadius = 20
                a.layer.masksToBounds = true
                
                a.addArrangedSubview(BrandLbl)
                a.addArrangedSubview(YearLbl)
                a.addArrangedSubview(PlateLbl)
                a.addArrangedSubview(BalanceLbl)
                
                let aContainer:UIButton = UIButton()
                aContainer.backgroundColor = .black
                aContainer.layer.cornerRadius = 20
                aContainer.frame.size.height = 40
                aContainer.layer.masksToBounds = true
                
                
                self.LineaExpresContainer.addArrangedSubview(aContainer)
            }
            
            if TipoEx.contains("1") {
                
                tamañoTwo = tamañoTwo+305
                
                let aContainer:UIButton = UIButton()
                aContainer.backgroundColor = .white
                aContainer.layer.cornerRadius = 20
                aContainer.layer.masksToBounds = true
                
                self.LineaExpresContainer.addArrangedSubview(aContainer)
            }
            self.LineaExpresHeightConstant.constant = CGFloat(tamañoTwo)
            self.TelepeajeHeightConstant.constant = CGFloat(tamaño)
            self.HeightConstant.constant = CGFloat(tamaño + tamañoTwo + 200)
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
    
    
    func requestVehicles() {
        // create post request
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/vehicles")!
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
                         
                         print(jsonArray)
                
                         for i in 0...jsonArray.count - 1 {
                             let TipoEx: Int? = jsonArray[i]["tipo"] as? Int
                             let Marca: String? = jsonArray[i]["marca"] as? String
                             let Año: String? = jsonArray[i]["modelo"] as? String
                             let Placas: String? = jsonArray[i]["placa"] as? String
                             //let Saldo: String? = jsonArray[i]["tipo"] as? Int
                             NotificationCenter.default.post(name: Notification.Name("TipoEx"), object: "\(TipoEx!) ∑ \(Marca!) ∑ \(Año!) ∑ \(Placas!)")
                             
                         }
                         
                     } else {
                         print("Error: Could not convert JSON string to")
                     }
                 }
                 
            }
        }
          task.resume()
    }

 

}
