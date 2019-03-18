

import UIKit

public class LastScannedUserView: UIView {
    
    public let userLabel: UILabel = {
        let label = UILabel()
        label.text = "BANNED".uppercased()
        label.textColor = UIColor.brandWhite
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.brandPrimary
        self.configureView()
    }
    
    public override func layoutSubviews() {
        self.roundCorners([UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], radius: 8.0)
    }
    
    private func configureView() {
        self.addSubview(userLabel)
        
        userLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        userLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
