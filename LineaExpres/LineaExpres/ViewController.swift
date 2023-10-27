//
//  ViewController.swift
//  LineaExpres
//

import UIKit
import SwiftUI
import SwiftyJSON

class ViewController: UIViewController {

    let db = DB_Manager()
    @IBOutlet weak var HamburgerBackground: UIView!
    @IBOutlet weak var HamburgerView: UIView!
    @IBOutlet weak var HamburgerViewConstant: NSLayoutConstraint!
    @IBOutlet weak var HamburgerViewConstantRight: NSLayoutConstraint!
    @IBOutlet weak var MenuBtn: UIButton!
    @IBOutlet weak var HomeBtn: UIButton! 
    @IBOutlet weak var Header: UIImageView!
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var ColorHeader: UIView!
    @IBOutlet weak var ColorHeaderHeight: NSLayoutConstraint!
    
    var actualPage:String = "HomeViewController"
    var lastScene:String = "HomeViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("viewChanger"), object: nil)
        
        for subview in view.subviews {
                    // Comprobar si la vista es un campo de texto
                    if let textField = subview as? UITextField {
                        // Aplicar el estilo de campo de texto a la vista
                        textField.applyTextFieldStyle()
                    }
                }
        
        headerStackView.layoutMargins = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        headerStackView.isLayoutMarginsRelativeArrangement = true
        
        HamburgerBackground.isHidden = true
        HamburgerBackground.backgroundColor = UIColor(red: 18/255.0, green: 18/255.0, blue: 18/255.0, alpha: 0)
        
        
        HamburgerViewConstant.constant = -HamburgerView.frame.width
        HamburgerViewConstantRight.constant = HamburgerView.frame.width + 75
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(logout(_:)), name: Notification.Name("LogoutFunc"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeMenu(_:)), name: Notification.Name("closeMenu"), object: nil)
        
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
         view.addGestureRecognizer(tapGesture)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.HamburgerBackground.addGestureRecognizer(gesture)
        
       NotificationCenter.default.addObserver(self, selector: #selector(onResume), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }

    @objc func didGetNotification(_ notification: Notification) {

        let text = notification.object as! String
        lastScene = actualPage
        actualPage = text
        
        
        //print("Se repite más de una vez?lastScene : \(lastScene)")
        //print("Se repite más de una vez? : \(actualPage)")
        
        if text.contains("HomeViewController") {
            self.MenuBtn.setImage(UIImage(named: "menu_icon"), for: .normal)
            MenuBtn.tag = 0
        } else {
            // Resto del código
        }
    

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        ColorHeaderHeight.constant = statusBarHeight
        
        let url = URL(string: "https://lineaexpress.desarrollosenlanube.net/wp-content/uploads/2022/07/Cabezal714x119_Color.png")
        DispatchQueue.background(background: {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async() {
                self.Header.image = UIImage(data: data!)

                
                self.headerStackView.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
                self.headerStackView.isLayoutMarginsRelativeArrangement = true
            }
           
        }, completion:{
            print("Imagen 4 cargada correcamente")
        })
    }
    
    func reloadData() {
        guard let url = URL(string: "https://lineaexpress.desarrollosenlanube.net/wp-json/wp/v2/posts?per_page=10&categories=18&_embed") else {
            print("Error: \(String(describing: link)) doesn't seem to be a valid URL")
            return
        }
        
        do {
            let content = try String(contentsOf: url, encoding: .ascii)
            let json = JSON.init(parseJSON: content)
            
            for index in 0..<(json.count) {
                
                let NotaID:Int = json[index]["id"].intValue
                let Title:String = json[index]["title"]["rendered"].stringValue
                let Body:String = json[index]["content"]["rendered"].stringValue
                let imageUrl:String = json[index]["_embedded"]["wp:featuredmedia"][0]["source_url"].stringValue
                db.DeleteAllFromNotasTable()
                db.InsertNotas(NotaID: NotaID, NotaTitle: Title, NotaBody: Body, NotaImageURL: imageUrl)
                
            }
        } catch let error {
            print("Error: \(error)")
        }
    }
    
    @objc func onResume() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.reloadData()
            
        }
        
    }
    
    @objc func closeMenu(_ notification: Notification) {
        if HamburgerBackground.isHidden == false {
                
                DispatchQueue.background(background: {
                    for i in stride(from: 100, through: 0, by: -1) {
                        DispatchQueue.main.async() {
                            self.HamburgerBackground.backgroundColor = UIColor(red: 18/255.0, green: 18/255.0, blue: 18/255.0, alpha: CGFloat(i))
                        }
                    }
                }, completion:{
                    print("it's open")
                })
                
                HamburgerViewConstant.constant = -HamburgerView.frame.width
                HamburgerViewConstantRight.constant = HamburgerView.frame.width + 75
                

            self.HamburgerBackground.isHidden = true
        }
    }
    
    @objc func logout(_ notification: Notification) {
        if HamburgerBackground.isHidden == false {
                
                DispatchQueue.background(background: {
                    for i in stride(from: 100, through: 0, by: -1) {
                        DispatchQueue.main.async() {
                            self.HamburgerBackground.backgroundColor = UIColor(red: 18/255.0, green: 18/255.0, blue: 18/255.0, alpha: CGFloat(i))
                        }
                    }
                }, completion:{
                    print("it's open")
                })
                
                HamburgerViewConstant.constant = -HamburgerView.frame.width
                HamburgerViewConstantRight.constant = HamburgerView.frame.width + 75
                

            self.HamburgerBackground.isHidden = true
        }
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        if HamburgerBackground.isHidden == false {
            DispatchQueue.background(background: {
                
                for i in stride(from: 10000, through: 0, by: -1) {
                    DispatchQueue.main.async() {
                        self.HamburgerBackground.backgroundColor = UIColor(red: 18/255.0, green: 18/255.0, blue: 18/255.0, alpha: CGFloat(Double(i)/10000.0))
                    }
                }

            }, completion:{
                print("it's closing")
            })
            
            self.HamburgerViewConstant.constant = -self.HamburgerView.frame.width
            self.HamburgerViewConstantRight.constant = self.HamburgerView.frame.width + 75
            self.HamburgerBackground.isHidden = true
          
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
               
            })
        }
    }
    
    @IBAction func openMenu(_ sender: Any) {
       
            if HamburgerBackground.isHidden {
                self.HamburgerBackground.isHidden = false
                DispatchQueue.background(background: {
                    for i in 1...2500 {
                        DispatchQueue.main.async() {
                            self.HamburgerBackground.backgroundColor = UIColor(red: 18/255.0, green: 18/255.0, blue: 18/255.0, alpha: CGFloat( Double(i)/10000.0 ))
                        }
                    }
                }, completion:{
                    print("it's open")
                })
                self.HamburgerViewConstant.constant = 0
                self.HamburgerViewConstantRight.constant = 75
                
                UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        
    }
  
}

