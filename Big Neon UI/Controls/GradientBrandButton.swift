
import Foundation
import UIKit

public class GradientBrandButton: UIButton {
    
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
        self.backgroundColor = UIColor.brandPrimary
        self.layer.cornerRadius = 4.0
        self.layer.masksToBounds = true
        self.setTitleColor(UIColor.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.semibold)
    }
}
