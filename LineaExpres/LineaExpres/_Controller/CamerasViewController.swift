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
      
        
        //Ajustar padding a StackView
        StackViewContainer.layoutMargins = UIEdgeInsets(top: 80, left: 15, bottom: 90, right: 15)
        StackViewContainer.isLayoutMarginsRelativeArrangement = true
        
        
        
        Container.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        Container.isLayoutMarginsRelativeArrangement = true
        
        Container.layer.cornerRadius = 20
        Container.layer.masksToBounds = true
        
        
    
        self.webviewGeneral.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.webviewGeneral.configuration.allowsInlineMediaPlayback = false
        
        
        let myURL = URL(string: "https://panelweb.fpfch.gob.mx/puentes/")
        let youtubeRequest = URLRequest(url: myURL!)
        self.webviewGeneral.load(youtubeRequest)
        
        //requestYTUrl()
    }
    
    
    func requestYTUrl() {
        // create post request
        let session = URLSession.shared
       
         let sem = DispatchSemaphore.init(value: 0)

         //var request = URLRequest(url: URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/config/mobile")!)
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
                            self.ZaragozaWebView.configuration.allowsInlineMediaPlayback = false
                            self.ZaragozaWebView.loadHTMLString(VideoURL, baseURL: nil)
                            
                            let myURL = URL(string: VideoURL)
                            let youtubeRequest = URLRequest(url: myURL!)
                            self.ZaragozaWebView.load(youtubeRequest)
                            
                        }
                    }
                    if let string = dictionary["mbPuenteLive4"] as? String {
                        DispatchQueue.main.async() {
                            let VideoURL = string.replacingOccurrences(of: "watch?v=", with: "embed/")
                            self.ZaragozaSurWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                            self.ZaragozaSurWebView.configuration.allowsInlineMediaPlayback = false
                            self.ZaragozaSurWebView.loadHTMLString(VideoURL, baseURL: nil)
                            
                            let myURL = URL(string: VideoURL)
                            let youtubeRequest = URLRequest(url: myURL!)
                            self.ZaragozaSurWebView.load(youtubeRequest)
                            
                        }
                    }
                    
                    if let string = dictionary["mbPuenteLive2"] as? String {
                        DispatchQueue.main.async() {
                            let VideoURL = string.replacingOccurrences(of: "watch?v=", with: "embed/")
                            self.PasoDelNorteNorteWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                            self.PasoDelNorteNorteWebView.configuration.allowsInlineMediaPlayback = false
                            self.PasoDelNorteNorteWebView.loadHTMLString(VideoURL, baseURL: nil)
                            
                            let myURL = URL(string: VideoURL)
                            let youtubeRequest = URLRequest(url: myURL!)
                            self.PasoDelNorteNorteWebView.load(youtubeRequest)
                            
                        }
                    }
                    
                    if let string = dictionary["mbPuenteLive1"] as? String {
                        DispatchQueue.main.async() {
                            let VideoURL = string.replacingOccurrences(of: "watch?v=", with: "embed/")
                            self.PasoDelNorteSurWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                            self.PasoDelNorteSurWebView.configuration.allowsInlineMediaPlayback = false
                            self.PasoDelNorteSurWebView.loadHTMLString(VideoURL, baseURL: nil)
                            
                            let myURL = URL(string: VideoURL)
                            let youtubeRequest = URLRequest(url: myURL!)
                            self.PasoDelNorteSurWebView.load(youtubeRequest)
                            
                        }
                    }
                    if let string = dictionary["mbPuenteLive5"] as? String {
                        DispatchQueue.main.async() {
                            let VideoURL = string.replacingOccurrences(of: "watch?v=", with: "embed/")
                            self.LerdoNorteWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                            self.LerdoNorteWebView.configuration.allowsInlineMediaPlayback = false
                            self.LerdoNorteWebView.loadHTMLString(VideoURL, baseURL: nil)
                            
                            let myURL = URL(string: VideoURL)
                            let youtubeRequest = URLRequest(url: myURL!)
                            self.LerdoNorteWebView.load(youtubeRequest)
                            
                        }
                    }
                    if let string = dictionary["mbPuenteLive6"] as? String {
                        DispatchQueue.main.async() {
                            let VideoURL = string.replacingOccurrences(of: "watch?v=", with: "embed/")
                            self.LerdoSurWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                            self.LerdoSurWebView.configuration.allowsInlineMediaPlayback = false
                            self.LerdoSurWebView.loadHTMLString(VideoURL, baseURL: nil)
                            
                            let myURL = URL(string: VideoURL)
                            let youtubeRequest = URLRequest(url: myURL!)
                            self.LerdoSurWebView.load(youtubeRequest)
                            
                        }
                    }
                    if let string = dictionary["mbPuenteLive7"] as? String {
                        DispatchQueue.main.async() {
                            let VideoURL = string.replacingOccurrences(of: "watch?v=", with: "embed/")
                            self.LerdoFilaWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
                            self.LerdoFilaWebView.configuration.allowsInlineMediaPlayback = false
                            self.LerdoFilaWebView.loadHTMLString(VideoURL, baseURL: nil)
                            
                            let myURL = URL(string: VideoURL)
                            let youtubeRequest = URLRequest(url: myURL!)
                            self.LerdoFilaWebView.load(youtubeRequest)
                            
                        }
                    }
  
                    
                    
                    
                   
                    
                }
                
            } else {
                print("Error: Could not convert JSON string to")
            }
            
            
            
        }

         task.resume()

         // This line will wait until the semaphore has been signaled
         // which will be once the data task has completed
         sem.wait()
    }
    


}
