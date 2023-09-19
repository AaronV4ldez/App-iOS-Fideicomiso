//
//  CrearCitaViewController.swift
//  LineaExpres
//

import UIKit
import DropDown

class CrearCitaViewController: UIViewController {

    @IBOutlet weak var MainScroll: UIScrollView!
    @IBOutlet weak var MainStack: UIStackView!
    @IBOutlet weak var MainStackHeight: NSLayoutConstraint!
    @IBOutlet weak var DatePicker: UITextField!
    let dropDown = DropDown() //2
    @IBOutlet weak var Hours: UIButton!
    @IBOutlet weak var LabelTitle: UILabel!
    @IBOutlet weak var CitaShowDate: UILabel!
    @IBOutlet weak var titleCitaShow: UILabel!
    
    var idProc:String = ""
    var IdProcType:String = ""
    
    var Email:String = ""
    var Name:String = ""
    var SizeConstant:Int = 0
    @IBOutlet weak var TramitesContainer: UIView!
    var MethodCita: String = ""
    // var FirebaseToken:String = ""
    var LoginToken:String = ""
    
    
    //Buttons confirms
    @IBOutlet weak var ConfirmCita: UIButton!
    @IBOutlet weak var ConfirmCitaChange: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let validationPass:Bool = verifyLogging()
        if (!validationPass) {
            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "LoginViewController")
        }
        
        startRounding()
        
        DatePicker.tintColor = UIColor.black
        DatePicker.applyTextFieldStyle()
        
        
        
        let CitaInfo:String = DB_Manager().getCita()
        
        let CitaArr:Array<String> = CitaInfo.components(separatedBy: "∑")
        let TramiteID:String = CitaArr[0]
        let ProcedureID:String = CitaArr[1]
        //let idProcedureStatus:String = CitaArr[2]
        //let TramiteStatus:String = CitaArr[3]
        idProc = ProcedureID
        IdProcType = TramiteID
        
        //If cita is just create, CitasShowDate should be hidden
        CitaShowDate.isHidden = true
        titleCitaShow.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetCitasMeth(_:)), name: Notification.Name("citasMethodPm"), object: nil)
        
        
        
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        DatePicker.inputView = datePicker
        
    }
    
   

    
    @objc func didGetCitasMeth(_ notification: Notification) {
        let text:String = notification.object as! String
        MethodCita = text
        print(MethodCita)
        if MethodCita.contains("ChangeDate") {
            ConfirmCita.setTitle("Confirmar Cambio", for: .normal)
            LabelTitle.text = "Cambio de cita"
            //But if "cita" is "ChangeDate" CitaShowDate should be visible
            CitaShowDate.isHidden = false
            titleCitaShow.isHidden = false
            
            getCitaDate()
        }
        if MethodCita.contains("CreateDate") {
            ConfirmCita.setTitle("Confirmar Cita", for: .normal)
            LabelTitle.text = "Crear cita"
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("citasMethodPm"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("citasMethod"), object: MethodCita)
        
    }
    
    @IBAction func checkDisponibilityClicked(_ sender: Any) {
        if (!DatePicker.text!.isEmpty) {
            let CitasDisp = getDates()
            dropDown.dataSource = CitasDisp
            Hours.tintColor = UIColor.blue
            
        }
       
    }
    
    
    @IBAction func confirmCitaClicked(_ sender: Any) {
        setDate()
        
    }
    
    @IBAction func tapChooseMenuItem(_ sender: UIButton) {
        
        dropDown.anchorView = sender //5
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropDown.show() //7
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in //8
            guard let _ = self else { return }
            sender.setTitle(item, for: .normal) //9
        }
    }
    
    @objc func dateChange(datePicker: UIDatePicker) {
        DatePicker.text = formatDate(date: datePicker.date)
    }
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func startRounding() {
        TramitesContainer.layer.cornerRadius = 20
        TramitesContainer.layer.masksToBounds = true
        
        MainStack.layer.cornerRadius = 20
        MainStack.layer.masksToBounds = true
        
        //Ajustar padding a StackView
        MainStack.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        MainStack.isLayoutMarginsRelativeArrangement = true
    }

    func getDates() -> Array<String> {
        let date:String = DatePicker.text!
        
        let json: [String: Any] = ["date": date]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let session = URLSession.shared
        var dataReceived: Array<String> = []
        let sem = DispatchSemaphore.init(value: 0)
        
        var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/appointments/available")!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
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
                            let HoraInicio: String? = jsonArray[i]["inicio"] as? String
                            let HoraFinal: String? = jsonArray[i]["fin"] as? String
                            let InnerHours:String = "Inicia \(HoraInicio!) Termina \(HoraFinal!)"
                            dataReceived.append(InnerHours)
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
    
    func getCitaDate() {
        
        // create post request
        let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/appointments")!
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
                       
                        if jsonArray.count != 0 {
                            for i in 0..<(jsonArray.count) {
                                let DateCita = jsonArray[i]["dt"] as! String
                                let idCita = jsonArray[i]["id"] as! String
                                
                                if idCita.elementsEqual(self.IdProcType) {
                                    print("Existe")
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.locale = Locale(identifier: "es_ES")
                                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    
                                    let fecha = dateFormatter.date(from: DateCita)
                                    
                                    let dateFormatter2 = DateFormatter()
                                    dateFormatter2.locale = Locale(identifier: "es_ES")
                                    dateFormatter2.dateFormat = "HH:mm dd 'de' MMMM 'de' yyyy"
                                    
                                    let fechaFormateada = dateFormatter2.string(from: fecha!)
                                    
                                    DispatchQueue.main.async() {
                                        self.CitaShowDate.text = fechaFormateada
                                    }
                                    
                                    return
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
    
    func setDate() {
        var endpointUrl: String = ""
        if MethodCita.contains("ChangeDate"){
            endpointUrl = "https://lineaexpressapp.desarrollosenlanube.net/api/v1/appointments/change"
        }
        if MethodCita.contains("CreateDate") {
            endpointUrl = "https://lineaexpressapp.desarrollosenlanube.net/api/v1/appointments/create"
        }
        
        print("Que pasooo \(MethodCita)")
        
        if MethodCita == "" {
            return
        }
        
        let date:String = DatePicker.text!
        let fulltime: String = Hours.currentTitle!
        let timeSeparate = fulltime.components(separatedBy: " ")
        let hour:String = timeSeparate[1]
        print("Esta es lo de la hora \(date)")
        
        let json: [String: Any] = ["date": date, "time": hour, "id_proc": IdProcType, "id_proc_type": idProc]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        var request = URLRequest(url: URL(string: endpointUrl)!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(LoginToken)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
               
                let message:String? = responseJSON["message"] as? String
                
                if message != nil {
                    if (message!.contains("Cita creada") || message!.contains("Cita cambiada")) {
                        DispatchQueue.main.async() {
                            NotificationCenter.default.post(name: Notification.Name("viewChanger"), object:"ProfileViewController")
                        }
                        
                    }
                }
                
            }
        }
        
        task.resume()
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
