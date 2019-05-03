
import Foundation
import UIKit

// MARK:  magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar

public class EventPriceView: UIView {
    
    // lazy?
    public let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandPrimary
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override func layoutSubviews() {
        self.roundCorners([.topLeft, .topRight, .bottomRight], radius: 5.0)
        self.layer.masksToBounds = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(priceLabel)
    
        priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        priceLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

