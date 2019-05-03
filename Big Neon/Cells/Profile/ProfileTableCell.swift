
import Foundation
import UIKit

// MARK: lots of magic numbers... consider using layout/config class/enum
// MARK: self is not needed
// MARK: use abbreviation / syntax sugar

final public class ProfileTableCell: UITableViewCell {
    
    public static let cellID = "ProfileTabCellID"
    
    public let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_account")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.tintColor = UIColor.brandGrey
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let cellLabel: UILabel = {
        let label = UILabel()
        label.text = "Doorman"
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
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
        self.addSubview(cellImageView)
        self.addSubview(cellLabel)
        
        self.cellImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.cellImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.cellImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.cellImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.cellLabel.leftAnchor.constraint(equalTo: cellImageView.rightAnchor, constant: 16).isActive = true
        self.cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.cellLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        self.cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
