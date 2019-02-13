

import Foundation
import UIKit

final public class QuantitySelectionCell: UITableViewCell {
    
    public static let cellID = "QuantitySelectionCellID"
    
   public let quantityTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Quantity"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let numberOfTicketsLabel: UILabel = {
        let label = UILabel()
        label.text = "1 Ticket"
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.accessoryType = .disclosureIndicator
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(quantityTypeLabel)
        self.addSubview(numberOfTicketsLabel)
        
        self.quantityTypeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.quantityTypeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.quantityTypeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.quantityTypeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.numberOfTicketsLabel.topAnchor.constraint(equalTo: quantityTypeLabel.bottomAnchor, constant: 10).isActive = true
        self.numberOfTicketsLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.numberOfTicketsLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.numberOfTicketsLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
