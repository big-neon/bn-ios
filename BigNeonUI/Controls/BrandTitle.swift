
import Foundation
import UIKit

@IBDesignable public class BrandTitleLabel: UILabel {
    
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
        self.textColor = UIColor.brandBlack
        self.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        self.configureLineSpacing()
    }
    
    private func configureLineSpacing() {
        guard let text = self.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 24.0
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}

