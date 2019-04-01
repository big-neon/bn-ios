
import Foundation
import UIKit

final public class GuestTableViewCell: UITableViewCell {
    
    public static let cellID = "GuestTableViewCellID"
    
    public let guestNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Guest"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let ticketTypeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "General Admission"
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(guestNameLabel)
        self.addSubview(ticketTypeNameLabel)
    
        self.guestNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.guestNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        self.guestNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.guestNameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.ticketTypeNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.ticketTypeNameLabel.topAnchor.constraint(equalTo: guestNameLabel.bottomAnchor, constant: 12).isActive = true
        self.ticketTypeNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.ticketTypeNameLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