class bottomBarViewController: UIViewController {
    
    @IBOutlet weak var HomeBtn: UIButton!
    @IBOutlet weak var ProfileBtn: UIButton!
    @IBOutlet weak var RechargeBtn: UIButton!
    @IBOutlet weak var CallUsBtn: UIButton!
    @IBOutlet weak var TramitesBtn: UIButton!
    @IBOutlet weak var radiusBorder: UIView!
    
    
    
    var actualPage:String = "HomeViewController"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        //radiusBorder.layer.cornerRadius = radiusBorder.frame.size.width/2
        //let maskLayer = CAShapeLayer()
        //    maskLayer.path = UIBezierPath(ovalIn: self.radiusBorder.bounds).cgPath;
        //    self.radiusBorder.layer.mask = maskLayer
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("viewChanger"), object: nil)
        

    }
    
    
    
    @IBAction func HomeBtnClick(_ sender: Any) {
        if actualPage == "HomeViewController" {
            return
        }else {
            
            print("Continuamos con el view change")
            actualPage = "HomeViewController"
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "HomeViewController")
            
        }
    }
    
    @IBAction func ProfileBtnClick(_ sender: Any) {
        if actualPage == "ProfileViewController" {
            return
        }else {
            actualPage = "ProfileViewController"
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ProfileViewController")
        }
    }
    
    @IBAction func RechargeBtnClick(_ sender: Any) {
        if actualPage == "showVehiclesViewController" {
            return
        }else {
            actualPage = "showVehiclesViewController"
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "showVehiclesViewController")
        }
        
        
    }
    
    @IBAction func CallUsBtnClick(_ sender: Any) {
        
        guard let number = URL(string: "tel://" + "6566821003") else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func TramitesBtnClick(_ sender: Any) {
        //if actualPage == "TramitesViewController" {
        //    return
        //}else {
        //    actualPage = "TramitesViewController"
        //    NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: //"TramitesViewController")
        //}
        
        if actualPage == "VehiculosViewController" {
            return
        }else {
            actualPage = "VehiculosViewController"
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "VehiculosViewController")
        }
        
        
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String
        actualPage = text
    }
}


