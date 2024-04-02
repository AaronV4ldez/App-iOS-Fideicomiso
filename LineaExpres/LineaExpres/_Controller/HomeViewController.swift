//
//  HomeViewController.swift
//  LineaExpres
//

import UIKit
import WebKit
import SwiftyJSON
import SDWebImage

class HomeViewController: UIViewController {
    @IBOutlet weak var notasContainer: UIView!
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var notasBackground: UIView!
    
    @IBOutlet weak var adMainContainer: UIView!
    @IBOutlet weak var adContainer: UIView!
    @IBOutlet weak var adWebview: UIImageView!

    @IBOutlet weak var YoutubeWebView: WKWebView!
    @IBOutlet weak var YoutubeView: UIView!
    @IBOutlet weak var NotasView: UIView!
    @IBOutlet weak var NotaStackView: UIStackView!
    @IBOutlet weak var CuatroNotasContainer: UIView!
    
    @IBOutlet weak var weatherContainer: UIView!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    // Start Obj's of Weather Interface
    @IBOutlet weak var weatherImage: WKWebView!
    @IBOutlet weak var currentSensation: UILabel!
    @IBOutlet weak var currentCent: UILabel!
    @IBOutlet weak var maxTemp: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var divider: WKWebView!
    @IBOutlet weak var windImg: UIImageView!
    @IBOutlet weak var windForce: UILabel!
    @IBOutlet weak var humidityImg: UIImageView!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var untilHour: UILabel!
    @IBOutlet weak var cameraView: UIView!
    // End Obj's of Weather Interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
        
