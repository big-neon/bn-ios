
import Foundation
import UIKit

final public class TicketTypeCell: UITableViewCell {
    
    public static let cellID = "TicketTypeCellID"
    
    public var ticketLimit: Int?
    
    public var numberOfTickets: Int = 1 {
        didSet {
            if numberOfTickets == 1 {
                self.numberLabel.text = "\(numberOfTickets)"
                return
            }
            self.numberLabel.text = "\(numberOfTickets)"
            return
        }
    }
    
    public let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandPrimary
        label.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.black)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let ticketTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let ticketTypeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let numberLabel: UILabel = {
        let label = UILabel()
        label.text = "1"
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
        button.setImage(UIImage(named: "ic_subtract"), for: UIControl.State.normal)
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
        self.priceLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.ticketTypeLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 8).isActive = true
        self.ticketTypeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -80).isActive = true
        self.ticketTypeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.ticketTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.ticketTypeDescriptionLabel.topAnchor.constraint(equalTo: ticketTypeLabel.bottomAnchor, constant: 10).isActive = true
        self.ticketTypeDescriptionLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 8).isActive = true
        self.ticketTypeDescriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.ticketTypeDescriptionLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.addTicketButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.addTicketButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        self.addTicketButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.addTicketButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.numberLabel.rightAnchor.constraint(equalTo: addTicketButton.leftAnchor, constant: -16).isActive = true
        self.numberLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.numberLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.subtractTicketButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.subtractTicketButton.rightAnchor.constraint(equalTo: numberLabel.leftAnchor, constant: -16).isActive = true
        self.subtractTicketButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.subtractTicketButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    @objc private func handleAdd() {
        labelShake(labelToAnimate: numberLabel, bounceVelocity: 10.0, springBouncinessEffect: 15.0)
        if let limit = self.ticketLimit {
            if numberOfTickets > limit {
                return
            }
        }
        self.numberOfTickets += 1
    }
    
    @objc private func handleSubtract() {
        labelShake(labelToAnimate: numberLabel, bounceVelocity: 6.0, springBouncinessEffect: 9.0)
        if numberOfTickets == 1 {
            return
        }
        self.numberOfTickets -= 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
