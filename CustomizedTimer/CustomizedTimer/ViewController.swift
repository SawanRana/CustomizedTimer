//
//  ViewController.swift
//  CustomizedTimer
//
//  Created by Sawan Rana on 12/03/23.
//

import UIKit

protocol UpdateTimer {
   func updateTimer()
}


class CustomizedTimer {
    static let shared = CustomizedTimer()
    private var timer = Timer()
    private init() {}
    var delegate: UpdateTimer? = nil
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateAccordingly), userInfo: nil, repeats: true)
    }
    
    @objc func updateAccordingly() {
        delegate?.updateTimer()
    }
    
    func inavlidate() {
        self.timer.invalidate()
    }
    
    func createATimeString(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}


class ViewController: UIViewController {
    
    private var seconds = 9
    
    @IBOutlet weak var secondLabel1: UILabel!
    @IBOutlet weak var secondLabel2: UILabel!
    
    @IBOutlet weak var gradientView: UIView! {
        didSet {
            gradientView.layer.cornerRadius = 16.0
            gradientView.layer.masksToBounds = true
            gradientLayer = gradientView.setupGradient( [UIColor.white, UIColor.systemBlue, UIColor.systemMint])
            
        }
    }
    
    private var gradientLayer: CAGradientLayer?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gradientLayer?.frame = gradientView.bounds
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CustomizedTimer.shared.delegate = self
        CustomizedTimer.shared.runTimer()
    }


}

extension ViewController: UpdateTimer {
    func updateTimer() {
        
        if seconds < 1 {
            CustomizedTimer.shared.inavlidate()
            return
        }
        secondLabel2.transition(0.4)
        secondLabel2.text = "\(seconds)"
        seconds -= 1
    }
}

extension UIView {
    
    @discardableResult
    func setupGradient(_ colors: [UIColor] ) -> CAGradientLayer {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
    }
}

extension UIView {
    func transition(_ duration: TimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.push
        animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
