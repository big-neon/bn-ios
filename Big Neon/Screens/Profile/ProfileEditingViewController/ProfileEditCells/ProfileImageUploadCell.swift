

import Foundation
import UIKit

public protocol ProfileImageUploadDelegate {
    func uploadImage()
}

final public class ProfileImageUploadCell: UITableViewCell {
    
    public static let cellID = "ProfileImageUploadCellID"
    public var delegate: ProfileImageUploadDelegate?
    
    internal lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadImage)))
        imageView.backgroundColor = UIColor.brandBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        self.addSubview(userImageView)
        self.addSubview(cellLabel)
        
        self.userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.userImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.userImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 100).isActive = true
        self.cellLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.cellLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.cellLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc private func handleUploadImage() {
        self.delegate?.uploadImage()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
