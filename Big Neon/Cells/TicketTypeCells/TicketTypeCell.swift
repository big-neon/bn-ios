

import Foundation
import UIKit
import Big_Neon_Core
import Big_Neon_UI

// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar
// MARK: internal is default access level - not need for explicit definition

public protocol TicketTypeDelegate {
    func addTicketType(ticketType: TicketType, numberOfTickets: Int)
}

final public class TicketTypeCell: UITableViewCell {
    
    // MARK: delegate should be weak
    public var delegate: TicketTypeDelegate?
    
    public static let cellID = "TicketTypeCellID"
    
    public var numberOfTickets: Int = 0 {
        didSet {
            self.numberLabel.text = "\(numberOfTickets)"
            
            // MARK: this can be replaced with guard statement
            if numberOfTickets == 0 {
                self.subtractTicketButton.setImage(UIImage(named: "ic_subtract_disabled"), for: UIControl.State.normal)
            }
            return
        }
    }
    
    public var ticketType: TicketType? {
        didSet {
            // MARK: ticketType.ticketPricing should be in  guard also
            guard let ticketType = self.ticketType else {
                return
            }
            
            if ticketType.name != ticketType.ticketPricing?.name {
                self.ticketTypeLabel.text = ticketType.name
            } else {
                self.ticketTypeLabel.text = ticketType.ticketPricing?.name
            }
            
        }
    }
    
    public var ticketTypeStatus: String? {
        didSet {
            // MARK: ticketType and ticketType.ticketPricing should be in  guard also
            // do not use explicite unwraping
            guard let status = self.ticketTypeStatus else {
                return
            }
            
            switch status {
            case "NoActivePricing":
                self.priceLabel.text = "$0"
                self.ticketTypeDescriptionLabel.text = "Not Available"
                self.numberLabel.isHidden           = true
                self.addTicketButton.isHidden       = true
                self.subtractTicketButton.isHidden  = true
                return
            case "Cancelled":
                self.priceLabel.text = "$0"
                self.ticketTypeDescriptionLabel.text = "Cancelled"
                self.numberLabel.isHidden           = true
                self.addTicketButton.isHidden       = true
                self.subtractTicketButton.isHidden  = true
                return
            case "Published":
                self.priceLabel.text = self.ticketType!.ticketPricing?.priceInCents.dollarString
                self.numberLabel.isHidden           = false
                self.addTicketButton.isHidden       = false
                self.subtractTicketButton.isHidden  = false
                
                self.ticketTypeDescriptionLabel.text = self.ticketType!.ticketPricing?.status
                return
            case "SoldOut":
                self.priceLabel.text = self.ticketType!.ticketPricing?.priceInCents.dollarString
                self.ticketTypeDescriptionLabel.text = "SOLD OUT"
                self.numberLabel.isHidden           = true
                self.addTicketButton.isHidden       = true
                self.subtractTicketButton.isHidden  = true
                return
            default:
                print("Default Ticket Type")
            }
            
        }
    }
    
    // lazy?
    public let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandPrimary
        label.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // lazy?
    public let ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // lazy?
    public let ticketTypeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // lazy?
    public let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = UIColor.brandBlack
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var addTicketButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleAdd), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: "ic_add"), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    internal lazy var subtractTicketButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(handleSubtract), for: UIControl.Event.touchUpInside)
        button.setImage(UIImage(named: "ic_subtract_disabled"), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.accessoryType = .none
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(priceLabel)
        self.addSubview(ticketTypeLabel)
        self.addSubview(ticketTypeDescriptionLabel)
        
        self.addSubview(addTicketButton)
        self.addSubview(numberLabel)
        self.addSubview(subtractTicketButton)
        
        self.priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.priceLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.ticketTypeLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 4).isActive = true
        self.ticketTypeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -120).isActive = true
        self.ticketTypeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.ticketTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.ticketTypeDescriptionLabel.topAnchor.constraint(equalTo: ticketTypeLabel.bottomAnchor, constant: 10).isActive = true
        self.ticketTypeDescriptionLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 4).isActive = true
        self.ticketTypeDescriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.ticketTypeDescriptionLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.addTicketButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.addTicketButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        self.addTicketButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.addTicketButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.numberLabel.rightAnchor.constraint(equalTo: addTicketButton.leftAnchor, constant: -10).isActive = true
        self.numberLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.numberLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.subtractTicketButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.subtractTicketButton.rightAnchor.constraint(equalTo: numberLabel.leftAnchor, constant: -10).isActive = true
        self.subtractTicketButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.subtractTicketButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    @objc private func handleAdd() {
        labelShake(labelToAnimate: numberLabel, bounceVelocity: 10.0, springBouncinessEffect: 15.0)
        self.subtractTicketButton.setImage(UIImage(named: "ic_subtract"), for: UIControl.State.normal)
        // guard?
        if let limit = self.ticketType?.limitPerPerson {
            if numberOfTickets == limit {
                self.addTicketButton.setImage(UIImage(named: "ic_add_disabled"), for: UIControl.State.normal)
                return
            }
        }
        // MARK: ticketType should be in  guard also
        // do not use explicite unwraping
        self.numberOfTickets += 1
        self.delegate?.addTicketType(ticketType: self.ticketType!, numberOfTickets: self.numberOfTickets)
    }
    
    @objc private func handleSubtract() {
        labelShake(labelToAnimate: numberLabel, bounceVelocity: 6.0, springBouncinessEffect: 9.0)
        self.addTicketButton.isEnabled = true
        self.addTicketButton.setImage(UIImage(named: "ic_add"), for: UIControl.State.normal)
        // guard
        if numberOfTickets == 0 {
            self.subtractTicketButton.setImage(UIImage(named: "ic_subtract_disabled"), for: UIControl.State.normal)
            return
        }
        // MARK: ticketType should be in  guard also
        // do not use explicite unwraping
        self.numberOfTickets -= 1
        self.delegate?.addTicketType(ticketType: self.ticketType!, numberOfTickets: self.numberOfTickets)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
