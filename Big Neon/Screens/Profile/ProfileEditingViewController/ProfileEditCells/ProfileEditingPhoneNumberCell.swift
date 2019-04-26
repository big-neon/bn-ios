
import Foundation
import UIKit
import PhoneNumberKit
import Big_Neon_UI

// MARK:  magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar

// MARK: check imports... do we need them all?

final public class ProfileEditPhoneNumberTableCell: UITableViewCell {
    
    public static let cellID = "ProfileEditPhoneNumberTableCellID"
    
    // lazy?
    public let cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // lazy?
    public let entryTextField: PhoneNumberTextField = {
        let textField = PhoneNumberTextField()
        textField.borderStyle = .none
        textField.maxDigits = 11
        textField.keyboardType = .phonePad
        textField.textColor = UIColor.brandBlack
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
        self.entryTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        self.entryTextField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.entryTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