class successfullyViewController: UIViewController {
    var msg:String = ""
    @IBOutlet var Background: UIView!
    @IBOutlet weak var MsgLbl: UILabel!
    ///var workItem: DispatchWorkItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetMsg(_:)), name: Notification.Name("FinishMSG"), object: nil)
        
        //Trabajaremos el timer después con más tiempo
        ///workItem = DispatchWorkItem {
        ///    NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ProfileViewController")
        ///}
        ///DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: workItem)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Funciona el DidDisappear?")
        ///workItem.cancel()
    }
    
    
    
    @IBAction func AceptarClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ProfileViewController")
    }
    
    @objc func didGetMsg(_ notification: Notification) {
        let text:String = notification.object as! String
        msg = text
        
        MsgLbl.text = text
        
        if text.contains("Cuenta ya ha sido previamente verificada.") {
            self.Background.backgroundColor = UIColor(named: "cautionColor")
        }
        if text.contains("Cuenta verificada exitosamente.") {
            MsgLbl.text = "\(text) Revisa tu correo y continua con el registro."
        }
        
    }
    
    
}


public class vistaVehRecargar {
    var tipoLinea: Int = 0
    public func generarVistaVehiculos(conDatos data: [String]) -> UIStackView {
        
        let heig:Int = Int(data[0])!
        let imgurl:String = data[1]
        let MarcaVeh:String = data[2]
        let Linea:String = data[3]
        let PlacasVeh:String = data[4]
        let TagVeh:String = data[5]
        let ctl_contract_type:String = data[6]
        let SaldoVeh:String = data[7]
        let clt_expiration_date:String = data[8]
        let ctl_stall_id:String = data[9]
        let qtue:String = data[10]
        let ctl_user_id:String = data[11]
        let ctl_id:String = data[12]
        let anio:String = data[13]
        let loginToken:String = data[14]
        tipoLinea = Int(data[15])!
        
        
       
        var Top:UIStackView = UIStackView()
        var Bottom:UIStackView = UIStackView()
        var BottomTop:UIStackView = UIStackView()
        var BottomBottom:UIStackView = UIStackView()
        var Spacer:UIView = UIView()
        
        let a:UIStackView = UIStackView()
        a.axis = .vertical
        a.distribution = .fillEqually
        a.backgroundColor = .white
        a.layer.cornerRadius = 20
        a.spacing = 5
        a.layer.masksToBounds = true
        a.heightAnchor.constraint(equalToConstant: CGFloat(heig)).isActive = true
        
        Top = UIStackView()
        Top.axis = .vertical
        Top.distribution = .fill
        Top.layer.cornerRadius = 20
        Top.spacing = 5
        Top.backgroundColor = .gray
        Top.layer.masksToBounds = true
        Top.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        
        Bottom = UIStackView()
        Bottom.axis = .vertical
        Bottom.distribution = .fill
        Bottom.spacing = 5
        Bottom.backgroundColor = .white
        Bottom.layer.masksToBounds = true
        
        let imageCar:UIImageView = UIImageView()
        imageCar.layer.masksToBounds = true
        imageCar.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        if qtue.contains("2") {
            DispatchQueue.main.async() {
                imageCar.image = UIImage(named: "ADP")
            }
        }else {
            let url = URL(string: imgurl)
            DispatchQueue.background(background: {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async() {
                    imageCar.image = UIImage(data: data!)
                }
            }, completion:{
                print("ImgCharged")
            })
        }
        
       
        
        let Titulo:UILabel = UILabel()
        Titulo.text = "\(MarcaVeh) \(Linea)"
        
        let Placa:UILabel = UILabel()
        Placa.text = "\(PlacasVeh)"
        
        let Tag:UILabel = UILabel()
        Tag.text = "Tag: \(TagVeh)"
        
        let tipoContrato:UILabel = UILabel()
        
        if (ctl_contract_type == "V" || ctl_contract_type == "M") {
            tipoContrato.text = "Contrato vence: \(clt_expiration_date)"
        }else {
            verifyTag(tag: TagVeh, loginToken: loginToken) { result in
                switch result {
                case .success(let saldo):
                    // Procesar la respuesta exitosa
                    
                    DispatchQueue.main.async {
                        if saldo == 0 {
                            tipoContrato.text = "Saldo: $\(SaldoVeh)"
                        }else {
                            tipoContrato.text = "Saldo: $\(saldo)"
                        }
                        
                    }
                case .failure(let error):
                    // Procesar el error
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
            
        Titulo.font = UIFont(name:"AvenirNext-Bold", size: 18.0)
        Placa.font = UIFont(name:"AvenirNext-Bold", size: 14.0)
        Tag.font = UIFont(name:"merriweather-regular", size: 15.0)
        tipoContrato.font = UIFont(name:"merriweather-regular", size: 15.0)
        
  
        Titulo.textColor = .black
        Placa.textColor = .gray
        Tag.textColor = .black
        tipoContrato.textColor = .black
        
        
        Spacer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        Top.addArrangedSubview(imageCar)
        
        
        BottomTop = UIStackView()
        BottomTop.axis = .vertical
        BottomTop.distribution = .fillEqually
      
        BottomTop.layer.masksToBounds = true
        BottomTop.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        Spacer = UIStackView()
        BottomTop.addArrangedSubview(Spacer)
        BottomTop.addArrangedSubview(Titulo)
        BottomTop.addArrangedSubview(Placa)
        Spacer = UIStackView()
        BottomTop.addArrangedSubview(Spacer)
        BottomTop.addArrangedSubview(Tag)
        Spacer = UIStackView()
        BottomTop.addArrangedSubview(Spacer)
        BottomTop.addArrangedSubview(tipoContrato)

        
        BottomBottom = UIStackView()
        BottomBottom.axis = .vertical
        BottomBottom.distribution = .fill
        BottomBottom.layer.cornerRadius = 20
        BottomBottom.spacing = 5
        BottomBottom.layer.masksToBounds = true
        
       
        Bottom.addArrangedSubview(BottomTop)
        
        
        var arr:Array<String> = Array()
        arr.append("Recargar") // 0
        arr.append("Ver mis cruces") // 1
        
        for i in 0..<(arr.count) {
            let tipoTramite:UIButton = UIButton(type: .roundedRect)
            tipoTramite.setTitle(arr[i], for: .normal)
            
            
            tipoTramite.setTitleColor(.black, for: .normal)
            tipoTramite.layer.masksToBounds = true
            
            //qtue == Tipo de vehiculo; 0 = Telepeaje, 1 = Linea Expres, 2 = Acceso Digital P.
           
            if qtue.contains("0") {
                if i == 1 {
                    tipoTramite.isHidden = true
                }
                tipoTramite.accessibilityLabel = "\(TagVeh), '0', '0', \(tipoLinea) "
                tipoTramite.addTarget(self, action: #selector(didBtnRecharge(_ :)), for: .touchUpInside)

            }
            if qtue.contains("1") {
                if i == 0 {
                    //let fechaTe = "2023-08-11"
                    let fechaTe = clt_expiration_date
                    
                    if !clt_expiration_date.contains("undefined") {
                        if (ctl_contract_type == "V" || ctl_contract_type == "M") {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            if let expirationDate = dateFormatter.date(from: fechaTe) {
                                let currentDate = Date()
                                let calendar = Calendar.current
                                let daysRemaining = calendar.dateComponents([.day], from: currentDate, to: expirationDate).day ?? 0
                                
                                if daysRemaining >= 90 {
                                    print("Este contrato se puede renovar en \(daysRemaining - 90) días")
                                    if daysRemaining - 90 == 1 {
                                        tipoTramite.setTitle("Contrato renovable en \(daysRemaining - 90) día", for: .normal)
                                    }else if daysRemaining - 90 == 0 {
                                        
                                        tipoTramite.setTitle("Renovar", for: .normal)
                                        tipoTramite.accessibilityLabel = "\(TagVeh),\(ctl_stall_id),\(ctl_contract_type),\(tipoLinea)"
                                        tipoTramite.addTarget(self, action: #selector(didBtnRecharge(_ :)), for: .touchUpInside)
                                    }else {
                                        print("En días")
                                        tipoTramite.setTitle("Contrato renovable en \(daysRemaining - 90) días", for: .normal)
                                    }
                                    
                                }else {
                                    print("Ya puede renovar \(daysRemaining - 90)")
                                    tipoTramite.setTitle("Renovar", for: .normal)
                                    tipoTramite.accessibilityLabel = "\(TagVeh),\(ctl_stall_id),\(ctl_contract_type),\(tipoLinea)"
                                    tipoTramite.addTarget(self, action: #selector(didBtnRecharge(_ :)), for: .touchUpInside)
                                }
                            }
                        }
                    }else {
                        tipoTramite.setTitle("Recargar", for: .normal)
                        tipoTramite.accessibilityLabel = "\(TagVeh),\(ctl_stall_id),\(ctl_contract_type), \(tipoLinea)"
                        tipoTramite.addTarget(self, action: #selector(didBtnRecharge(_ :)), for: .touchUpInside)
                    }
                    
                    
                    
                    
                }else {
                    tipoTramite.accessibilityLabel = "\(TagVeh),\(ctl_user_id),\(ctl_id),\(anio),\(MarcaVeh),\(Linea)"
                    tipoTramite.addTarget(self, action: #selector(didBtnCruces(_ :)), for: .touchUpInside)
                }
            }
            if qtue.contains("2") {
                if i == 1 {
                    tipoTramite.isHidden = true
                }
                tipoTramite.accessibilityLabel = "\(TagVeh), '0', '0', \(tipoLinea)"
                tipoTramite.addTarget(self, action: #selector(didBtnRecharge(_ :)), for: .touchUpInside)
            }
            
            tipoTramite.backgroundColor = .black
            tipoTramite.setTitleColor(.white, for: .normal)
            tipoTramite.layer.masksToBounds = true
            tipoTramite.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            Bottom.addArrangedSubview(tipoTramite)
        }
        
        a.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        a.isLayoutMarginsRelativeArrangement = true
        
        a.addArrangedSubview(Top)
        a.addArrangedSubview(Bottom)
        
        return a
    }
    
    @objc func didBtnRecharge(_ sender: UIButton) {
        let tag:String? = sender.accessibilityLabel
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"EscogerCantidadViewController")
        NotificationCenter.default.post(name: Notification.Name("TagSelected"), object:tag!)
        
    }
    
    @objc func didBtnCruces(_ sender: UIButton) {
        let tag:String? = sender.accessibilityLabel
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"CrucesViewController")
        NotificationCenter.default.post(name: Notification.Name("CrucesInfo"), object:tag!)
    }
    
    func verifyTag(tag: String, loginToken: String, completion: @escaping (Result<Int, Error>) -> Void) {
        var json: [String: Any] = [:]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var res = 0
        
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/tags/exists/\(tag)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(loginToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("Este será el response de validacion de TAG ")
                print(responseJSON)
                if let message = responseJSON["message"] as? String, message == "Tag no encontrado." {
                    // Opción 1: El tag no se encontró en la base de datos
                    print("Opcion 1")
                    
                } else if let tag = responseJSON["tag"] as? String, let tp = responseJSON["tp"] {
                    if tp is String, tp as? String == "Not Found" {
                        // Opción 2: El tag se encontró en la base de datos, pero no hay información de controles
                        print("No se ha encontrado información en controles.")
                        
                        
                    } else if let tpDict = tp as? [String: Any], let saldo = tpDict["saldoActual"] as? Int {
                        // Opción 3: El tag se encontró en la base de datos y hay información de controles
                        let fechaRespuesta = tpDict["fechaRespuesta"] as? String ?? ""
                        let noTag = tpDict["noTag"] as? String ?? ""
                        print("Tag encontrado. Saldo actual: \(saldo), Fecha de respuesta: \(fechaRespuesta), Número de tag: \(noTag)")
                        res = saldo
                    }
                }
            }
            
            completion(.success(res))
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

}


extension UITextField {
    
    func applyTextFieldStyle() {
        // Aplicar un borde con esquinas redondeadas a cada campo de texto
        layer.borderWidth = 1.0
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.black.cgColor
    
    }
    
}

