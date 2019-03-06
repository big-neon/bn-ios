

import Foundation
import UIKit
import Big_Neon_Core

public class ManualCheckinModeView: UIView {
    
    public var scannedUser: User? {
        didSet {
            guard let user = self.scannedUser else {
                return
            }
            
            print(user)
            
        }
    }
    
    public lazy var completeCheckinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Complete Check-in", for: UIControl.State.normal)
        button.backgroundColor = UIColor.brandPrimary
        button.setTitleColor(UIColor.white, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20.0
        imageView.backgroundColor = UIColor.brandBackground
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Anna Behrensmeyer"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "General Admission"
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14 weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 12.0
        self.layer.shadowColor = UIColor.brandBlack.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
        self.layer.shadowRadius = 16.0
        self.layer.shadowOpacity = 0.32
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(userImageView)
        self.addSubview(userNameLabel)
        self.addSubview(ticketTypeLabel)
        self.addSubview(completeCheckinButton)
        
        userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 22).isActive = true
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 15).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        ticketTypeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2).isActive = true
        ticketTypeLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 15).isActive = true
        ticketTypeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        ticketTypeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        completeCheckinButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        completeCheckinButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        completeCheckinButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        completeCheckinButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
