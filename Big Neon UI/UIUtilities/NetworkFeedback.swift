

import UIKit

public class NetworkFeedback: NSObject {
    
    lazy var roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        return view
    }()
    
    lazy var informationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.text = "No Internet Connection"
        return label
    }()
    
    override public init() {
        super.init()
    }
    
    public func showFeedback(currentView: UIView) {
        
        if let window = UIApplication.shared.keyWindow {
            
            /*  Download Popup */
            window.addSubview(roundedView)
            roundedView.frame = CGRect(x: 16, y: -100, width: UIScreen.main.bounds.width - 32.0, height: 32.0)
            roundedView.backgroundColor = .red
            
            /*  Information Label */
            roundedView.addSubview(informationLabel)
            informationLabel.frame = CGRect(x: 16.0, y: 6.0, width: UIScreen.main.bounds.width - 32, height: 20.0)
            
            
            /* Timer to Hide it */
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(dismissConfimationPopup), userInfo: nil, repeats: false)
            
            /* Animate Views In */
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.roundedView.frame = CGRect(x: 16.0, y: 90, width: window.frame.width - 32.0, height: 32.0)
            }, completion: nil)
        }
    }
    
    //  Dismiss View
    @objc private func dismissConfimationPopup() {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 10.0, initialSpringVelocity: 1, options: .curveLinear, animations: {
                if let window = UIApplication.shared.keyWindow {
                    self.roundedView.frame = CGRect(x: 16.0, y: -100, width: window.frame.width - 32.0, height: 32.0)
                }
            }, completion: nil)
        }
        
    }
   
}

