

import Foundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core

public class ManualCheckinModeView: UIView {
    
    weak var delegate: ScannerViewDelegate?
    var event: EventsData?
    
    var redeemableTicket: RedeemableTicket? {
        didSet {
            guard let ticket = self.redeemableTicket else {
                return
            }
            
            self.userNameLabel.text = ticket.firstName
            self.ticketTypeLabel.text = ticket.eventName
            let price = Int(ticket.priceInCents)
            let ticketID = "#" + ticket.id.suffix(8).uppercased()
            dateValueLabel.text = price.dollarString + " | " + ticket.ticketType + " | " + ticketID
            
            if self.event?.name != ticket.eventName {
                bannedTagView.isHidden = false
                bannedTagView.backgroundColor = UIColor.brandError
                bannedTagView.tagLabel.text = "WRONG EVENT"
                completeCheckinButton.backgroundColor = .brandBlack
                completeCheckinButton.setTitle("Ok", for: UIControl.State.normal)
                completeCheckinButton.addTarget(self, action: #selector(cancelChecking), for: UIControl.Event.touchUpInside)
                return
            }
            
            
            if ticket.status == TicketStatus.purchased.rawValue {
                bannedTagView.isHidden = false
                bannedTagView.backgroundColor = UIColor.brandGreen
                bannedTagView.tagLabel.text = "PURCHASED"
                completeCheckinButton.backgroundColor = .brandPrimary
                completeCheckinButton.setTitle("Complete Check-in", for: UIControl.State.normal)
                completeCheckinButton.addTarget(self, action: #selector(handleCompleteCheckin), for: UIControl.Event.touchUpInside)
                
            } else {
                bannedTagView.isHidden = true
                completeCheckinButton.backgroundColor = .brandBlack
                completeCheckinButton.setTitle("Already Redeemed", for: UIControl.State.normal)
                completeCheckinButton.addTarget(self, action: #selector(doNothing), for: UIControl.Event.touchUpInside)
                
                if let redemeedBy = ticket.redeemedBy {
                  redeemedByLabel.text = redemeedBy
                }
                
                ticketTypeLabel.text = price.dollarString + " | " + ticket.ticketType + " | " + ticketID
                
                guard let timezone = event?.venue, let redeemDate = ticket.redeemedAt else {
                    dateValueLabel.text = "No Date Captured"
                    return
                }
                
                guard let redeemedDate = DateConfig.formatServerDate(date: redeemDate, timeZone: timezone.timezone!) else {
                    dateValueLabel.text = "No Date Captured"
                    return
                }
                
                dateValueLabel.text = "Redeemed: " + redeemedDate.getElapsed() //"On: " + DateConfig.fullDateFormat(date: redeemedDate)
            }
            
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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var vipTagView: CheckinTagView = {
        let view = CheckinTagView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var redeemedByLabel: UILabel = {
        let label = UILabel()
        label.text = "Event Details"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateValueLabel: UILabel = {
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
        addSubview(redeemedByLabel)
        addSubview(dateValueLabel)
        addSubview(completeCheckinButton)
        
        
        vipTagView.isHidden = true
        
        //  Top Area
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
        userNameLabel.rightAnchor.constraint(equalTo: dismissView.leftAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        ticketTypeLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2).isActive = true
        ticketTypeLabel.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor).isActive = true
        ticketTypeLabel.rightAnchor.constraint(equalTo: userNameLabel.rightAnchor).isActive = true
        ticketTypeLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        lineView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 16).isActive = true
        lineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 0.9).isActive = true
        
        //  Tags
        bannedTagView.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 28).isActive = true
        bannedTagView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        bannedTagView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        bannedTagView.widthAnchor.constraint(equalToConstant: 88.0).isActive = true
        
        vipTagView.centerYAnchor.constraint(equalTo: bannedTagView.centerYAnchor).isActive = true
        vipTagView.rightAnchor.constraint(equalTo: bannedTagView.leftAnchor, constant: -10.0).isActive = true
        vipTagView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        vipTagView.widthAnchor.constraint(equalToConstant: 55.0).isActive = true
        
        
        //  Redeeemed By
        redeemedByLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 20).isActive = true
        redeemedByLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0).isActive = true
        redeemedByLabel.rightAnchor.constraint(equalTo: bannedTagView.leftAnchor, constant: -16).isActive = true
        redeemedByLabel.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        
        dateValueLabel.topAnchor.constraint(equalTo: redeemedByLabel.bottomAnchor, constant: 2.0).isActive = true
        dateValueLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20.0).isActive = true
        dateValueLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        dateValueLabel.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        
        //  Completed
        completeCheckinButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        completeCheckinButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        completeCheckinButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        completeCheckinButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func handleCompleteCheckin() {
        self.delegate?.completeCheckin()
    }
    
    @objc func doNothing() {
        print("Already Redeemed")
    }
    
    @objc private func cancelChecking() {
        self.delegate?.dismissScannedUserView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
