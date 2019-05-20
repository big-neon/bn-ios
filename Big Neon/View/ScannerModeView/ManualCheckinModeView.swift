

import Foundation
import UIKit
import Big_Neon_Core

// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: internal is default access level - not need for explicit definition
// MARK: use abbreviation / syntax sugar

public class ManualCheckinModeView: UIView {
    
    weak var delegate: ScannerViewDelegate?
    
    var redeemableTicket: RedeemableTicket? {
        didSet {
            guard let ticket = self.redeemableTicket else {
                return
            }
            
            self.userNameLabel.text = ticket.firstName
            self.ticketTypeLabel.text = ticket.eventName
            
            if ticket.status == TicketStatus.purchased.rawValue {
                bannedTagView.backgroundColor = UIColor.brandGreen
                bannedTagView.tagLabel.text = "PURCHASED"
                completeCheckinButton.backgroundColor = .brandPrimary
                completeCheckinButton.setTitle("Complete Check-in", for: UIControl.State.normal)
                completeCheckinButton.addTarget(self, action: #selector(handleCompleteCheckin), for: UIControl.Event.touchUpInside)
            } else {
                bannedTagView.backgroundColor = UIColor.brandBlack
                bannedTagView.tagLabel.text = "REDEEMED"
                completeCheckinButton.backgroundColor = .brandBlack
                completeCheckinButton.setTitle("Already Redemeemed", for: UIControl.State.normal)
                completeCheckinButton.addTarget(self, action: #selector(cancelChecking), for: UIControl.Event.touchUpInside)
            }
            
            let price = Int(ticket.priceInCents)
            let ticketID = "#" + ticket.id.suffix(8).uppercased()
            birthValueLabel.text = price.dollarString + " | " + ticket.ticketType + " | " + ticketID
            
        }
    }
    
    lazy var completeCheckinButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.brandWhite, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var dismissView: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cancelChecking), for: UIControl.Event.touchUpInside)
        button.setImage(#imageLiteral(resourceName: "ic_dismissButton").withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
        button.tintColor = UIColor.brandGrey
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
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
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brandGrey.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var bannedTagView: CheckinTagView = {
        let view = CheckinTagView()
        view.backgroundColor = UIColor.red
        view.tagLabel.text = "BANNED".uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var vipTagView: CheckinTagView = {
        let view = CheckinTagView()
        view.tagLabel.text = "VIP".uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Event Details"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var birthValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
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
        addSubview(userImageView)
        addSubview(dismissView)
        addSubview(userNameLabel)
        addSubview(ticketTypeLabel)
        addSubview(lineView)
        addSubview(bannedTagView)
        addSubview(vipTagView)
        addSubview(birthDateLabel)
        addSubview(birthValueLabel)
        addSubview(completeCheckinButton)
        
        
        vipTagView.isHidden = true
        
        userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 22).isActive = true
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        dismissView.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        dismissView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        dismissView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
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
        birthDateLabel.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        
        birthValueLabel.topAnchor.constraint(equalTo: birthDateLabel.bottomAnchor, constant: 2.0).isActive = true
        birthValueLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0).isActive = true
        birthValueLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        birthValueLabel.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        
        completeCheckinButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        completeCheckinButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        completeCheckinButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        completeCheckinButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func handleCompleteCheckin() {
        self.delegate?.completeCheckin()
    }
    
    @objc private func cancelChecking() {
        self.delegate?.dismissScannedUserView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
