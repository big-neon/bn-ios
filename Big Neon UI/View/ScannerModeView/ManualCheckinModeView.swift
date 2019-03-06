

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
        button.setTitleColor(UIColor.brandWhite, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30.0
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
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brandGrey.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bannedTagView: CheckinTagView = {
        let view = CheckinTagView()
        view.backgroundColor = UIColor.red
        view.tagLabel.text = "BANNED".uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let vipTagView: CheckinTagView = {
        let view = CheckinTagView()
        view.tagLabel.text = "VIP".uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Birth Date"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let birthValueLabel: UILabel = {
        let label = UILabel()
        label.text = "9/21/86"
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
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
        self.addSubview(lineView)
        self.addSubview(bannedTagView)
        self.addSubview(vipTagView)
        self.addSubview(birthDateLabel)
        self.addSubview(birthValueLabel)
        self.addSubview(completeCheckinButton)
        
        userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 22).isActive = true
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        userNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 15).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        ticketTypeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2).isActive = true
        ticketTypeLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 15).isActive = true
        ticketTypeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        ticketTypeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        lineView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 16).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.9).isActive = true
        
        bannedTagView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 28).isActive = true
        bannedTagView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        bannedTagView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        bannedTagView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        vipTagView.centerYAnchor.constraint(equalTo: bannedTagView.centerYAnchor).isActive = true
        vipTagView.rightAnchor.constraint(equalTo: bannedTagView.leftAnchor, constant: -10.0).isActive = true
        vipTagView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        vipTagView.widthAnchor.constraint(equalToConstant: 55.0).isActive = true
        
        birthDateLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20).isActive = true
        birthDateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0).isActive = true
        birthDateLabel.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        birthDateLabel.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        birthValueLabel.topAnchor.constraint(equalTo: birthDateLabel.bottomAnchor, constant: 2.0).isActive = true
        birthValueLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0).isActive = true
        birthValueLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        birthValueLabel.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        completeCheckinButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        completeCheckinButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        completeCheckinButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        completeCheckinButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
