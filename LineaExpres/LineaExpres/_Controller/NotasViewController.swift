//
//  NotasViewController.swift
//  LineaExpres
//

import UIKit
import WebKit
import SwiftyJSON

class NotasViewController: UIViewController {
    let db = DB_Manager()
    
    @IBOutlet weak var ScrollMainContainer: UIScrollView!
    //@IBOutlet weak var CarouselContainer: UIView!
    //@IBOutlet weak var CarouselContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var TituloLbl: UILabel!
    @IBOutlet weak var ImageNota: UIImageView!
    @IBOutlet weak var BodyText: UITextView!
    @IBOutlet weak var adImage: UIImageView!
    @IBOutlet weak var prevLbl: UILabel!
    @IBOutlet weak var nextLbl: UILabel!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var ContainerMain: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ContainerMain.layer.cornerRadius = 20
        ContainerMain.layer.masksToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotification(_:)), name: Notification.Name("NotaToShow"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ContainerMain.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        ContainerMain.isLayoutMarginsRelativeArrangement = true
        
        createWebView()
    }
    
    @IBAction func prevBtnClick(_ sender: Any) {
        updateNota(id: prevBtn.tag)
        changePrevNextBtn(actualNota: prevBtn.tag)
    }
    
    @IBAction func nextBtnClick(_ sender: Any) {
        updateNota(id: nextBtn.tag)
        changePrevNextBtn(actualNota: nextBtn.tag)
    }
    
    @objc func didGetNotification(_ notification: Notification) {
        guard let noteID = notification.object as? Int else {
            return
        }
        updateNota(id: noteID)
        changePrevNextBtn(actualNota: noteID)
        NotificationCenter.default.removeObserver("NotaToShow")
        print("Esto viene desde notas: \(noteID)")
    }
    
    func updateNota(id: Int) {
        guard let nota = db.getNota(id: id).first else {

            return
        }
        
        let notaComponents = nota.components(separatedBy: "∑")
        let notaTitle = notaComponents[0]
        let notaBody = notaComponents[1]
        let notaURL = notaComponents[2]
        
       
        
        TituloLbl.text = notaTitle
        let imageURL = URL(string: notaURL)
        ImageNota.sd_setImage(with: imageURL, completed: nil)
        ImageNota.layer.cornerRadius = 20
        ImageNota.layer.masksToBounds = true
        
        if !notaBody.isEmpty {
            let attributedText = "<span style=\"font-size: 16px; \">\(notaBody)</span>".htmlToAttributedString
            BodyText.attributedText = attributedText
        } else {
            BodyText.text = ""
        }
        
       // adjustUITextViewHeight()
    }
    
    
    func createWebView() {
        //guard let url = URL(string: "https://lineaexpressapp.desarrollosenlanube.net/api/v1/config/mobile") else {
        guard let url = URL(string: "https://apis.fpfch.gob.mx/api/v1/config/mobile") else {
            print("Error: Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let json = try JSON(data: data)
                    let portada = json["mbInterioresURL"].stringValue
                    
                    if let adURL = URL(string: portada) {
                        DispatchQueue.main.async {
                            self?.adImage.sd_setImage(with: adURL, completed: nil)
                        }
                    }
                } catch {
                    print("Error: Failed to parse JSON - \(error)")
                }
            }
        }.resume()
    }
    
    func changePrevNextBtn(actualNota: Int) {
        let nextNota = db.getPrevAndNextNote(actualID: actualNota, neg: "")
        let prevNota = db.getPrevAndNextNote(actualID: actualNota, neg: "Prev")
        
        if let nextNote = nextNota.first, !nextNote.contains("0∑∑∑") {
            let NextNoteArray = nextNote.components(separatedBy: "∑")
            let nextNotaID = NextNoteArray[0]
            let nextNotaTitle = NextNoteArray[1]
            
            DispatchQueue.main.async {
                self.nextBtn.tag = Int(nextNotaID)!
                self.nextBtn.setTitle(nextNotaTitle, for: .normal)
                self.nextBtn.titleLabel?.lineBreakMode = .byWordWrapping
                self.nextBtn.titleLabel?.textAlignment = .center
                self.ScrollMainContainer.setContentOffset(.zero, animated: true)
                self.nextBtn.isHidden = false
                self.nextLbl.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                self.nextBtn.isHidden = true
                self.nextLbl.isHidden = true
            }
        }
        
        if let prevNote = prevNota.first, !prevNote.contains("0∑∑∑") {
            let PrevNoteArray = prevNote.components(separatedBy: "∑")
            let prevNotaID = PrevNoteArray[0]
            let prevNotaTitle = PrevNoteArray[1]
            
            DispatchQueue.main.async {
                self.prevBtn.tag = Int(prevNotaID)!
                self.prevBtn.setTitle(prevNotaTitle, for: .normal)
                self.prevBtn.titleLabel?.lineBreakMode = .byWordWrapping
                self.prevBtn.titleLabel?.textAlignment = .center
                self.ScrollMainContainer.setContentOffset(.zero, animated: true)
                self.prevBtn.isHidden = false
                self.prevLbl.isHidden = false
            }
        } else {
            DispatchQueue.main.async {
                self.prevBtn.isHidden = true
                self.prevLbl.isHidden = true
            }
        }
    }
}

extension String {

    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }

    func convertToAttributedString() -> NSAttributedString? {
        let modifiedFontString = "<span style=\"font-size: 24px; \">" + self + "</span>"
        return modifiedFontString.htmlToAttributedString
    }
}
