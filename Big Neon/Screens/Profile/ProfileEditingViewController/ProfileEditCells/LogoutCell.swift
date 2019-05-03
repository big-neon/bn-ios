

import Foundation
import UIKit

// MARK:  magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar


final public class LogoutCell: UITableViewCell {
    
    public static let cellID = "LogoutCellID"
    
    // lazy?
    public let cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandPrimary
        label.textAlignment = .center
        label.text = "Logout"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
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
        self.addSubview(cellLabel)
        
        self.cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.cellLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
