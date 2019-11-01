import UIKit

public class FeedbackSystem: NSObject {
    
    // lazy?
    public let gradientBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.masksToBounds = true
        return view
    }()
    
    // lazy?
    public let roundedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15.0
        view.layer.masksToBounds = true
        return view
    }()
    
    // lazy?
    public let informationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.numberOfLines = 2
        label.textColor = UIColor.white
        return label
    }()
    
    override public init() {
        super.init()
    }
    
    public func showFeedback(backgroundColor: UIColor, feedbackLabel: String, feedbackLabelColor: UIColor, durationOnScreen: Double, currentView: UIView, showsBackgroundGradient: Bool, isAboveTabBar: Bool) {
        
        if let window = UIApplication.shared.keyWindow {
            //  Gradient Background
            gradientBackground.backgroundColor = UIColor.clear
            gradientBackground.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 145)
            
            //  Show Gradient if true
            if showsBackgroundGradient == true {
                self.backgroundGradientLayer(view: gradientBackground, overLayView: currentView)
            }
            
            gradientBackground.layer.masksToBounds = true
            window.addSubview(gradientBackground)
            
            //  Download Popup
            gradientBackground.addSubview(roundedView)
            roundedView.frame = CGRect(x: 16, y: 34, width: UIScreen.main.bounds.width - 32.0, height: 64.0)
            roundedView.backgroundColor = backgroundColor
            
            //    Information Label
            roundedView.addSubview(informationLabel)
            informationLabel.frame = CGRect(x: 24, y: 17, width: UIScreen.main.bounds.width - 100, height: 30)
            informationLabel.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 100, height: 50))
            informationLabel.text = feedbackLabel
            informationLabel.textColor = feedbackLabelColor
            
            //  #### Timer to Hide it
            Timer.scheduledTimer(timeInterval: durationOnScreen, target: self, selector: #selector(dismissConfimationPopup), userInfo: nil, repeats: false)
            
            //  #### Animate Views In
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                if isAboveTabBar == true {
                    self.gradientBackground.frame = CGRect(x: 0, y: window.frame.height - 144 - 49, width: window.frame.width, height: 144)
                } else {
                    self.gradientBackground.frame = CGRect(x: 0, y: window.frame.height - 144, width: window.frame.width, height: 144)
                }
            }, completion: nil)
        }
    }
    
    //  Dismiss View
    @objc private func dismissConfimationPopup() {
        // MARK: we want it on main thread
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 10.0, initialSpringVelocity: 1, options: .curveLinear, animations: {
            if let window = UIApplication.shared.keyWindow {
                self.gradientBackground.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 144)
            }
        }, completion: nil)
    }
    
    //  Gradient
    private func backgroundGradientLayer(view: UIView, overLayView: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = overLayView.frame
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        let colors: [CGColor] = [UIColor(white: 1, alpha: 0.0).cgColor, UIColor(white: 1, alpha: 0.64).cgColor, UIColor(white: 1, alpha: 0.88).cgColor]
        let location = [0.0, 0.05, 1.0]
        gradient.colors = colors
        gradient.isOpaque = true
        gradient.locations = location as [NSNumber]
        view.layer.addSublayer(gradient)
    }
}
