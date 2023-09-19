//
//  LaunchScreenViewController.swift
//  LineaExpres
//

import UIKit
import SwiftyJSON

class LaunchScreenViewController: UIViewController {

    let db = DB_Manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if ChecaInternet.Connection() {
            db.DeleteAllFromNotasTable()
            db.DeleteAllFromCitaTable()
            db.UserInsertOnInit()
            db.CitaInsertOnInit()
            db.DeleteAllFromNavigation()
            db.InsertNavigationOnInit(NavigationName: "HomeViewController")
            makeGetCall()
            
        } else {
            changeViews(vcString: "ViewController")
        }
       
        
        
        
    }
    
    func changeViews(vcString:String) {
       
        DispatchQueue.main.async {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vcBuilded : UIViewController = storyboard.instantiateViewController(withIdentifier:vcString)
            self.addChild(vcBuilded)
            self.view.addSubview(vcBuilded.view)
            vcBuilded.didMove(toParent: self)
            vcBuilded.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
       
       
    }
    
    func makeGetCall() {
        guard let url = URL(string: "https://lineaexpress.desarrollosenlanube.net/wp-json/wp/v2/posts?per_page=10&categories=18&_embed") else {
            print("Error: \(String(describing: link)) doesn't seem to be a valid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                
                for item in json ?? [] {
                    let notaID = item["id"] as? Int ?? 0
                    let title = item["title"] as? [String: Any]
                    let renderedTitle = title?["rendered"] as? String ?? ""
                    let body = item["content"] as? [String: Any]
                    let renderedBody = body?["rendered"] as? String ?? ""
                    let embedded = item["_embedded"] as? [String: Any]
                    let featuredMedia = embedded?["wp:featuredmedia"] as? [[String: Any]]
                    let imageUrl = featuredMedia?.first?["source_url"] as? String ?? ""
                    
                    self.db.InsertNotas(NotaID: notaID, NotaTitle: renderedTitle, NotaBody: renderedBody, NotaImageURL: imageUrl)
                    self.changeViews(vcString: "ViewController")
                }
            } catch {
                print("Error: \(error)")
            }
        }
        
        task.resume()
    }



}

