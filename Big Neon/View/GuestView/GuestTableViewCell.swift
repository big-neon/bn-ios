
import Foundation
import UIKit

final public class GuestTableViewCell: UITableViewCell {
    
    public static let cellID = "GuestTableViewCellID"
    
    public let guestNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let ticketTypeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let ticketStateView: CheckinTagView = {
        let view = CheckinTagView()
        view.backgroundColor = UIColor.brandBlack
        view.tagLabel.text = "REDEEMED".uppercased()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(guestNameLabel)
        self.addSubview(ticketTypeNameLabel)
        self.addSubview(ticketStateView)
    
        self.guestNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.guestNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        self.guestNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.guestNameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.ticketTypeNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.ticketTypeNameLabel.topAnchor.constraint(equalTo: guestNameLabel.bottomAnchor, constant: 12).isActive = true
        self.ticketTypeNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.ticketTypeNameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        self.ticketStateView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.ticketStateView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.ticketStateView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        self.ticketStateView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


