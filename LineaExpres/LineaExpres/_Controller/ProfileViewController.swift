//
//  ProfileViewController.swift
//  LineaExpres
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileViewController: UIViewController {

    @IBOutlet weak var DataContainer: UIStackView!
    @IBOutlet weak var mainContainer: UIView!
    
    
    
    @IBOutlet weak var tramitesPendientes: UIStackView!
    @IBOutlet weak var citasDisponibles: UIStackView!
    @IBOutlet weak var cambiarFechas: UIStackView!
    
    @IBOutlet weak var DivisorOne: UIView!
    @IBOutlet weak var DivisorTwo: UIView!
    @IBOutlet weak var DivisorThree: UIView!
    @IBOutlet weak var DivisorFour: UIView!
    
    @IBOutlet weak var nombreLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    //Tramites
    @IBOutlet weak var LblTramites: UILabel!
    @IBOutlet weak var BtnTramites: UIButton!
    //Citas
    @IBOutlet weak var LblCitas: UILabel!
    @IBOutlet weak var BtnCitas: UIButton!
    
    @IBOutlet weak var LblCitasFechas: UILabel!
    @IBOutlet weak var BtnCitasFechas: UIButton!
    
    @IBOutlet weak var LineaExpresBtn: UIButton!
    @IBOutlet weak var goToSolTitle: UILabel!
    @IBOutlet weak var goToSolBtn: UIButton!
    
    //Borrar cuenta
    @IBOutlet weak var LeyendaEstasSeguro: UITextField!
    @IBOutlet weak var BorrarCuentaContainer: UIStackView!
    
    
    
    var Email:String = ""
    var Name:String = ""
    var FirebaseToken:String = ""
    var LoginToken:String = ""
    var PswdCheck:Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tramitesPendientes.isHidden = true
        citasDisponibles.isHidden = true
        cambiarFechas.isHidden = true
        DivisorOne.isHidden = true
        DivisorTwo.isHidden = true
        DivisorThree.isHidden = true
        
        self.LineaExpresBtn.isHidden = true
        self.goToSolTitle.isHidden = true
        self.goToSolBtn.isHidden = true
        
       
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        if PswdCheck == 0 {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "PreChangePassViewController")
        }
        
        
        
        startRounding()

        nombreLbl.text = Name
        emailLbl.text = Email
        
        getTramites()
        getVehicles()
        
        sendPush()
        
    }
    
    @IBAction func VehiclesClicked(_ sender: Any) {
           NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "VehicleViewController")
       }
    
    
    @IBAction func TramitesClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "TramitesPendViewController")
    }
    
    @IBAction func addVehicle(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "PostRegisterViewController")
    }
    @IBAction func goToTP(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "TelepeajeAddVehViewController")
    }
    @IBAction func goToADP(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "ADPAddVehViewController")
        NotificationCenter.default.post(name: Notification.Name("ADP"), object: 1)
    }
    @IBAction func goToLE(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LineaExpresAddVehViewController")
    }
    @IBAction func goToSoli(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "SolInscripcionViewController")
        NotificationCenter.default.post(name: Notification.Name("TipoTramite"), object: "0,0,0,0,0,0,0")
    }
    
    @IBAction func CitasDisponiblesClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "citasDispViewController")
        NotificationCenter.default.post(name: Notification.Name("citasMethod"), object: "CreateDate")
    }
    
    @IBAction func CitasChangeClicked(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "citasDispViewController")
        NotificationCenter.default.post(name: Notification.Name("citasMethod"), object: "ChangeDate")
    }
    
    func getVehicles() {
        // create post request
        let session = URLSession.shared
         
       

         //var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/vehicles")!)
         var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx/api/v1/vehicles")!)
         request.httpMethod = "GET"
         request.addValue("application/json", forHTTPHeaderField: "Content-Type")
         request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    print("Json Raw = \(jsonArray) además \(jsonArray.count)" )
                    
                    
                    var numeros = [Int]() // Array vacío de tipo Int
                    
                    for i in 0..<(jsonArray.count) {
                        let tipoVeh: Int? = jsonArray[i]["tipo"] as? Int
                        
                        numeros.append(tipoVeh!)
                        
                    }
                    let contieneUno = numeros.contains(1)
                    DispatchQueue.main.async {
                        if contieneUno {
                            self.LineaExpresBtn.isHidden = true
                            self.goToSolTitle.isHidden = true
                            self.goToSolBtn.isHidden = true
                        } else {
                            self.LineaExpresBtn.isHidden = false
                            self.goToSolTitle.isHidden = false
                            self.goToSolBtn.isHidden = false
                        }
                    }
                    
                }else {
                    print("No se pudo obtener el Array ni el Object")
                }
                
                
            }
        }

         task.resume()
         

    }
    
    @IBAction func Logout(_ sender: Any) {
        if (verifyLogging()) {
            DB_Manager().addUser(EmailVal: "", NameVal: "", LoginTokenVal: "", UserSetPwdVal: "", Sentri: "", SentriFecha: "")
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
            NotificationCenter.default.post(name: Notification.Name("LogoutFunc"), object: "")
        }
    }
    
    @IBAction func CambiarFechaCitaClicked(_ sender: Any) {
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
                FirebaseToken = Usuario[2]
                LoginToken = Usuario[3]
                if (!LoginToken.isEmpty) {
                    PswdCheck = Int(Usuario[4])!
                    pass = true
                }
            }
        }else {
            pass = false
        }
        return pass

    }
    
    func startRounding() {
        self.mainContainer.layer.cornerRadius = 20
        mainContainer.layer.masksToBounds = true
        
        BorrarCuentaContainer.layer.cornerRadius = 20
        BorrarCuentaContainer.layer.masksToBounds = true
        
        //Ajustar padding a StackView
        DataContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        DataContainer.isLayoutMarginsRelativeArrangement = true
        
        BorrarCuentaContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        BorrarCuentaContainer.isLayoutMarginsRelativeArrangement = true
        // Configurar el borde
        BorrarCuentaContainer.layer.borderWidth = 1.0
        BorrarCuentaContainer.layer.borderColor = UIColor.gray.cgColor

        
    }
    
    func getTramites() {
        
        // create post request
        //let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/procs")!
        let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/procs")!
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
                     (200...299).contains(httpResponse.statusCode) else {
                   print("HTTP request failed")
                   return
               }

            
            if let data = data, let string = String(data: data, encoding: .utf8) {

                 if let data = string.data(using: .utf8) {
                     if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                         var CitasCount:Int = 0
                         var CitasChangeCount: Int = 0
                         
                         if jsonArray.count != 0 {
                             for i in 0..<(jsonArray.count) {
                                 let TramiteID = jsonArray[i]["id"] as! Int
                                 let idProcedure = jsonArray[i]["id_procedure"] as! Int
                                 let id_procedure_status = jsonArray[i]["id_procedure_status"] as! Int
                                 
                                 if id_procedure_status == 4 {
                                     CitasCount = CitasCount+1
                                     print("Las citasCount de for es \(CitasCount)")
                                 }
                                 if id_procedure_status == 5 {
                                     CitasChangeCount = CitasChangeCount+1
                                 }
                                 
                                 self.checkFilesStatus(id_proc: TramiteID, id_proc_type: idProcedure)
                             }
                             
                            print("Las citasCount es \(CitasCount)")
                             if CitasCount != 0 {
                                 DispatchQueue.main.async() {
                                     self.DivisorTwo.isHidden = false
                                     self.citasDisponibles.isHidden = false
                                     self.LblCitas.text = "Tienes \(CitasCount) citas disponibles"
                                 }
                             }
                             if CitasChangeCount != 0 {
                                 DispatchQueue.main.async() {
                                     self.DivisorThree.isHidden = false
                                     self.cambiarFechas.isHidden = false
                                     self.LblCitasFechas.text = "Puedes cambiar la fecha de \(CitasChangeCount) citas"
                                 }
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

    func checkFilesStatus(id_proc:Int, id_proc_type:Int) {
    
        // create post request
        //let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/files?id_proc=\(id_proc)&id_proc_type=\(id_proc_type)")!
        let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/files?id_proc=\(id_proc)&id_proc_type=\(id_proc_type)")!
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
                     (200...299).contains(httpResponse.statusCode) else {
                   print("HTTP request failed")
                   return
               }

            
            if let data = data, let string = String(data: data, encoding: .utf8) {

                 if let data = string.data(using: .utf8) {
                     if let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        
                         var TramitesCount:Int = 0
                         var number:Int = 0
                         while number <= jsonArray.count - 1 {
                             let file_status: Int? = jsonArray[number]["file_status"] as? Int
                                if file_status == 1 {
                                    TramitesCount = TramitesCount+1
                                    DispatchQueue.main.async() {
                                        self.DivisorOne.isHidden = false
                                        self.tramitesPendientes.isHidden = false
                                        self.LblTramites.text = "Tienes \(TramitesCount) trámites pendientes"
                                    }
                                }
                             number += 1
                         }
                        
                         
                     } else {
                         print("Error: Could not convert JSON string to")
                     }
                 }
                 
            }
        }
          task.resume()
    }
    
    func sendPush() {
    
        print("Comienza el push")
        let json: [String: Any] = ["email": Email, "device_id": FirebaseToken]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        //let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user/saveid")!
        let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/user/saveid")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

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
                
            }
        }
          task.resume()
    }
    
    
    //Borrar cuenta
    @IBAction func AbrirModalBorrarCuentaBtn(_ sender: Any) {
        BorrarCuentaContainer.isHidden = false
    }
    
    @IBAction func CancelarProcesoBorradoCuentaBtn(_ sender: Any) {
        BorrarCuentaContainer.isHidden = true
    }
    
    
    @IBAction func BorrarCuentaBtn(_ sender: Any) {
        postDeleteAccount()
    }
    

    
    
    func postDeleteAccount(){
        
        let session = URLSession.shared
         let sem = DispatchSemaphore.init(value: 0)

         //var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/user")!)
         var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx/api/v1/user")!)
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
                               if (message!.contains("Usuario eliminado exitosamente.") || message!.contains("La petición la realizó un usuario no válido.")) {
                                   DispatchQueue.main.async {
                                       DB_Manager().addUser(EmailVal: "", NameVal: "", LoginTokenVal: "", UserSetPwdVal: "", Sentri: "", SentriFecha: "")
                                       NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
                                       NotificationCenter.default.post(name: Notification.Name("LogoutFunc"), object: "")
                                   }
                                   
                               }
                               DispatchQueue.main.async {
                                   self.showAlert(title: "Línea Exprés", message: message!)
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
