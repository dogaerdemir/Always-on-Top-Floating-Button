//
//  FloatingButtonController.swift
//  QuickNotes
//
//  Created by Doğa Erdemir on 27.08.2022.
//

import Foundation
import UIKit

class FloatingButtonController: UIViewController
{
    private(set) var buttonFAB_Main: UIButton!
    private(set) var buttonFAB_Report: UIButton!
    private(set) var buttonFAB2: UIButton!

    // Button açık mı kapalı mı flag
    var fabState = 0

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // Window init
    init(scene: UIWindowScene) {
        window = FloatingButtonWindow(scene: scene)
        super.init(nibName: nil, bundle: nil)
        // En üstte olması için level max ayarlanmalı
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
        // View üstünde olmalı ve gizli olmamalı yani aktif olmalı
        window.isHidden = false
        window.rootViewController = self

        // Klavye açıldı mı takip edilmeli böylece klavyeye uygun aksiyon alınacak çakışma olmaması için
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(note:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    }

    private let window: FloatingButtonWindow

    override func loadView()
    {
        let view = UIView()
        
        let buttonFAB_Main = UIButton(type: .custom)
        buttonFAB_Main.layer.cornerRadius = 30
        buttonFAB_Main.setTitle("+", for: .normal)
        buttonFAB_Main.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        buttonFAB_Main.setTitleColor(UIColor.white, for: .normal)
        buttonFAB_Main.backgroundColor = UIColor.systemGreen
        buttonFAB_Main.frame = CGRect(x: 25, y: 400, width: 60, height: 60)
        
        let buttonFAB_Report = UIButton(type: .custom)
        buttonFAB_Report.layer.cornerRadius = 30
        buttonFAB_Report.setTitle("fbCtrl1", for: .normal)
        buttonFAB_Report.setTitleColor(UIColor.white, for: .normal)
        buttonFAB_Report.backgroundColor = UIColor.systemRed
        buttonFAB_Report.frame = CGRect(x: 25, y: 300, width: 60, height: 60)
        
        let buttonFAB2 = UIButton(type: .custom)
        buttonFAB2.layer.cornerRadius = 30
        buttonFAB2.setTitle("fbCtrl2", for: .normal)
        buttonFAB2.setTitleColor(UIColor.white, for: .normal)
        buttonFAB2.backgroundColor = UIColor.systemRed
        buttonFAB2.frame = CGRect(x: 25, y: 200, width: 60, height: 60)
        
        view.addSubview(buttonFAB_Main)
        view.addSubview(buttonFAB_Report)
        view.addSubview(buttonFAB2)
        
        self.view = view
        
        self.buttonFAB_Main = buttonFAB_Main
        window.button1 = buttonFAB_Main
        
        self.buttonFAB_Report = buttonFAB_Report
        window.button2 = buttonFAB_Report
        
        self.buttonFAB2 = buttonFAB2
        window.button3 = buttonFAB2

        // Bu GR sayesinde kaydırabiliyoruz
        let panner = UIPanGestureRecognizer(target: self, action: #selector(pan(panner:)))
        
        let mainFABTap = UITapGestureRecognizer(target: self, action: #selector(mainTapFAB))
        let reportFABTap = UITapGestureRecognizer(target: self, action: #selector(reportTapFAB))
        
        buttonFAB_Main.addGestureRecognizer(panner)
        
        buttonFAB_Report.addGestureRecognizer(panner)
        buttonFAB_Report.addGestureRecognizer(reportFABTap)
        
        buttonFAB_Main.addGestureRecognizer(panner)
        buttonFAB_Main.addGestureRecognizer(mainFABTap)
        
        // En başta üsttekiler gizli
        buttonFAB_Report.alpha = 0
        buttonFAB2.alpha = 0
    }
    
    

    @objc func reportTapFAB(){
        print("burada segue olacak ama nasıl")
    }
    
    @objc func mainTapFAB()
    {
        // Animasyon. Ayrıca ana butona tıklayınca üsttekiler gizlenip gösterilecek.
        UIView.animate(withDuration: 0.4, animations: {
            
            if self.fabState == 0
            {
                // Üsttekileri göster
                self.buttonFAB_Report.alpha = 1
                self.buttonFAB2.alpha = 1
                
                // 45 derece döndür, "+" -> "x"
                self.buttonFAB_Main.transform = CGAffineTransform(rotationAngle: 45 * .pi/180)
                
                // Görünür hale geçerken büyült/göster
                self.buttonFAB_Report.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.buttonFAB2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.fabState = 1
            }
            else{
                // Üsttekileri gizle
                self.buttonFAB_Report.alpha = 0
                self.buttonFAB2.alpha = 0
                
                // 45 derece geri döndür, "x" -> "+"
                self.buttonFAB_Main.transform = CGAffineTransform(rotationAngle: 0 * .pi/180)
                
                // Gizli hale geçerken küçült
                self.buttonFAB_Report.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.buttonFAB2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.fabState = 0
            }
            
            
        }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //snapButtonToSocket()  -->  Yoruma alınmazsa başlangıçta tuş en yakındaki socket noktasına gidiyor
    }

    // Button centerlarını kaydedip tanslation'dan sonra neredeyse o kadar offset ekliyor ve yeni center yapıyor.
    // Yani sonunda button bir noktadan diğerine kaymış oluyor.
    @objc func pan(panner: UIPanGestureRecognizer) {
        let offset = panner.translation(in: view)
        panner.setTranslation(CGPoint.zero, in: view)
        
        var center = buttonFAB_Main.center
        center.x += offset.x
        center.y += offset.y
        buttonFAB_Main.center = center
        
        var center2 = buttonFAB_Report.center
        center2.x += offset.x
        center2.y += offset.y
        buttonFAB_Report.center = center2
        
        var center3 = buttonFAB2.center
        center3.x += offset.x
        center3.y += offset.y
        buttonFAB2.center = center3
        
        
        // Kaydırma bittiğinde. Uncomment yapılırsa buton bırakıldığında en yakındaki sockete dönüyor.
        
        /*
        if panner.state == .ended || panner.state == .cancelled {
            UIView.animate(withDuration: 0.3) {
                self.snapButtonToSocket()
            }
        }
         */
    }

    // Klavye en üstte olduğundan dolayı onunla çakışma olmaması için geçici 0'a çekiliyor.
    @objc func keyboardDidShow(note: NSNotification) {
        window.windowLevel = UIWindow.Level(rawValue: 0)
        window.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
    }

    // Mantığı arraydeki minimum sayıyı bulmaya benzer. Socket centerları ile button centerlarını kıyaslayıp en kısayı buluyor ve buton centerı oraya çekiyor.
/*
    private func snapButtonToSocket() {
        var bestSocket = CGPoint.zero
        var distanceToBestSocket = CGFloat.infinity
        let center = button.center
        for socket in sockets {
            let distance = hypot(center.x - socket.x, center.y - socket.y)
            if distance < distanceToBestSocket {
                distanceToBestSocket = distance
                bestSocket = socket
            }
        }
        button.center = bestSocket
    }

    // Socket noktaları. İsteğe bağlı eklenip düzenlenebilir.
 
    private var sockets: [CGPoint] {
        let buttonSize = button.bounds.size
        let rect = view.bounds.insetBy(dx: 4 + buttonSize.width / 2, dy: 4 + buttonSize.height / 2)
        let y = min(rect.maxY - 50, max(rect.minY + 30, button.frame.minY + buttonSize.height / 2))
        /*
        let sockets: [CGPoint] = [
            CGPoint(x: rect.minX, y: rect.minY),
            CGPoint(x: rect.minX, y: rect.maxY),
            CGPoint(x: rect.maxX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.midX, y: rect.midY)
        ]
         */
        // y noktası önemli olduğu için commentlemedim yoksa safe areadan çıkıp çok yukarılarda kalabiliyor ve tıklanamayabiliyor.
        let sockets: [CGPoint] = [
            CGPoint(x: rect.minX + 15, y: y),
            CGPoint(x: rect.maxX - 15, y: y)
        ]
        return sockets
    }
*/
}

// Custom window.
private class FloatingButtonWindow: UIWindow {
    
    var button1: UIButton?
    var button2: UIButton?
    var button3: UIButton?
    
    init(scene: UIWindowScene) {
        super.init(windowScene: scene)
        // Background nil böylece gözükmüyor(transparent).
        backgroundColor = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* Buranın multiple return etmesi lazım. Button frame'i dışındaki noktalardaki inputu doğrudan arkaya viewa aktarıyor.
       İnput sadece button sınırları içindeyse bu windowda kalıyor ve butonlara tıklanabiliyor. 3 button için de yapmak için
       hepsini ORladım, sonuçta bool döndürüyor. Herhangi biri olmazsa yani 3 buton da dışındaysa input, onu arkaya aktarıyor.
    */
    fileprivate override func point(inside point: CGPoint, with event: UIEvent?) -> Bool
    {
        guard let button1 = button1 else { return false }
        let buttonPoint1 = convert(point, to: button1)
        
        guard let button2 = button2 else { return false }
        let buttonPoint2 = convert(point, to: button2)
        
        guard let button3 = button3 else { return false }
        let buttonPoint3 = convert(point, to: button3)
        
        return button3.point(inside: buttonPoint3, with: event) || button2.point(inside: buttonPoint2, with: event) || button1.point(inside: buttonPoint1, with: event)
    }
}