        createWebView()
        setYoutubeonWebView()
        getWeatherInfo()
        startRadius()
    }
    
   
    
    @objc func dismissKeyboard() {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func getWeatherInfo() {
        DispatchQueue.global().async {
            //guard let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/clima") else {
            guard let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/clima") else {
                print("Error: Invalid URL")
                return
            }
            
            do {
                let content = try String(contentsOf: url, encoding: .ascii)
                let json = JSON(parseJSON: content)
                
                for index in 1...json.count {
                    let cityName = json[index]["cityName"].stringValue
                    let imageIcon = json[index]["iconBigURL"].stringValue
                    let tempCCurrent = json[index]["tempC"].intValue
                    let tempCMax = json[index]["tempMaxC"].intValue
                    let tempCMin = json[index]["tempMinC"].intValue
                    let feelsLike = json[index]["feelsLikeC"].intValue
                    let windSpeed = json[index]["windSpeed"].intValue
                    let humidity = json[index]["humidity"].intValue
                    let date = json[index]["dt"].stringValue
                    
                    if cityName.contains("Juarez") {
                        DispatchQueue.main.async {
                            let dateParts = date.components(separatedBy: " ")
                            let hours = dateParts[1]
                            let hoursParts = hours.components(separatedBy: ":")
                            let hourShort = hoursParts[0] + ":" + hoursParts[1]
                            
                            let styles = "<style>body{background-color:#121212;}.img{display:flex;justify-content:center;}img{width:200px;height:200px;}</style>"
                            let iFrame = "<html><body style='width: 100vw; height:100vh'><div class='img'><img width='100vw' height='100vh' src='\(imageIcon)' alt=''></div></body> \(styles) </html>"
                            
                            self.weatherImage.scrollView.isScrollEnabled = false
                            self.weatherImage.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                            self.weatherImage.loadHTMLString(iFrame, baseURL: nil)
                            
                            self.currentSensation.text = "SENSACIÓN: \(feelsLike)°"
                            self.currentCent.text = "\(tempCCurrent)°"
                            self.maxTemp.text = "\(tempCMax)° max"
                            
                            let stylesDivider = "<style>body{background-color:#121212;}.img{background-color: white; height: 5px;}</style>"
                            let iFrameDivider = "<html><body style='width: 100vw; height:100vh'><div class='img'><hr style='height:2px;border-width:0;color:white;background-color:white'></div></body> \(stylesDivider) </html>"
                            
                            self.divider.scrollView.isScrollEnabled = false
                            self.divider.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                            self.divider.loadHTMLString(iFrameDivider, baseURL: nil)
                            
                            self.minTemp.text = "\(tempCMin)° min"
                            self.windForce.text = "\(windSpeed) E"
                            self.humidity.text = "\(humidity)%"
                            self.untilHour.text = "Desde las: \(hourShort)"
                        }
                        break
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    @IBAction func btnCameraClick(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "CamerasViewController")
    }
    
    private func startRadius() {
        let cornerRadius: CGFloat = 20
        [notasContainer, notasBackground, adMainContainer, adContainer, adWebview, YoutubeView, CuatroNotasContainer, weatherContainer, cameraView].forEach { view in
            view?.layer.cornerRadius = cornerRadius
            view?.layer.masksToBounds = true
        }
        
        [adWebview, CuatroNotasContainer, YoutubeWebView, cameraView].forEach { view in
            view?.layer.cornerRadius = cornerRadius
            view?.layer.masksToBounds = true
        }
        
        mainStackView.layer.cornerRadius = cornerRadius
        mainStackView.layer.masksToBounds = true
        
        // Ajustar padding a StackView
        mainStackView.layoutMargins = UIEdgeInsets(top: 80, left: 15, bottom: 90, right: 15)
        mainStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func createWebView() {
        DispatchQueue.global().async {
            //guard let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/config/mobile") else {
            guard let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/config/mobile") else {
                print("Error: Invalid URL")
                return
            }
            
            do {
                let content = try String(contentsOf: url, encoding: .ascii)
                let json = JSON(parseJSON: content)
                
                let portada = json["mbPortadaURL"].stringValue
                
                if let adURL = URL(string: portada) {
                    let data = try Data(contentsOf: adURL)
                    DispatchQueue.main.async {
                        self.adWebview.image = UIImage(data: data)
                        print("Anuncio 1 Cargado")
                    }
                }
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func setYoutubeonWebView() {
        DispatchQueue.global().async {
            //guard let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/config/mobile") else {
            guard let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/config/mobile") else {
                print("Error: Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    print("Error: \(String(describing: error))")
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let videoURL = json["mbVideoURL"] as? String,
                   let youtubeURL = URL(string: videoURL) {
                    DispatchQueue.main.async {
                        self.YoutubeWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                        self.YoutubeWebView.configuration.allowsInlineMediaPlayback = true
                        self.YoutubeWebView.loadHTMLString(videoURL, baseURL: nil)
                        
                        let youtubeRequest = URLRequest(url: youtubeURL)
                        self.YoutubeWebView.load(youtubeRequest)
                    }
                }
            }
            task.resume()
        }
    }
}

class Notas4ViewController: UIViewController {

    @IBOutlet weak var notas4lbl: UILabel!
    
    @IBOutlet weak var Nota1Lbl: UILabel!
    @IBOutlet weak var Nota1Image: UIImageView!
    @IBOutlet weak var Nota1Btn: UIButton!
    
    @IBOutlet weak var Nota2Lbl: UILabel!
    @IBOutlet weak var Nota2Image: UIImageView!
    @IBOutlet weak var Nota2Btn: UIButton!
    
    @IBOutlet weak var Nota3Lbl: UILabel!
    @IBOutlet weak var Nota3Image: UIImageView!
    @IBOutlet weak var Nota3Btn: UIButton!
    
    @IBOutlet weak var Nota4Lbl: UILabel!
    @IBOutlet weak var Nota4Image: UIImageView!
    @IBOutlet weak var Nota4Btn: UIButton!
    
    let db = DB_Manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notas4lbl.layer.cornerRadius = 10
        notas4lbl.layer.masksToBounds = true
        
        self.Nota1Image.layer.cornerRadius = 10
        Nota1Image.layer.masksToBounds = true
        self.Nota2Image.layer.cornerRadius = 10
        Nota2Image.layer.masksToBounds = true
        self.Nota3Image.layer.cornerRadius = 10
        Nota3Image.layer.masksToBounds = true
        self.Nota4Image.layer.cornerRadius = 10
        Nota4Image.layer.masksToBounds = true
     
        listCompletion()
        
        if !ChecaInternet.Connection() {
            showAlert(title: "Línea Exprés", message: "No hay acceso a internet.")
        }
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
    
    @IBAction func Nota1Clicker(_ sender: Any) {
        let BtnTag: Int = Nota1Btn.tag
        ViewController().actualPage = "NotasViewController"
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "NotasViewController")
        NotificationCenter.default.post(name: Notification.Name("NotaToShow"), object: BtnTag)
    }
    
    @IBAction func Nota2Clicker(_ sender: Any) {
        let BtnTag: Int = Nota2Btn.tag
        ViewController().actualPage = "NotasViewController"
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "NotasViewController")
        NotificationCenter.default.post(name: Notification.Name("NotaToShow"), object: BtnTag)
    }
    
    @IBAction func Nota3Clicker(_ sender: Any) {
        let BtnTag: Int = Nota3Btn.tag
        ViewController().actualPage = "NotasViewController"
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "NotasViewController")
        NotificationCenter.default.post(name: Notification.Name("NotaToShow"), object: BtnTag)
    }
    
    @IBAction func Nota4Clicker(_ sender: Any) {
        let BtnTag: Int = Nota4Btn.tag
        ViewController().actualPage = "NotasViewController"
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "NotasViewController")
        NotificationCenter.default.post(name: Notification.Name("NotaToShow"), object: BtnTag)
    }
    
    func listCompletion() {
        let Lista: Array<String> = db.getLastFourNotas()
        for i in 0..<Lista.count {
            print("NotasAqui")
            let nota = Lista[i].components(separatedBy: "∑")
            let NotaID: Int = Int(nota[0])!
            let NotaTitle: String = nota[1]
            let NotaURL: String = nota[2]
            
            if i == 0 {
                Nota1Lbl.text = NotaTitle
                let url = URL(string: NotaURL)
                DispatchQueue.global(qos: .background).async {
                    if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            self.Nota1Image.image = UIImage(data: data)
                        }
                    }
                }
                Nota1Btn.tag = NotaID
            }
            
            if i == 1 {
                Nota2Lbl.text = NotaTitle
                let url = URL(string: NotaURL)
                DispatchQueue.global(qos: .background).async {
                    if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            self.Nota2Image.image = UIImage(data: data)
                        }
                    }
                }
                Nota2Btn.tag = NotaID
            }
            
            if i == 2 {
                Nota3Lbl.text = NotaTitle
                let url = URL(string: NotaURL)
                DispatchQueue.global(qos: .background).async {
                    if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            self.Nota3Image.image = UIImage(data: data)
                        }
                    }
                }
                Nota3Btn.tag = NotaID
            }
            
            if i == 3 {
                Nota4Lbl.text = NotaTitle
                let url = URL(string: NotaURL)
                DispatchQueue.global(qos: .background).async {
                    if let data = try? Data(contentsOf: url!) {
                        DispatchQueue.main.async {
                            self.Nota4Image.image = UIImage(data: data)
                        }
                    }
                }
                Nota4Btn.tag = NotaID
            }
        }
    }
}


extension DispatchQueue {

    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
