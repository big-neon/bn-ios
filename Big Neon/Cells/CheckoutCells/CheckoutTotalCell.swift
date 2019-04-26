

import Foundation
import UIKit

// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar


final public class CheckoutTotalCell: UITableViewCell {
    
    public static let cellID = "CheckoutTotalCellID"
    
    // lazy? 
    public let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // lazy?
    public let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "$35.00 USD"
        label.textAlignment = .right
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
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
        self.addSubview(totalLabel)
        self.addSubview(amountLabel)
        
        self.totalLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.totalLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.totalLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.totalLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.amountLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.amountLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.amountLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.amountLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
