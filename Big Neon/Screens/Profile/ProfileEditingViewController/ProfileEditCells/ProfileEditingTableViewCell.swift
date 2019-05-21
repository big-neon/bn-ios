


import Foundation
import UIKit

final public class ProfileEditTableCell: UITableViewCell {
    
    public static let cellID = "ProfileEditTableCell"
    
    public lazy var cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var entryTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.brandBlack
        textField.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.semibold)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.white
        accessoryType = .none
        configureView()
    }
    
    private func configureView() {
        addSubview(cellLabel)
        addSubview(entryTextField)
        
        cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        cellLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        entryTextField.leftAnchor.constraint(equalTo: cellLabel.rightAnchor, constant: 16).isActive = true
        entryTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        entryTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        entryTextField.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
