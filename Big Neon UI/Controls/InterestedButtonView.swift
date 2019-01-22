

import Foundation
import UIKit

public class InterestedButtonView: UIView {
    
    public let buttonLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let buttonIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 6.0
        self.layer.borderColor = UIColor.brandMediumGrey.withAlphaComponent(0.6).cgColor
        self.layer.borderWidth = 1.0
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(buttonLabel)
        self.addSubview(buttonIconView)
        
        buttonIconView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 28).isActive = true
        buttonIconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonIconView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        buttonIconView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        buttonLabel.leftAnchor.constraint(equalTo: buttonIconView.rightAnchor, constant: 5).isActive = true
        buttonLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        buttonLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
        buttonLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
