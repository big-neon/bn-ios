


import Foundation
import UIKit

final public class SubTotalCell: UITableViewCell {
    
    public static let cellID = "SubTotalCellID"
    
    public let subtotalLabel: UILabel = {
        let label = UILabel()
        label.text = "Sub Total"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let feesLabel: UILabel = {
        let label = UILabel()
        label.text = "Fees"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let codeAppliedLabel: UILabel = {
        let label = UILabel()
        label.text = "Code Applied"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let subTotalAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "$30.00 USD"
        label.textColor = UIColor.brandGrey
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let feesAmountLabel: UILabel = {
        let label = UILabel()
        label.text = "$5.00 USD"
        label.textColor = UIColor.brandGrey
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "NDLKEHDI"
        label.textColor = UIColor.brandPrimary
        label.textAlignment = .right
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
        self.addSubview(subtotalLabel)
        self.addSubview(feesLabel)
        self.addSubview(codeAppliedLabel)
        self.addSubview(subTotalAmountLabel)
        self.addSubview(feesAmountLabel)
        self.addSubview(codeLabel)
        
        self.subtotalLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.subtotalLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.subtotalLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.subtotalLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.subTotalAmountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.subTotalAmountLabel.centerYAnchor.constraint(equalTo: subtotalLabel.centerYAnchor).isActive = true
        self.subTotalAmountLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.subTotalAmountLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.feesLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.feesLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.feesLabel.topAnchor.constraint(equalTo: subtotalLabel.bottomAnchor, constant: 6).isActive = true
        self.feesLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.feesAmountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.feesAmountLabel.centerYAnchor.constraint(equalTo: feesLabel.centerYAnchor).isActive = true
        self.feesAmountLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.feesAmountLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        self.codeAppliedLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.codeAppliedLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.codeAppliedLabel.topAnchor.constraint(equalTo: feesLabel.bottomAnchor, constant: 6).isActive = true
        self.codeAppliedLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.codeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.codeLabel.centerYAnchor.constraint(equalTo: codeAppliedLabel.centerYAnchor).isActive = true
        self.codeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.codeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
