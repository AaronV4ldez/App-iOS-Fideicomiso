//
//  CrucesViewController.swift
//  LineaExpres
//

import UIKit

class CrucesViewController: UIViewController {
    
    
    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    
    var tag: String = ""
    var ctl_user_id: String = ""
    var ctl_id: String = ""
    var anio: String = ""
    var marca: String = ""
    var modelo: String = ""
    
    
    var counter = 0

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var StackContainer: UIStackView!
    
    
    override func viewDidLoad() { super.viewDidLoad()
        
        
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        
        mainStackView.layoutMargins = UIEdgeInsets(top: 80, left: 15, bottom: 40, right: 15)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        titleLabel.layer.cornerRadius = 8
        titleLabel.layer.masksToBounds = true
        StackContainer.spacing = 5
        StackContainer.axis = .vertical
        StackContainer.distribution = .fill
        StackContainer.layoutMargins = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        StackContainer.isLayoutMarginsRelativeArrangement = true
       
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("CrucesInfo"), object: nil)
       
    }
    

    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String
        
        let sel = text.components(separatedBy: ",")
        
        print("Este es el select \(sel)")
        tag = sel[0];
        ctl_user_id = sel[1];
        ctl_id = sel[2];
        anio = sel[3] ?? "";
        marca = sel[4];
        modelo = sel[5];
        
        requestCrossings(tag: tag) { jsonArray in
        
        //requestCrossings(ctl_user_id: ctl_user_id, ctl_id: ctl_id) { jsonArray in
                
            if (jsonArray.count != 0) {
                DispatchQueue.main.async {
                    for i in 0..<jsonArray.count{
                        
                        
                        let crossing_date: String? = jsonArray[i]["fechaHoraCruce"] as? String ?? "undefined"
                        let previous_crossings: Int? = jsonArray[i]["numeroCarril"] as? Int ?? -0
                        let current_crossings: Int? = jsonArray[i]["montoTarifa"] as? Int ?? -0
                        let puenteTipo: String? = jsonArray[i]["numeroCarril"] as? String ?? "undefined"
                        var	 puenteTipo2: String = ""
                        
                        /*let crossing_date: String? = jsonArray[i]["crossing_date"] as? String ?? "undefined"
                        let previous_crossings: Int? = jsonArray[i]["previous_crossings"] as? Int ?? -1
                        let current_crossings: Int? = jsonArray[i]["current_crossings"] as? Int ?? -1*/
                        
                        let dateSplitted = crossing_date!.components(separatedBy: "T")
                        let Date = dateSplitted[0]
                        let Hour = dateSplitted[1]
                        
                        var prev_balance = ""
                        var after_balance = ""
                        
                        print("Este valor raw \(previous_crossings)")
                        
                        if puenteTipo!.hasPrefix("10") {
                            puenteTipo2 = "Paso del Norte"
                            print("valor del if 1 1 \(puenteTipo)")
                            print("valor del if 2 1 \(puenteTipo2)")
                        } else if puenteTipo!.hasPrefix("20") {
                            puenteTipo2 = "Lerdo"
                            print("valor del if 1 2 \(puenteTipo)")
                            print("valor del if 2 2 \(puenteTipo2)")
                        } else if puenteTipo!.hasPrefix("30") {
                            puenteTipo2 = "Zaragoza"
                            print("valor del if 1 3 \(puenteTipo)")
                            print("valor del if 2 3 \(puenteTipo2)")
                        } else if puenteTipo!.hasPrefix("40") {
                            puenteTipo2 = "Guadalupe"
                            print("valor del if 1 4 \(puenteTipo)")
                            print("valor del if 2 4 \(puenteTipo2)")
                        } else {
                            puenteTipo2 = "Desconocido" // Valor por defecto en caso de que ningún prefijo coincida
                        }
                        
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .decimal
                        numberFormatter.groupingSeparator = ","
                        numberFormatter.decimalSeparator = "."
                        numberFormatter.minimumFractionDigits = 2
                        numberFormatter.maximumFractionDigits = 2
                        let aCrossing:String = String(previous_crossings!)
                        let bCrossing:String = String(current_crossings!)
                        
                       /* if let prev_balance_number = Double(aCrossing) {
                            let formatted_prev_balance = numberFormatter.string(from: NSNumber(value: prev_balance_number)) ?? ""
                            prev_balance = formatted_prev_balance
                        }
                        if let after_balance_number = Double(bCrossing) {
                            let formatted_after_balance = numberFormatter.string(from: NSNumber(value: after_balance_number)) ?? ""
                            after_balance = formatted_after_balance
                        }
                        
                        print("Este valor quemado \(after_balance)")*/
                        

                        
                        let CrossingContainer: UIStackView = UIStackView()
                        CrossingContainer.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
                        CrossingContainer.isLayoutMarginsRelativeArrangement = true
                        CrossingContainer.layer.cornerRadius = 8
                        CrossingContainer.layer.masksToBounds = true
                        CrossingContainer.backgroundColor = .white
                        CrossingContainer.axis = .vertical
                        
                        
                        
                        let dateHourStack: UIStackView = UIStackView()
                        dateHourStack.distribution = .fill
                        dateHourStack.axis = .horizontal
                        
                        let dateLabel:UILabel = UILabel()
                        let hourLabel:UILabel = UILabel()
                        let titleLabel:UILabel = UILabel()
                        let beforeLabel:UILabel = UILabel()
                        let afterLabel:UILabel = UILabel()
                        let tipoPuente:UILabel = UILabel()
                        
                        dateLabel.textColor = .black
                        hourLabel.textColor = .black
                        titleLabel.textColor = .black
                        beforeLabel.textColor = .black
                        afterLabel.textColor = .black
                        tipoPuente.textColor = .black
                        
                        dateLabel.font = UIFont(name:"AvenirNext-Bold", size: 14.0)
                        hourLabel.font = UIFont(name:"AvenirNext-Bold", size: 14.0)
                        titleLabel.font = UIFont(name:"AvenirNext-Bold", size: 14.0)
                        
                        beforeLabel.font = UIFont(name:"AvenirNext-Regular", size: 14.0)
                        afterLabel.font = UIFont(name:"AvenirNext-Regular", size: 14.0)
                        tipoPuente.font = UIFont(name:"AvenirNext-Regular", size: 14.0)
                        
                        
                        dateLabel.text = Date
                        dateLabel.textAlignment = .left
                        hourLabel.text = Hour
                        hourLabel.textAlignment = .right
                        
                        dateHourStack.addArrangedSubview(dateLabel)
                        dateHourStack.addArrangedSubview(hourLabel)
                        
                        titleLabel.text = "\(self.marca) \(self.modelo) \(self.anio)"
                        titleLabel.textAlignment = .center
                        
                        beforeLabel.text = "Numero de Carril: \(previous_crossings!)"
                        afterLabel.text = "Monto de Tarifa: $\(current_crossings!) MXN"
                        tipoPuente.text = "Puente: \(puenteTipo2)"
                        
                        //beforeLabel.text = "Saldo antes del cruce: $\(prev_balance)"
                        //afterLabel.text = "Saldo después del cruce: $\(after_balance)"
                        
                        CrossingContainer.addArrangedSubview(dateHourStack)
                        CrossingContainer.addArrangedSubview(titleLabel)
                        CrossingContainer.addArrangedSubview(beforeLabel)
                        CrossingContainer.addArrangedSubview(afterLabel)
                        CrossingContainer.addArrangedSubview(tipoPuente)
                        
                        CrossingContainer.setNeedsLayout()
                        CrossingContainer.layoutIfNeeded()
                        let visibleSubviewsCrossing = CrossingContainer.arrangedSubviews.filter { !$0.isHidden }
                        let totalHeightCrossing = visibleSubviewsCrossing.reduce(0) { $0 + $1.frame.size.height }
                        CrossingContainer.frame.size.height = totalHeightCrossing
                        CrossingContainer.sizeToFit()
                        
                        self.StackContainer.addArrangedSubview(CrossingContainer)
                        self.StackContainer.setNeedsLayout()
                        self.StackContainer.layoutIfNeeded()
                        let visibleSubviews = self.StackContainer.arrangedSubviews.filter { !$0.isHidden }
                        let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
                        self.StackContainer.frame.size.height = totalHeight
                        self.StackContainer.sizeToFit()
                        
                    }
                }
            }else {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "showVehiclesViewController")
                }
            }
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("CrucesInfo"), object: nil)
        
        
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
    
    
    func requestCrossings(tag: String, completion: @escaping ([[String: Any]]) -> Void) {
        
    //func requestCrossings(ctl_user_id: String, ctl_id: String, completion: @escaping ([[String: Any]]) -> Void) {
        
        // create post request
        let session = URLSession.shared
        var jsonArray = [[String: Any]]()

        //var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/le/crossings/\(ctl_user_id)/\(ctl_id)")!)
        //var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx//api/v1/le/crossings/\(ctl_user_id)/\(ctl_id)")!)
        //var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx//api/v1/le/crossingsnew/FPFC20002170")!)
        var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx/api/v1/le/crossingsnew/\(tag)")!)
        
        print("URL Completa:  \(request)")
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error -> \(error)")
                completion([])
                return
            }
            if let data = data {
                do {
                    jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
                    print("Json Raw = \(jsonArray) además \(jsonArray.count)" )
                } catch {
                    print("Error: Could not convert JSON string to array")
                }
            }
            completion(jsonArray)
        }
        task.resume()
    }

}
