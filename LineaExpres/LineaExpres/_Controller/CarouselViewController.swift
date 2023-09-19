//
//  CarouselViewController.swift
//  LineaExpres
//
//

import UIKit
import iCarousel
import SwiftyJSON
import Foundation

class CarouselViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    let db = DB_Manager()
    var carousel: iCarousel!
    var timer: Timer?
    var cantidadNotas: Int = 0
    var Title: String = ""
    var body: String = ""
    
    var carouselNotas: [String] = []
    var notaID: [String] = []
    
    @IBOutlet weak var stackH: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onResume), name: UIApplication.willEnterForegroundNotification, object: nil)
        setupCarousel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCarousel()
    }
    
    func setupCarousel() {
        carouselNotas = db.getNotasForCarousel()
        notaID = db.getNotaID()
    }
    
    func startCarousel() {
        cantidadNotas = carouselNotas.count
        
        carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        carousel.type = .linear
        carousel.centerItemWhenSelected = true
        carousel.dataSource = self
        carousel.delegate = self
        stackH.addArrangedSubview(carousel)
        startTimer()
    }
    
    @objc func onResume() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            //self.carousel.reloadData()
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return cantidadNotas
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        if carousel.currentItemIndex >= carousel.numberOfItems - 1 {
            carousel.scrollToItem(at: 0, animated: true)
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        let label = UILabel(frame: tempView.bounds)
        label.text = carouselNotas[index]
        label.tag = Int(notaID[index])!
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "AvenirNext-Bold", size: 22)
        label.numberOfLines = 16
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        label.addGestureRecognizer(tapGesture)
        tempView.addSubview(label)
        
        if index != carousel.currentItemIndex {
            tempView.alpha = 0
        } else {
            tempView.alpha = 1
        }
        
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == .spacing {
            return value * 1.1
        }
        return value
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let labelTag = sender.view?.tag
        NotificationCenter.default.post(name: Notification.Name("viewChanger"), object: "NotasViewController")
        NotificationCenter.default.post(name: Notification.Name("NotaToShow"), object: labelTag!)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNext() {
        carousel.scrollToItem(at: carousel.currentItemIndex + 1, animated: true)
    }
    
    func carouselWillBeginScrollingAnimation(_ carousel: iCarousel) {
        timer?.invalidate()
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        for item in carousel.visibleItemViews {
            if let itemView = item as? UIView {
                if carousel.index(ofItemView: itemView) == carousel.currentItemIndex {
                    itemView.alpha = 1
                } else {
                    itemView.alpha = 0
                }
            }
        }
        startTimer()
    }
}
