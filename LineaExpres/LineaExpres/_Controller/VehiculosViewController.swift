//
//  VehiculosViewController.swift
//  LineaExpres
//

import UIKit
import iCarousel

class VehiculosViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    var carousel: iCarousel!
    var CantidadVeh:Int = 0
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var loaderGif: UIImageView!
    
    var Email:String = ""
    var Name:String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    
    let va: Array<String> = Array()
    let light_blueColor = UIColor(named: "light_blueColor")
    
    @IBOutlet weak var mainBtn: UIButton!
    
    @IBOutlet weak var mainContainer: UIStackView!
    
    @IBOutlet weak var StackH: UIStackView!
    var vehID: Int = 0
    
    var vehReceived: Array<String> = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!verifyLogging()) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
    
        //Ajustar padding a StackView
        mainContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        mainContainer.isLayoutMarginsRelativeArrangement = true
        mainContainer.layer.cornerRadius = 20
        mainContainer.layer.masksToBounds = true
        
        getVehicles()
        CantidadVeh = vehReceived.count
        
        
        
        if CantidadVeh > 0 {
            mainBtn.setTitle("Trámite para Agregar un Vehículo", for: .normal)
        }
        
        carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        carousel.type = .linear
        carousel.centerItemWhenSelected = true
        carousel.dataSource = self
        carousel.delegate = self
        StackH.addArrangedSubview(carousel)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderGif.image = UIImage.gif(asset: "linea_expres_loader")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loaderContainer.isHidden = true
        }
    }
    
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
          return CantidadVeh
      }
    
   // func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
   //     if carousel.currentItemIndex >= carousel.numberOfItems - 1 {
   //         carousel.scrollToItem(at: 0, animated: true)
   //     }
   // }
      
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = UIStackView(frame: CGRect(x: 0, y: 0, width: StackH.frame.width - 60, height: mainContainer.frame.height - 100))
        tempView.axis = .vertical
        tempView.distribution = .fill
        tempView.backgroundColor = .white
        
        
        var ScrollTramites:UIScrollView = UIScrollView()
        var Top:UIStackView = UIStackView()
        var Bottom:UIStackView = UIStackView()
        var BottomTop:UIStackView = UIStackView()
        var BottomBottom:UIStackView = UIStackView()
        var Spacer:UIView = UIView()
        
        if (vehReceived.count != 0) {
            for i in 0..<(vehReceived.count) {
                
                
                DispatchQueue.main.async {
                    self.mainBtn.accessibilityLabel = "0,1,0,0,0,0,0"
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
                    self.mainBtn.addGestureRecognizer(tapGesture)
                }
             
                
                let Vehiculos = vehReceived[index].components(separatedBy: "∑")
                
                print("Json Clean \(Vehiculos)")
                
                //let tipoVeh:Int = Int(Vehiculos[0])!
                let Marca:String = Vehiculos[1]
                let Linea:String = Vehiculos[2]
                let tag:String = Vehiculos[3]
                let imgurl:String = Vehiculos[4]
                let ctl_contract_type:String = Vehiculos[5]
                let clt_expiration_date:String = Vehiculos[6]
                let saldo:String = Vehiculos[7]
                let placa:String = Vehiculos[8]
                let color:String = Vehiculos[9]
                let anio:String = Vehiculos[10]
                let id:String = Vehiculos[11]
                let ctl_stall_id:String = Vehiculos[12]
                
                
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
                
                let url = URL(string: imgurl)
                DispatchQueue.background(background: {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async() {
                        imageCar.image = UIImage(data: data!)
                    }
                }, completion:{
                    print("ImgCharged")
                })
                
                let Titulo:UILabel = UILabel()
                Titulo.text = "\(Marca) \(Linea)"
                
                let Placa:UILabel = UILabel()
                Placa.text = "\(placa)"
                
                let Tag:UILabel = UILabel()
                Tag.text = "Tag: \(tag)"
                
                let tipoContrato:UILabel = UILabel()
                
                
                print("Este es el ctlContract \(ctl_contract_type)")
                if ctl_contract_type == "C" {
                    tipoContrato.text = "Saldo: \(saldo)"
                }
                if (ctl_contract_type == "V" || ctl_contract_type == "M") {
                    tipoContrato.text = "Contrato vence: \(clt_expiration_date)"
                }
                    
                
                let Tramites:UILabel = UILabel()
                Tramites.text = "Trámites para este vehículo"
                
                
                Titulo.font = UIFont(name:"AvenirNext-Bold", size: 18.0)
                Placa.font = UIFont(name:"AvenirNext-Bold", size: 14.0)
                Tag.font = UIFont(name:"merriweather-regular", size: 15.0)
                tipoContrato.font = UIFont(name:"merriweather-regular", size: 15.0)
                
        
                Titulo.textColor = .black
                Placa.textColor = .gray
                Tag.textColor = .black
                tipoContrato.textColor = .black

                Tramites.textColor = .black
                Tramites.textAlignment = .center
                
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
                Spacer = UIStackView()
                BottomTop.addArrangedSubview(Spacer)
                BottomTop.addArrangedSubview(Tramites)
                
                BottomBottom = UIStackView()
                BottomBottom.axis = .vertical
                BottomBottom.distribution = .fill
                BottomBottom.layer.cornerRadius = 20
                BottomBottom.spacing = 5
                BottomBottom.layer.masksToBounds = true
                
                
                Bottom.addArrangedSubview(BottomTop)
                
                var arr:Array<String> = Array()
                arr.append("Trámite para Cambio de Vehiculo")
                arr.append("Trámite para Cambio de TAG")
                arr.append("Trámite para Cambio de puente")
                arr.append("Trámite para Cambio de convenio")
                arr.append("Actualización de Poliza de Seguro")
                arr.append("Actualización de placas")
                arr.append("Baja de vehículo")
                //arr.append("Desactivar TAG")
                arr.append("Transferencia de saldo")
                
            
                ScrollTramites = UIScrollView()
                ScrollTramites.contentSize = CGSize(width: tempView.bounds.width, height: 400 )
                
                Bottom.addArrangedSubview(ScrollTramites)
                
                ScrollTramites.addSubview(BottomBottom)
            
                BottomBottom.translatesAutoresizingMaskIntoConstraints = false
                BottomBottom.topAnchor.constraint(equalTo: ScrollTramites.topAnchor).isActive = true
                BottomBottom.bottomAnchor.constraint(equalTo: ScrollTramites.bottomAnchor).isActive = true
                BottomBottom.leadingAnchor.constraint(equalTo: ScrollTramites.leadingAnchor).isActive = true
                BottomBottom.trailingAnchor.constraint(equalTo: ScrollTramites.trailingAnchor).isActive = true
                BottomBottom.widthAnchor.constraint(equalTo: ScrollTramites.widthAnchor).isActive = true
                
                var tipoTramiteVal = 0;
                
                for i in 0..<(arr.count) {
                    let tipoTramite:UIButton = UIButton(type: .roundedRect)
                    tipoTramite.setTitle(arr[i], for: .normal)
                    
                    if i+1 == 1 {
                        tipoTramiteVal = 1
                    }
                    if i+1 == 2 {
                        tipoTramiteVal = 2
                    }
                    if i+1 == 3 {
                        tipoTramiteVal = 7
                    }
                    if i+1 == 4 {
                        tipoTramiteVal = 8
                    }
                    if i+1 == 5 {
                        tipoTramiteVal = 3
                    }
                    if i+1 == 6 {
                        tipoTramiteVal = 4
                    }
                    if i+1 == 7 {
                        tipoTramiteVal = 5
                    }
                    //if i+1 == 8 {
                    //    tipoTramiteVal = 6
                    //}
                    if i+1 == 8 {
                        tipoTramiteVal = 9
                    }
                    
                    tipoTramite.accessibilityLabel = "\(tipoTramiteVal),\(Marca),\(Linea),\(color),\(anio),\(placa),\(tag),\(ctl_contract_type),\(ctl_stall_id)"
                    tipoTramite.setTitleColor(.white, for: .normal)
                    tipoTramite.layer.masksToBounds = true
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
                    tipoTramite.addGestureRecognizer(tapGesture)
                    
                    tipoTramite.backgroundColor = .black
                    tipoTramite.heightAnchor.constraint(equalToConstant: 35).isActive = true
                    
                    if ctl_contract_type.contains("V") {
                        let hoy = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let fechaObjetivo = dateFormatter.date(from: clt_expiration_date)

                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.day], from: hoy, to: fechaObjetivo!)
                        if let diferencia = components.day {
                            if diferencia > 30 {
                                if i == 2 || i == 3 {
                                    tipoTramite.isHidden = true
                                }
                                
                                
                            }
                        }
                    }
                    
                    if arr[i].contains("Transferencia de saldo") {
                        if !ctl_contract_type.contains("C") {
                            break
                        }
                    }
                    BottomBottom.addArrangedSubview(tipoTramite)
                }
                if i == index {
                    break
                }
                
            }
        }else{
            DispatchQueue.main.async {
                self.mainBtn.accessibilityLabel = "0,0,0,0,0,0,0"
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
                self.mainBtn.addGestureRecognizer(tapGesture)
            }
        }
        
        
        tempView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        tempView.isLayoutMarginsRelativeArrangement = true
        
        tempView.layer.cornerRadius = 20
        tempView.layer.masksToBounds = true
        tempView.addArrangedSubview(Top)
        tempView.addArrangedSubview(Bottom)

        
        //if index != carousel.currentItemIndex {
        //    tempView.alpha = 0
        //}else {
        //    tempView.alpha = 1
        //}
        //
        return tempView
    }
      
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.1
        }
        return value
    }
    
    @objc func scrollToNext() {
        carousel.scrollToItem(at: carousel.currentItemIndex + 1, animated: true)
    }
    
    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel) {
      
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        //for item in carousel.visibleItemViews {
        //       if let itemView = item as? UIView {
        //           if carousel.index(ofItemView: itemView) == carousel.currentItemIndex {
        //               itemView.alpha = 1
        //           } else {
        //               itemView.alpha = 0
        //           }
        //       }
        //   }

    }
    
    func getVehicles() {
        // create post request
        let session = URLSession.shared
         
         let sem = DispatchSemaphore.init(value: 0)

         //var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/vehicles")!)
         var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx/api/v1/vehicles")!)
         request.httpMethod = "GET"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("Json Raw = \(jsonArray) además \(jsonArray.count)" )
                    
                    if jsonArray.count == 0 {
                        DispatchQueue.main.async {
                            self.mainBtn.accessibilityLabel = "0,0,0,0,0,0,0"
                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
                            self.mainBtn.addGestureRecognizer(tapGesture)
                        }
                    }
                    
                    for i in 0..<(jsonArray.count) {
                        let tipoVeh: Int? = jsonArray[i]["tipo"] as? Int
                        let Marca: String? = jsonArray[i]["marca"] as? String ?? ""
                        let Linea: String? = jsonArray[i]["linea"] as? String ?? ""
                        let tag: String? = jsonArray[i]["tag"] as? String ?? ""
                        let imgurl: String? = jsonArray[i]["imgurl"] as? String ?? ""
                        let ctl_contract_type: String? = jsonArray[i]["ctl_contract_type"] as? String ?? "undefined"
                        let clt_expiration_date: String? = jsonArray[i]["clt_expiration_date"] as? String ?? "undefined"
                        let saldo: String? = jsonArray[i]["saldo"] as? String ?? "undefined"
                        let placa: String? = jsonArray[i]["placa"] as? String ?? "undefined"
                        let color: String? = jsonArray[i]["color"] as? String ?? "undefined"
                        let anio: String? = jsonArray[i]["modelo"] as? String ?? "undefined"
                        let ctl_stall_id: String? = jsonArray[i]["ctl_stall_id"] as? String ?? ""
                        let id: Int? = jsonArray[i]["id"] as? Int
                        
                        
                        
                        if tipoVeh == 0 {
                            continue
                        }
                        if tipoVeh == 2 {
                            continue
                        }
                        var Vehicle: String = ""
                        
                        Vehicle = String(tipoVeh!) + "∑" + Marca! + "∑" + Linea! + "∑" + tag! + "∑" + imgurl! + "∑" + ctl_contract_type! + "∑" + clt_expiration_date! + "∑" + saldo! + "∑" + placa! + "∑" + color! + "∑" + anio! + "∑" + ctl_stall_id! + "∑" + String(id!)
                        
                        
                
                        //if (tag?.contains("EPAS") == true) || (tag?.contains("FPFC") == true) {
                        //    //print("El tag que debe contener 'EPAS o FPFC' \(tag!) ")
                        //    //Vehicle = String(tipoVeh!) + "∑" + Marca! + "∑" + Linea! + "∑" + tag! + "∑" + imgurl! + "∑" + ctl_contract_type! + "∑" + clt_expiration_date! + "∑" + saldo! + "∑" + placa! + "∑" + color! + "∑" //+ anio! + "∑" + ctl_stall_id!
                        //}else {  // Usando temporalmente
                        //
                        //
                        //
                        //}
                        
                        self.vehReceived.append(Vehicle)

                    }
                    
                    if self.vehReceived.count == 0 {
                        print("Debería estar entrando aqui")
                        DispatchQueue.main.async {
                            self.mainBtn.accessibilityLabel = "0,0,0,0,0,0,0"
                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
                            self.mainBtn.addGestureRecognizer(tapGesture)
                        }
                    }
                }else if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Json Raw = \(jsonObject)")
                    
                    DispatchQueue.main.async {
                        self.mainBtn.accessibilityLabel = "0,0,0,0,0,0,0"
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
                        self.mainBtn.addGestureRecognizer(tapGesture)
                    }
                }else {
                    print("No se pudo obtener el Array ni el Object")
                }
                
                
            }
        }

         task.resume()
         sem.wait()

    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let labelTag = sender.view?.accessibilityLabel
        
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "SolInscripcionViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoTramite"), object: labelTag)
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

}
