
import Foundation
import UIKit
import DTGradientButton
import TransitionButton

public class BrandButton: TransitionButton {
    
    public var addGradient = true
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupLayout()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func setupLayout() {
        self.layer.cornerRadius = 6.0
        self.layer.masksToBounds = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
        if addGradient == true {
          self.configureGradient()
        }
        
    }
    
    func configureGradient() {
        let colors = [UIColor(red: 229/255, green: 61/255, blue: 150/255, alpha: 1.0),
                      UIColor(red: 161/255, green: 100/255, blue: 175/255, alpha: 1.0),
                      UIColor(red: 84/255, green: 145/255, blue: 204/255, alpha: 1.0)]
        self.setGradientBackgroundColors(colors, direction: .toLeft, for: .normal)
    }
}
