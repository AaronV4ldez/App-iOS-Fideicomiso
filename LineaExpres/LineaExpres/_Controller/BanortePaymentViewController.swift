//
//  BanortePaymentViewController.swift
//  LineaExpres
//
//
import UIKit
import Alamofire
import WebKit
import DropDown
import Security
import SwiftyRSA

class BanortePaymentViewController: UIViewController, WKNavigationDelegate {
    
    var Tag: String = ""
    var Valor: String = ""
    var TIPOP: String = ""
    var vehType: Int = 0
    @IBOutlet weak var imageLoader: UIImageView!
    @IBOutlet weak var loaderContainer: UIView!
    @IBOutlet weak var webViewEmb: UIStackView!
    @IBOutlet var containerView: UIView! = nil
    var webView: WKWebView?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func loadView() {
        super.loadView()
        
        let webViewConfiguration = WKWebViewConfiguration()
        let webpagePreferences = WKWebpagePreferences()
        webpagePreferences.allowsContentJavaScript = true
        webViewConfiguration.defaultWebpagePreferences = webpagePreferences
        
        self.webView = WKWebView(frame: self.view.bounds, configuration: webViewConfiguration)
        
        webViewEmb.clipsToBounds = true
        webViewEmb.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didQty(_:)), name: Notification.Name("QtyToPay"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didContract(_:)), name: Notification.Name("ContractTypeTagSel"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didTag(_:)), name: Notification.Name("TagSelected2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getTipoVeh(_:)), name: Notification.Name("vehicletype"), object: nil)
        
        imageLoader.image = UIImage.gif(asset: "linea_expres_loader")
        
        self.webView?.navigationDelegate = self
        
        clearCache()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        webViewEmb.addArrangedSubview(self.webView!)
    }
    
    @objc func didQty(_ notification: Notification) {
        Valor = notification.object as? String ?? "0"
    }
    
    @objc func getTipoVeh(_ notification: Notification) {
        let text: String = notification.object as! String
        print("Tipo de veh es : \(text)")
        vehType = Int(text)!
    }
    
    @objc func didContract(_ notification: Notification) {
        TIPOP = notification.object as? String ?? ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if self.vehType == 5 {
                self.TIPOP = "5"
            }
            print("EL VALOR DE TIPOP ES: \(self.TIPOP)")
            if self.TIPOP.contains("0") {
                if self.vehType == 2 {
                    self.TIPOP = "5"
                } else {
                    self.TIPOP = "1"
                }
            }
            if self.TIPOP.contains("C") {
                self.TIPOP = "2"
            }
            if self.TIPOP.contains("V") {
                self.TIPOP = "3"
            }
            if self.TIPOP.contains("M") {
                self.TIPOP = "4"
            }
        }
    }
    
    @objc func didTag(_ notification: Notification) {
        let text: String = notification.object as! String
        Tag = text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if ChecaInternet.Connection() {
                let url = URL(string: "https://apis.fpfch.gob.mx/pagosmovil/#/\(self.Tag)/\(self.Valor)/\(self.TIPOP)")
                let req = URLRequest(url: url!)
                self.webView!.load(req)
            } else {
                self.Alert(Message: "Se requiere una conexión a internet")
            }
        }
    }
    
    func clearCache() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler: {})
        
        let cacheSizeMemory = 512 * 1024 * 1024
        let cacheSizeDisk = 512 * 1024 * 1024
        let cache = URLCache(memoryCapacity: cacheSizeMemory, diskCapacity: cacheSizeDisk, diskPath: nil)
        URLCache.shared = cache
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            if let url = navigationAction.request.url {
                webView.load(URLRequest(url: url))
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let waitSec = 1000
        let firstScript = "setTimeout(function(){document.getElementById('NUM_TAG').disabled = true; }, \(waitSec));"
        let fourScript = "setTimeout(function(){document.getElementById('MONTO').disabled = true; }, \(waitSec));"
        let fiftyScript = "setTimeout(function(){document.body.style.margin = '15px';document.body.style.backgroundColor = 'white';document.body.style.borderRadius = '10px'; }, \(waitSec));"
        let sixtyScript = "setTimeout(function(){document.getElementById('pagar').style.marginBottom = '15px'; }, \(waitSec));"
        let seventyScript = "setTimeout(function(){document.getElementById('pagar').style.width = '100%'; }, \(waitSec));"
        let disableButtonScript = """
            document.getElementById('pagar').disabled = false;
            setTimeout(function() {
                document.getElementById('pagar').disabled = true;
            }, 900000); // 900000 ms = 15 minutos
        """
        let Script = "setTimeout(function(){document.getElementById('NUMERO_TARJETA').type = 'number'; document.getElementById('NUMERO_TARJETA').type = 'number'; document.getElementById('CVC').type = 'number'; " +
        "document.getElementById('CODIGO_POSTAL').type = 'number';" +
        "document.getElementById('NUMERO_CELULAR').type = 'number';" +
        "}, \(waitSec));"
        
        let js =  firstScript + fourScript + fiftyScript + sixtyScript + seventyScript + disableButtonScript + Script
        webView.evaluateJavaScript(js, completionHandler: { (result, error) in
            if let error = error {
                print("Error ejecutando JavaScript: \(error)")
            } else {
                print("JavaScript ejecutado con éxito: \(result ?? "")")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.loaderContainer.isHidden = true
                }
            }
        })
        
        print("Entra al código")
    }
    
    func Alert(Message: String) {
        let alert = UIAlertController(title: "Error", message: Message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension String {
    func chunked(into size: Int) -> [String] {
        return stride(from: 0, to: count, by: size).map {
            let start = index(startIndex, offsetBy: $0)
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            return String(self[start..<end])
        }
    }
}
