//
//  HamburgerTabsViewController.swift
//  LineaExpres
//

import UIKit
import WebKit
import SwiftyJSON

class HamburgerTabsViewController: UIViewController {
    
    @IBOutlet weak var StackContainer: UIStackView!
    @IBOutlet weak var thWebView: WKWebView!
    
    var STitle: UILabel = UILabel()
    var SBody: WKWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        STitle.font = UIFont(name:"AvenirNext-Bold", size: 20.0)
        STitle.textColor = .black
        STitle.textAlignment = .center
        StackContainer.spacing = 5
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("TipoServicio"), object: nil)
        
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String
        getServicios(ServicioURL: text )
        
        STitle.numberOfLines = 4
        StackContainer.layer.masksToBounds = true
        StackContainer.layer.cornerRadius = 20
        StackContainer.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        StackContainer.isLayoutMarginsRelativeArrangement = true
        
    }

    
    func getServicios(ServicioURL: String) {
        let session = URLSession.shared
        
        var request = URLRequest(url: URL(string: ServicioURL)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { data, response, error in
            
            
            if let error = error {
                print("Error -> \(error)")
                return
            }
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                let json = JSON.init(parseJSON: string)
                
                let Title:String = json["title"]["rendered"].stringValue
                let BodyString:String = json["content"]["rendered"].stringValue
               print("El body es: \(BodyString)")
                DispatchQueue.main.async() {
                    self.STitle.text = Title
                    let style = "<style>body {font-family: Arial; font-size: 50px!important;}</style>"
                    self.SBody.configuration.websiteDataStore = .nonPersistent()
                    self.SBody.loadHTMLString("<html><head>\(style)</head><body>\(BodyString)</body></html>", baseURL: nil)
                    
                    
                   
        

                    
                    self.StackContainer.addArrangedSubview(self.STitle)
                    self.StackContainer.addArrangedSubview(self.SBody)
                    self.StackContainer.layoutIfNeeded()
                    let visibleSubviews = self.StackContainer.arrangedSubviews.filter { !$0.isHidden }
                    let totalHeight = visibleSubviews.reduce(0) { $0 + $1.frame.size.height }
                    self.StackContainer.frame.size.height = totalHeight
                    
                }
            }
        }
        
        task.resume()
        
    }
}
