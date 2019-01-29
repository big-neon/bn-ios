

import Foundation
import UIKit

protocol ProfileImageUploadDelegate {
    func uploadImage()
}

final public class ProfileImageUploadCell: UITableViewCell {
    
    public static let cellID = "ProfileImageUploadCellID"
    
    public let cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandPrimary
        label.text = "Change Profile Profile"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
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
        
        self.cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 120).isActive = true
        self.cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.cellLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
