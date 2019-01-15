

import UIKit

@IBDesignable public class BrandTextField: UITextField {
    
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
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    
    public func setupLayout() {
        self.borderStyle = .none
        self.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium)
        self.textColor = UIColor.brandBlack
        self.backgroundColor = UIColor.brandBackground
        guard let placeholderText: String = self.placeholder else {
            return
        }
        self.attributedPlaceholder =  NSAttributedString(string: placeholderText,
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandLightGrey])
    }
}
