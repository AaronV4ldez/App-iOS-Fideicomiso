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
        
        let url = URL(string: "https://noticias.fpfch.gob.mx/wp-content/uploads/2022/07/Cabezal714x119_Color.png")
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
        guard let url = URL(string: "https://noticias.fpfch.gob.mx/wp-json/wp/v2/posts?per_page=10&categories=18&_embed") else {
            print("Error: URL is not valid")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                return
            }
            
            do {
                let json = try JSON(data: data)
                
                for index in 0..<json.count {
                    let NotaID = json[index]["id"].intValue
                    let Title = json[index]["title"]["rendered"].stringValue
                    let Body = json[index]["content"]["rendered"].stringValue
                    let imageUrl = json[index]["_embedded"]["wp:featuredmedia"][0]["source_url"].stringValue
                    
                    // Perform database operations asynchronously on the main queue
                    DispatchQueue.main.async {
                        self.db.DeleteAllFromNotasTable()
                        self.db.InsertNotas(NotaID: NotaID, NotaTitle: Title, NotaBody: Body, NotaImageURL: imageUrl)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
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
        let id:String = data[14]
        let loginToken:String = data[15]
        tipoLinea = Int(data[16])!
        
        
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
        
        let Idtxt:UILabel = UILabel()
        Idtxt.text = "Tag: \(id)"
        
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
        Idtxt.font = UIFont(name:"merriweather-regular", size: 15.0)
        tipoContrato.font = UIFont(name:"merriweather-regular", size: 15.0)
        
        
        Titulo.textColor = .black
        Placa.textColor = .gray
        Tag.textColor = .black
        Idtxt.textColor = .black
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
        arr.append("Eliminar Tag") // 2
        
        for i in 0..<(arr.count) {
            let tipoTramite:UIButton = UIButton(type: .roundedRect)
            tipoTramite.setTitle(arr[i], for: .normal)
            print("Este es el valor del botón: \(i)")
            
            
            tipoTramite.setTitleColor(.black, for: .normal)
            tipoTramite.layer.masksToBounds = true
            
            //qtue == Tipo de vehiculo; 0 = Telepeaje, 1 = Linea Expres, 2 = Acceso Digital P.
            
            if qtue.contains("0") {
                if i == 1 {
                    tipoTramite.isHidden = true
                }
                if i == 0 {
                    tipoTramite.accessibilityLabel = "\(TagVeh), '0', '0', \(tipoLinea) "
                    tipoTramite.addTarget(self, action: #selector(didBtnRecharge(_ :)), for: .touchUpInside)
                }
                if i == 2 {
                    tipoTramite.accessibilityLabel = "\(id)"
                    tipoTramite.addTarget(self, action: #selector(didBtnEliminartag(_ :)), for: .touchUpInside)
                }
                
                
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
                
                if i == 2{
                    tipoTramite.isHidden = true
                }
            }
            if qtue.contains("2") {
                if i == 1 {
                    tipoTramite.isHidden = true
                }
                if i == 0 {
                    tipoTramite.accessibilityLabel = "\(TagVeh), '0', '0', \(tipoLinea)"
                    tipoTramite.addTarget(self, action: #selector(didBtnRecharge(_ :)), for: .touchUpInside)
                }
                
                if i == 2{
                    tipoTramite.accessibilityLabel = "\(id)"
                    tipoTramite.addTarget(self, action: #selector(didBtnEliminartag(_ :)), for: .touchUpInside)
                }
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
        print("Hola soy el boton ekisde")
    }
    
    
    @objc func didBtnEliminartag(_ sender: UIButton){
        
        let id = sender.accessibilityLabel ?? ""
        print("Botón eliminar y el id seleccionado es: \(id)")
        
        let label = UILabel()
        label.font = UIFont(name:"AvenirNext-Bold", size: 22.0)
        label.text = "¿Estás seguro?"
        label.textAlignment = .center
        label.textColor = .black
        
        let cuerpoh = UILabel()
        cuerpoh.font = UIFont(name:"AvenirNext", size: 18.0)
        cuerpoh.numberOfLines = 0
        cuerpoh.sizeToFit()
        cuerpoh.text = "Estás a punto de borrar tu TAG, ésta acción no se puede deshacer."
        cuerpoh.textAlignment = .center
        cuerpoh.textColor = .black
        
        let acceptButton = UIButton(type: .system)
        acceptButton.setTitle("Aceptar", for: .normal)
        acceptButton.titleLabel?.font = UIFont(name:"AvenirNext-Bold", size: 16.0)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        acceptButton.backgroundColor = .gray // Color de fondo verde
        acceptButton.setTitleColor(.white, for: .normal) // Color del texto blanco
        acceptButton.layer.cornerRadius = 12 // Borde redondeado
        acceptButton.accessibilityLabel = "\(id)"
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancelar", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name:"AvenirNext-Bold", size: 16.0)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.backgroundColor = .gray // Color de fondo rojo
        cancelButton.setTitleColor(.white, for: .normal) // Color del texto blanco
        cancelButton.layer.cornerRadius = 12 // Borde redondeado
        
        // Creamos un stack view horizontal para los botones
        let buttonStackView = UIStackView(arrangedSubviews: [acceptButton, cancelButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        
        // Creamos un stack view vertical para el contenido completo del modal
        let stackView = UIStackView(arrangedSubviews: [label, cuerpoh, buttonStackView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        // Presenta el modal desde el controlador de vista actual
        if let viewController = UIApplication.shared.windows.first?.rootViewController {
            let modalViewController = UIViewController()
            modalViewController.view.addSubview(stackView)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            // Establece el fondo blanco para el modal
            modalViewController.view.backgroundColor = .white
            
            viewController.present(modalViewController, animated: true, completion: nil)
            
            // Configura las restricciones del stack view
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: modalViewController.view.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: modalViewController.view.centerYAnchor),
                stackView.leadingAnchor.constraint(equalTo: modalViewController.view.leadingAnchor, constant: 40),
                stackView.trailingAnchor.constraint(equalTo: modalViewController.view.trailingAnchor, constant: -40)
            ])
        }
    }// didbtn eliminar tag
    
    func verifyTag(tag: String, loginToken: String, completion: @escaping (Result<Int, Error>) -> Void) {
        var json: [String: Any] = [:]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var res = 0
        
        let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/tags/exists/(tag)")!
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
    
    @objc func acceptButtonTapped(_ sender: UIButton) {

        print("Aceptar")
        
        // Desempaquetar opcionalmente sender.accessibilityLabel
         let id = sender.accessibilityLabel ?? ""
            print("Error: No se pudo obtener el ID.")
  
        
        // Imprime el ID desempaquetado
        print("Aceptar con ID: \(id)")
        
        // Llama a la función postDeleteTag con el ID desempaquetado
        postDeleteTag(id: id)
        if let presentingViewController = UIApplication.shared.windows.first?.rootViewController {
            // Cierra el modal
            presentingViewController.dismiss(animated: true, completion: nil)
        } else {
            // Si no se puede encontrar el controlador de vista que presentó el modal, imprime un mensaje de error
            print("Error: No se puede encontrar el controlador de vista que presentó el modal.")
        }
    }//acpcept button
    
    
    @objc func cancelButtonTapped(){
        print("Cancelar")
        // Obtén una referencia al controlador de vista que presentó el modal
        if let presentingViewController = UIApplication.shared.windows.first?.rootViewController {
            // Cierra el modal
            presentingViewController.dismiss(animated: true, completion: nil)
        } else {
            // Si no se puede encontrar el controlador de vista que presentó el modal, imprime un mensaje de error
            print("Error: No se puede encontrar el controlador de vista que presentó el modal.")
        }
    }//cancel button
    
    var LoginToken:String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjg2OSwibmFtZSI6IkFhclx1MDBmM24gVmFsZGV6IEdhcmNpYSIsImV4cCI6MTcwNDMwNjI4Mn0.0fgYcdqr0cVl3MChdQIrkk1P3jw37hTp61EqYB2n2NQ"
        
    func postDeleteTag(id: String){
        
        print("el id mandado a la api es \(id)")
        let session = URLSession.shared
         let sem = DispatchSemaphore.init(value: 0)
         var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx/api/v1/vehicles/\(id)")!)
         request.httpMethod = "DELETE"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")

           let task = session.dataTask(with: request) { data, response, error in
               defer { sem.signal() }

               if let error = error {
                   print("Error -> \(error)")
                   return
               }

               if let data = data, let string = String(data: data, encoding: .utf8) {
                   
                   if let data = string.data(using: .utf8) {
                       let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                       if let responseJSON = responseJSON as? [String: Any] {
                           print(responseJSON)
                           
                           let message:String? = responseJSON["message"] as? String
                           if message != nil {
                               if (message!.contains("Vehículo eliminado") || message!.contains("La petición la realizó un usuario no válido.")) {
                                   DispatchQueue.main.async {
                                       NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ProfileViewController")
                                   }
                                   
                               }
                               DispatchQueue.main.async {
                                   //self.showAlert(title: "Línea Exprés", message: message!)
                               }

                               
                           }
                       } else {
                           print("Error: Could not convert JSON string to")
                       }
                   }
                   
               }
           }

         task.resume()

         // This line will wait until the semaphore has been signaled
         // which will be once the data task has completed
         sem.wait()
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
