
import Foundation
import UIKit

final public class TicketTypeCell: UITableViewCell {
    
    public static let cellID = "TicketTypeCellID"
    
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
    
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.accessoryType = .disclosureIndicator
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(priceLabel)
        self.addSubview(ticketTypeLabel)
        self.addSubview(ticketTypeDescriptionLabel)
        
        self.priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.priceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.priceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.priceLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.ticketTypeLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 8).isActive = true
        self.ticketTypeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.ticketTypeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.ticketTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        self.ticketTypeDescriptionLabel.topAnchor.constraint(equalTo: ticketTypeLabel.bottomAnchor, constant: 10).isActive = true
        self.ticketTypeDescriptionLabel.leftAnchor.constraint(equalTo: priceLabel.rightAnchor, constant: 8).isActive = true
        self.ticketTypeDescriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.ticketTypeDescriptionLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
