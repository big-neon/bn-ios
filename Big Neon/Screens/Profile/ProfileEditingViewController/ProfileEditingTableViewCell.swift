


import Foundation
import UIKit

final public class ProfileEditTableCell: UITableViewCell {
    
    public static let cellID = "ProfileEditTableCell"
    
    public let cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let entryTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.brandBlack
        textField.text = "Gugulethu"
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.accessoryType = .none
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(cellLabel)
        self.addSubview(entryTextField)
        
        self.cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.cellLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        self.entryTextField.leftAnchor.constraint(equalTo: cellLabel.rightAnchor, constant: 16).isActive = true
        self.entryTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.entryTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        self.entryTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
