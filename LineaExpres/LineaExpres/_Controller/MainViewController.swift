//
//  MainViewController.swift
//  LineaExpres
//

import UIKit

class MainViewController: UIViewController {
    
    var scene:String = "HomeViewController"
    var lastScene:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeViews(vcString: scene)        
       NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("viewChanger"), object: nil)
        
        
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        let text:String = notification.object as! String
        lastScene = scene
        scene = text
        print("Se supone que llama cuantas veces, text? \(text)")
        if lastScene == scene {
            return
        }
        DB_Manager().InsertNavigation(NavigationName: text)
        changeViews(vcString: text)
        
    }
    
    func changeViews(vcString:String) {
        print("DEBUG: Entrando en changeViews, vcString = \(vcString)")

        for subview in self.view.subviews {
              subview.removeFromSuperview()
          }
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vcBuilded : UIViewController = storyboard.instantiateViewController(withIdentifier:vcString)
        self.addChild(vcBuilded)
        self.view.addSubview(vcBuilded.view)
        vcBuilded.didMove(toParent: self)
        vcBuilded.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        print("DEBUG: Saliendo de changeViews")

    }

    
}
