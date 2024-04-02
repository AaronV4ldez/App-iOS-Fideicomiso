//
//  citasDispViewController.swift
//  LineaExpres
//

import UIKit

class citasDispViewController: UIViewController {
    
    @IBOutlet weak var MainStack: UIStackView!
    @IBOutlet weak var MainHeight: NSLayoutConstraint!
    @IBOutlet weak var MainScroll: UIScrollView!
    @IBOutlet weak var TramitesContainer: UIView!
    var MethodCita:String = ""
    
    var Email:String = ""
    var Name:String = ""
    var SizeConstant:Int = 25
    
    var isObservingNotifications = false
    
    // var FirebaseToken:String = ""
    var LoginToken:String = ""

    var tipoTramite = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRounding()
        isObservingNotifications = false
        NotificationCenter.default.addObserver(self, selector: #selector(didGetCitasMethod(_:)), name: Notification.Name("citasMethod"), object: nil)
        
        if !isObservingNotifications {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ProfileViewController")

        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        let CitasDisp = getTramites()
        
        if CitasDisp.count != 0 {
            for i in 0..<(CitasDisp.count) {
                let CitasDisponibles = CitasDisp[i].components(separatedBy: "∑")
                
                let TramiteID:String = CitasDisponibles[0]
                let ProcedureID:String? = CitasDisponibles[1]
                let idProcedureStatus:String? = CitasDisponibles[2]
                let TramiteStatus:String? = CitasDisponibles[3]
                let TramiteName:String? = CitasDisponibles[4]
                
                let Label:UILabel = UILabel()
                let ButtonTramite:UIButton = UIButton()
                
                Label.textColor = .black
                Label.font = Label.font.withSize(25)
                Label.textAlignment = .center
                Label.numberOfLines = 3
                Label.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                ButtonTramite.backgroundColor = .systemBlue
                ButtonTramite.titleLabel?.numberOfLines = 1
                ButtonTramite.titleLabel?.lineBreakMode = .byWordWrapping
                ButtonTramite.heightAnchor.constraint(equalToConstant: 70).isActive = true
                
                ButtonTramite.layer.cornerRadius = 10
                ButtonTramite.layer.masksToBounds = true
                
                ButtonTramite.accessibilityLabel = "\(TramiteID)∑\(ProcedureID!)∑\(idProcedureStatus!)∑\(TramiteStatus!))"
                ButtonTramite.addTarget(self, action: #selector(didBtnCitas(_ :)), for: .touchUpInside)
                
                let sizeInt: Int = 55
                
              
                    SizeConstant = SizeConstant + sizeInt
                    //Label.text = "Solicitud Inscripción"
                    //ButtonTramite.setTitle(TramiteStatus!, for: .normal)
                    ButtonTramite.setTitle(TramiteName, for: .normal)
                
           
                
                DispatchQueue.main.async() {
                    self.MainHeight.constant = CGFloat(self.SizeConstant)
                    //MainStack.addArrangedSubview(Label)
                    self.MainStack.addArrangedSubview(ButtonTramite)
                }
               
                
            }
        }
        
    }

   
    @objc func didGetCitasMethod(_ notification: Notification) {
        let text:String = notification.object as! String
        MethodCita = text
        isObservingNotifications = true
        
        print("este es otro \(MethodCita)")
        
        if MethodCita.contains("CreateDate") {
            tipoTramite = 4
        }else {
            tipoTramite = 5
        }
        
    }
    
    
    func startRounding() {
        MainScroll.layer.cornerRadius = 20
        MainScroll.layer.masksToBounds = true
        
        TramitesContainer.layer.cornerRadius = 20
        TramitesContainer.layer.masksToBounds = true
        
        
        //Ajustar padding a StackView
        MainStack.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        MainStack.isLayoutMarginsRelativeArrangement = true
    }
    
    func getTramites() -> Array<String> {
        
        let session = URLSession.shared
         var dataReceived: Array<String> = []
         let sem = DispatchSemaphore.init(value: 0)

         //var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs")!)
         var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx/api/v1/procs")!)
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
                           print("JsonArray de Citas \(jsonArray)")
                           for i in 0..<(jsonArray.count) {
                               let TramiteID: Int? = jsonArray[i]["id"] as? Int
                               let ProcedureID: Int? = jsonArray[i]["id_procedure"] as? Int
                               let idProcedureStatus: Int? = jsonArray[i]["id_procedure_status"] as? Int
                               let TramiteStatus: String? = jsonArray[i]["tramite_status"] as? String
                               let TramiteName: String? = jsonArray[i]["tramite"] as? String
                               
                               if idProcedureStatus == self.tipoTramite {
                                   let TramiteDt:String = "\(String(TramiteID!))∑\(String(ProcedureID!))∑\(String(idProcedureStatus!))∑\(TramiteStatus!)∑\(TramiteName!)"
                                   dataReceived.append(TramiteDt)
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

         return dataReceived
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
    
    @objc func didBtnCitas(_ sender: UIButton) {
        let cita:String? = sender.accessibilityLabel
        let CitaArr:Array<String> = (cita?.components(separatedBy: "∑"))!
        let TramiteID:String = CitaArr[0]
        let ProcedureID:String = CitaArr[1]
        let idProcedureStatus:String = CitaArr[2]
        let TramiteStatus:String = CitaArr[3]
        print(CitaArr)
        
        if CitaArr.count == 0 {
            return
        }
        print(TramiteID)
        print("Aqui veremos que cita es : \(self.MethodCita)")
        DispatchQueue.main.async {
            DB_Manager().addCita(TramiteID: TramiteID, ProcedureID: ProcedureID, idProcedureStatus: idProcedureStatus, TramiteStatus: TramiteStatus)
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"CrearCitaViewController")
            NotificationCenter.default.post(name: Notification.Name("citasMethodPm"), object:self.MethodCita)
        }
    }
}
