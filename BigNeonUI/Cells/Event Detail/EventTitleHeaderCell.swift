

import Foundation
import UIKit

final public class EventTitleHeaderCell: UITableViewCell {
    
    public static let cellID = "EventTitleHeaderCellID"
    
    public let presentCell: UILabel = {
        let label = UILabel()
        label.text = "All star promoter events presents"
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let eventDate: EventDateView = {
        let view = EventDateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.accessoryType = .disclosureIndicator
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(presentCell)
        self.addSubview(eventDate)
        
        self.presentCell.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.presentCell.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.presentCell.topAnchor.constraint(equalTo: self.topAnchor, constant: -45).isActive = true
        self.presentCell.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.eventDate.topAnchor.constraint(equalTo: self.topAnchor, constant: 65).isActive = true
        self.eventDate.rightAnchor.constraint(equalTo: presentCell.rightAnchor).isActive = true
        self.eventDate.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.eventDate.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
