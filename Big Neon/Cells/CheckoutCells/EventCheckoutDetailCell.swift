
import Foundation
import UIKit


// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar


final public class EventCheckoutDetailCell: UITableViewCell {
    
    public static let cellID = "EventCheckoutDetailCellID"
    
    // lazy?
    public let eventLabel: UILabel = {
        let label = UILabel()
        label.text = "Taylor Swift"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // lazy?
    
    public let eventDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "Fri, July 20 - 8:50 pm - The Warfield"
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.accessoryType = .none
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(eventLabel)
        self.addSubview(eventDetailLabel)
        
        self.eventLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.eventLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.eventLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.eventLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.eventDetailLabel.topAnchor.constraint(equalTo: eventLabel.bottomAnchor, constant: 10).isActive = true
        self.eventDetailLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.eventDetailLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.eventDetailLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
