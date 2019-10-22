

import Foundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core
import TransitionButton

final class EventGuestsCell: SwipeTableViewCell {
    
    static let cellID = "EventGuestsCellID"
    
    var guest: GuestData? {
        didSet {
            guard let guestValues = self.guest else {
                return
            }
            
            if guestValues.last_name == "" && guestValues.first_name  == ""{
                guestNameLabel.text = "No Details Provided"
            } else {
                if let firstName = guestValues.first_name, let lastName = guestValues.last_name {
                    guestNameLabel.text = firstName + " " + lastName
                } else {
                    guestNameLabel.text = ""
                }
                
            }
            
            
            let price = Int(guestValues.price_in_cents)
            let ticketID = "#" + guestValues.id!.suffix(8).uppercased()
            ticketTypeNameLabel.text = price.dollarString + " | " + guestValues.ticket_type! + " | " + ticketID
            
            if guestValues.status == TicketStatus.purchased.rawValue {
                ticketStateView.isHidden = !DateConfig.eventDateIsToday(eventStartDate: guestValues.event_start!)
                ticketStateView.backgroundColor = UIColor.brandGreen
                let buttonValue = DateConfig.eventDateIsToday(eventStartDate: guestValues.event_start!) == true ? "PURCHASED" : "-"
                ticketStateView.setTitle(buttonValue, for: UIControl.State.normal)
            } else {
                ticketStateView.isHidden = !DateConfig.eventDateIsToday(eventStartDate: guestValues.event_start!) //== true ? false : UIColor.white
                ticketStateView.backgroundColor = UIColor.brandBlack
                let buttonValue = DateConfig.eventDateIsToday(eventStartDate: guestValues.event_start!) == true ? "REDEEMED" : "-"
                ticketStateView.setTitle(buttonValue, for: UIControl.State.normal)
            }
        }
    }
    
    var isLoadingCell: Bool = false {
        didSet {
            if isLoadingCell == true {
                loadingView.startAnimating()
                guestNameLabel.isHidden = true
                ticketTypeNameLabel.isHidden = true
                ticketStateView.isHidden = true
            } else {
                loadingView.stopAnimating()
                guestNameLabel.isHidden = false
                ticketTypeNameLabel.isHidden = false
                ticketStateView.isHidden = false
            }
        }
    }
    
    let loadingView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.style = UIActivityIndicatorView.Style.gray
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()

    lazy var guestNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ticketTypeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ticketStateView: TransitionButton = {
        let button = TransitionButton()
        button.layer.cornerRadius = 4.0
        button.setTitleColor(UIColor.brandWhite, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.bold)
        button.backgroundColor = UIColor.brandBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        configureView()
    }
    
    private func configureView() {
        loadingView.stopAnimating()
        contentView.addSubview(loadingView)
        contentView.addSubview(ticketStateView)
        contentView.addSubview(guestNameLabel)
        contentView.addSubview(ticketTypeNameLabel)
        
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        loadingView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        ticketStateView.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutSpec.Spacing.twentyFour).isActive = true
        ticketStateView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        ticketStateView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
        ticketStateView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
    
        guestNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        guestNameLabel.centerYAnchor.constraint(equalTo: ticketStateView.centerYAnchor).isActive = true
        guestNameLabel.rightAnchor.constraint(equalTo: ticketStateView.leftAnchor, constant: -30).isActive = true
        guestNameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        ticketTypeNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        ticketTypeNameLabel.topAnchor.constraint(equalTo: guestNameLabel.bottomAnchor, constant: 8).isActive = true
        ticketTypeNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        ticketTypeNameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
