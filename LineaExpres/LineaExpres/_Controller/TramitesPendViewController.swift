//
//  SubProfileViewController.swift
//  LineaExpres
//

import UIKit


class TramitesPendViewController: UIViewController {
    @IBOutlet weak var HeightSize: NSLayoutConstraint!
    @IBOutlet weak var RoundedContainer: UIView!
    @IBOutlet weak var Container: UIStackView!
    @IBOutlet weak var LoadingLbl: UILabel!
    
    var Email:String = ""
    var Name:String = ""
    var SizeConstant:Int = 0
    var LoginToken:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startRounding()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
       
        let tramitesPendientes = getTramites()
        
       

        
        var tramites:Array<String> = Array()
        tramites.append("Solicitud Inscripción")
        tramites.append("Inscripción en otro puente")
        tramites.append("Solicitud cambio de vehiculo")
        tramites.append("Solicitud transferencia de saldo")
        tramites.append("Solicitud baja de vehiculo o tag")
        
        for i in 0..<(tramites.count) {
            
            let Label:UILabel = UILabel()
            Label.textColor = .black
            Label.font = Label.font.withSize(20)
            Label.textAlignment = .center
            Label.heightAnchor.constraint(equalToConstant: 22).isActive = true
            Label.text = tramites[i]
            Label.accessibilityIdentifier = "Tramite\(i)"
            Label.isHidden = true
            Container.addArrangedSubview(Label)
        }
        
        
        Container.spacing = 5
        
        
        for i in 0...tramitesPendientes.count - 1 {
            let TramitesIDs = tramitesPendientes[i].components(separatedBy: "∑")
            let TramiteID:String = TramitesIDs[0]
            print("TramiteID: \(TramiteID)")
            let ProcedureID:String? = TramitesIDs[1]
            let tramitesValues = checkFilesStatus(id_proc: Int(TramiteID)!, id_proc_type: Int(ProcedureID!)!)
            if tramitesValues.count != 0 {
                for j in 0...tramitesValues.count - 1 {
                    let Values = tramitesValues[j].components(separatedBy: "∑")
                    let FileID:String = Values[0]
                    let FileStatus:String? = Values[1]
                    let FileTypeDesc:String = Values[2]
                    let Comment:String? = Values[3]
                    let IDProcType:Int? = Int(Values[4])
                    let file_name:String? = Values[5]
                    
                    
                    let ButtonTramite:UIButton = UIButton()
                   
                    
                    
                    ButtonTramite.backgroundColor = .systemBlue
                    ButtonTramite.titleLabel?.numberOfLines = 0
                    ButtonTramite.titleLabel?.lineBreakMode = .byWordWrapping
                    ButtonTramite.heightAnchor.constraint(equalToConstant: 70).isActive = true
                    
                    
                    ButtonTramite.layer.cornerRadius = 10
                    ButtonTramite.layer.masksToBounds = true
                    
                
                    ButtonTramite.accessibilityLabel = "\(FileID)∑\(FileStatus!)∑\(FileTypeDesc)∑\(Comment!)∑\(String(TramiteID))∑\(IDProcType!)∑\(file_name!)"
                    
                    ButtonTramite.addTarget(self, action: #selector(didBtnTramite(_ :)), for: .touchUpInside)
                    
                    ButtonTramite.titleLabel?.font =  UIFont(name: "AvenirNext-Bold", size: 13)

                    if IDProcType == 1 {
                        SizeConstant = SizeConstant + 125
                        ButtonTramite.setTitle("Rechazado: \(FileTypeDesc) \n Razón: \(Comment!)", for: .normal)
                    }
                    if IDProcType == 2 {
                        SizeConstant = SizeConstant + 125
                        ButtonTramite.setTitle("\(FileTypeDesc): Rechazado \n Razón: \(Comment!)", for: .normal)
                    }
                    if IDProcType == 3 {
                        SizeConstant = SizeConstant + 125
                        ButtonTramite.setTitle("\(FileTypeDesc): Rechazado \n Razón: \(Comment!)", for: .normal)
                    }
                    if IDProcType == 4 {
                        SizeConstant = SizeConstant + 125
                        ButtonTramite.setTitle("\(FileTypeDesc): Rechazado \n Razón: \(Comment!)", for: .normal)
                    }
                    if IDProcType == 5 {
                        SizeConstant = SizeConstant + 125
                        ButtonTramite.setTitle("\(FileTypeDesc): Rechazado \n Razón: \(Comment!)", for: .normal)
                    }
                    HeightSize.constant = CGFloat(SizeConstant)
                    Container.addArrangedSubview(ButtonTramite)
                }
            }
        }
        
        LoadingLbl.isHidden = true
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
    
    func startRounding() {
        self.RoundedContainer.layer.cornerRadius = 20
        RoundedContainer.layer.masksToBounds = true
        
        //Ajustar padding a StackView
        Container.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        Container.isLayoutMarginsRelativeArrangement = true
    }
    
    func getTramites() -> Array<String> {
        
        let session = URLSession.shared
         var dataReceived: Array<String> = []
         let sem = DispatchSemaphore.init(value: 0)

         var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs")!)
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
                   
                   if let data = string.data(using: .utf8) {
                       if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                           
                           for i in 0...jsonArray.count - 1 {
                               let TramiteID: Int? = jsonArray[i]["id"] as? Int
                               let ProcedureID: Int? = jsonArray[i]["id_procedure"] as? Int
                               
                               let TramiteDt:String = String(TramiteID!) + "∑" + String(ProcedureID!)
                            
                               dataReceived.append(TramiteDt)
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

         return dataReceived
    }

    func checkFilesStatus(id_proc:Int, id_proc_type:Int) -> Array<String> {
        let session = URLSession.shared
        var dataReceived: Array<String> = []
        let sem = DispatchSemaphore.init(value: 0)
        
        var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/files?id_proc=\(id_proc)&id_proc_type=\(id_proc_type)")!)
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
                
                if let data = string.data(using: .utf8) {
                    if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        if jsonArray.count != 0 {
                            
                            for i in 0...jsonArray.count - 1 {
                                let FileID: Int? = jsonArray[i]["id_file_type"] as? Int
                                let FileStatus: Int? = jsonArray[i]["file_status"] as? Int
                                let FileTypeDesc: String? = jsonArray[i]["file_type_desc"] as? String
                                let file_name: String? = jsonArray[i]["file_name"] as? String
                                let Comment: String? = jsonArray[i]["comment"] as? String ?? "Sin comentario"
                                if FileStatus == 1 {
                                    let TramiteDt:String = String(FileID!) + "∑" + String(FileStatus!) + "∑" + FileTypeDesc! + "∑" + Comment! + "∑" + String(id_proc_type) + "∑" + String(file_name!)
                                    dataReceived.append(TramiteDt)
                                }
                                
                                
                            }
                        }else {
                            return
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
        
        return dataReceived
    }
                                            
    @objc func didBtnTramite(_ sender: UIButton) {
        let tag:String? = sender.accessibilityLabel
        
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"TramiteFixViewController")
        NotificationCenter.default.post(name: Notification.Name("TramiteFix"), object:tag)
        
       
    }

}
