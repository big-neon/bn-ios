
import Foundation
import UIKit
import Big_Neon_UI
import TransitionButton

final class GuestTableViewCell: SwipeTableViewCell {
    
    static let cellID = "GuestTableViewCellID"

    lazy var guestNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ticketTypeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
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
        contentView.addSubview(ticketStateView)
        contentView.addSubview(guestNameLabel)
        contentView.addSubview(ticketTypeNameLabel)
        
        ticketStateView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        ticketStateView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        ticketStateView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        ticketStateView.widthAnchor.constraint(equalToConstant: 88.0).isActive = true
    
        guestNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        guestNameLabel.centerYAnchor.constraint(equalTo: ticketStateView.centerYAnchor).isActive = true
        guestNameLabel.rightAnchor.constraint(equalTo: ticketStateView.leftAnchor, constant: -30).isActive = true
        guestNameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        ticketTypeNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        ticketTypeNameLabel.topAnchor.constraint(equalTo: guestNameLabel.bottomAnchor, constant: 12).isActive = true
        ticketTypeNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        ticketTypeNameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}