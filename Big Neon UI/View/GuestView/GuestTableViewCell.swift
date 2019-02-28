
import Foundation
import UIKit

final public class GuestTableViewCell: UITableViewCell {
    
    public static let cellID = "GuestTableViewCellID"
    
    public let cellLabel: UILabel = {
        let label = UILabel()
        label.text = "Something"
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.red
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(cellLabel)
    
        self.cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.cellLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


