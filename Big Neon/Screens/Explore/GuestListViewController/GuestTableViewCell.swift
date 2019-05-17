
import Foundation
import UIKit

final public class GuestTableViewCell: UITableViewCell {
    
    public static let cellID = "GuestTableViewCellID"
    
    public lazy var guestNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var ticketTypeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var ticketStateView: CheckinTagView = {
        let view = CheckinTagView()
        view.backgroundColor = UIColor.brandBlack
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        configureView()
    }
    
    private func configureView() {
        addSubview(guestNameLabel)
        addSubview(ticketTypeNameLabel)
        addSubview(ticketStateView)
    
        guestNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        guestNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        guestNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        guestNameLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        ticketTypeNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        ticketTypeNameLabel.topAnchor.constraint(equalTo: guestNameLabel.bottomAnchor, constant: 12).isActive = true
        ticketTypeNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        ticketTypeNameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        ticketStateView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        ticketStateView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        ticketStateView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        ticketStateView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
