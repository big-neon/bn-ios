

import Foundation
import UIKit
//import BigNeonCore

final public class EventDetailCell: UITableViewCell {
    
    public static let cellID = "EventDetailCellID"
    
    public let headerIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.brandMediumGrey
        textView.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.accessoryType = .none
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(headerIconImageView)
        self.addSubview(headerLabel)
        self.addSubview(descriptionTextView)
        
        self.headerIconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        self.headerIconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.headerIconImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.headerIconImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        self.headerLabel.leftAnchor.constraint(equalTo: headerIconImageView.rightAnchor, constant: 10).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.headerLabel.centerYAnchor.constraint(equalTo: headerIconImageView.centerYAnchor).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        self.descriptionTextView.topAnchor.constraint(equalTo: headerLabel.topAnchor, constant: 16).isActive = true
        self.descriptionTextView.leftAnchor.constraint(equalTo: headerLabel.leftAnchor).isActive = true
        self.descriptionTextView.rightAnchor.constraint(equalTo: headerLabel.rightAnchor).isActive = true
        self.descriptionTextView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
