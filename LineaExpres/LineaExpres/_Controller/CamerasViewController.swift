//
//  CamerasViewController.swift
//  LineaExpres
//
//

import UIKit
import WebKit

class CamerasViewController: UIViewController {
    
    @IBOutlet weak var ZaragozaWebView: WKWebView!
    @IBOutlet weak var ZaragozaSurWebView: WKWebView!
    @IBOutlet weak var PasoDelNorteNorteWebView: WKWebView!
    @IBOutlet weak var PasoDelNorteSurWebView: WKWebView!
    @IBOutlet weak var LerdoNorteWebView: WKWebView!
    @IBOutlet weak var LerdoSurWebView: WKWebView!
    @IBOutlet weak var LerdoFilaWebView: WKWebView!
    
    @IBOutlet weak var webviewGeneral: WKWebView!
    
    var mbPuenteLive1: String = ""
    var mbPuenteLive2: String = ""
    var mbPuenteLive3: String = ""
    var mbPuenteLive4: String = ""
    var mbPuenteLive5: String = ""
    var mbPuenteLive6: String = ""
    var mbPuenteLive7: String = ""
    
    @IBOutlet weak var StackViewContainer: UIStackView!
    @IBOutlet weak var Container: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Ajustar padding a StackView
        StackViewContainer.layoutMargins = UIEdgeInsets(top: 80, left: 15, bottom: 90, right: 15)
        StackViewContainer.isLayoutMarginsRelativeArrangement = true
        
        Container.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        Container.isLayoutMarginsRelativeArrangement = true
        Container.layer.cornerRadius = 20
        Container.layer.masksToBounds = true

        // Configurar la WKWebView para permitir la reproducción en línea
        self.webviewGeneral.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.webviewGeneral.configuration.allowsInlineMediaPlayback = true
        self.webviewGeneral.configuration.mediaTypesRequiringUserActionForPlayback = []

        // HTML con título y video embebido
        let title = "Live Camera: Zaragoza"
        let htmlString = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Live Cameras</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    padding: 10px;
                    margin: 0;
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                }
                h1 {
                    font-size: 18px;
                    margin-bottom: 15px;
                    text-align: center;
                    color: #333;
                }
                iframe {
                    width: 100%;
                    height: 300px; /* Ajusta el tamaño del iframe */
                    border: none;
                }
                .container {
                    width: 100%;
                    max-width: 600px;
                    margin: auto;
                }
                .camera-section {
                    margin-bottom: 20px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="camera-section">
                    <h1>Paso del Norte (Norte)</h1>
                    <iframe src="https://camstreamer.com/embed/RmKKjLTyispBGGbIfFYnNMasTH45jhRs2Wo9Z1nZ"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Paso del Norte (Sur)</h1>
                    <iframe src="https://camstreamer.com/embed/tRbi7yHcfP1Q0MHaZwXCfd3ymXHZV8QYuulTvofn"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Lerdo (Norte)</h1>
                    <iframe src="https://camstreamer.com/embed/iEHyfOkiGPdnvCO4RYCLZTiFJGGk8InzjI3bXEx4"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Lerdo (Sur)</h1>
                    <iframe src="https://camstreamer.com/embed/iEKDRVOUybuFhtdKJKdRlaILyhMCSyrkEc8b0WgB"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Lerdo (Fila)</h1>
                    <iframe src="https://camstreamer.com/embed/ozH8YEP3bIkP22lBFoUUdGgB0sEJ1FNppmmw8wJ4"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Zaragoza (Norte)</h1>
                    <iframe src="https://camstreamer.com/embed/B3cMCOh60f8wcGEGwRhe3WTc8kFqthAFvUUdxGtE"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Zaragoza (Sur)</h1>
                    <iframe src="https://camstreamer.com/embed/HlfBjAnK17GcfIvm0PzDLDuTLFYdtOtruMOIZeQy"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Zaragoza Carga (Norte)</h1>
                    <iframe src="https://camstreamer.com/embed/VGvwCDk2Q3llvv72dI1eSvdoBOiZZ7jnQgV1zvN7"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Zaragoza Carga (Sur)</h1>
                    <iframe src="https://camstreamer.com/embed/xJBZVxgjwn8N8ix09zaRnP4B8ZnT3nyapF52p38B"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Guadalupe (Norte)</h1>
                    <iframe src="https://camstreamer.com/embed/uixDU3cVNl3OkKDDdEqOIkoiuBMeD2mSznGq0wUu"></iframe>
                </div>
                <div class="camera-section">
                    <h1>Guadalupe (Sur)</h1>
                    <iframe src="https://camstreamer.com/embed/pgoN0P9OWpB4C7mWffML3EraMCfHKjDnRGwjQO0p"></iframe>
                </div>
            </div>
        </body>
        </html>
        """

        // Cargar el HTML en el WKWebView
        self.webviewGeneral.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func requestYTUrl() {
        // create post request
        let session = URLSession.shared
        let sem = DispatchSemaphore.init(value: 0)

        var request = URLRequest(url: URL(string: "https://apis.fpfch.gob.mx/api/v1/config/mobile")!)
        request.httpMethod = "GET"
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")

        let task = session.dataTask(with: request) { data, response, error in
            defer { sem.signal() }
            
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    
                    if let string = dictionary["mbPuenteLive3"] as? String {
                        DispatchQueue.main.async() {
                            let VideoURL = string.replacingOccurrences(of: "watch?v=", with: "embed/")
                            self.ZaragozaWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                            self.ZaragozaWebView.configuration.allowsInlineMediaPlayback = true
                            self.ZaragozaWebView.loadHTMLString(VideoURL, baseURL: nil)
                            
                            let myURL = URL(string: VideoURL)
                            let youtubeRequest = URLRequest(url: myURL!)
                            self.ZaragozaWebView.load(youtubeRequest)
                        }
                    }
                    
                    // Similar code for other cameras...
                }
            } else {
                print("Error: Could not convert JSON string to")
            }
        }
        task.resume()
        sem.wait()
    }
}
