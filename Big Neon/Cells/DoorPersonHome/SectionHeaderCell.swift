
import Foundation
import UIKit
import Big_Neon_Core
import PINRemoteImage

public class SectionHeaderCell: UICollectionViewCell {
    
    public static let cellID = "SectionHeaderCellID"
    weak var delegate: DoorPersonViewDelegate?
    
    var user: User? {
        didSet {
            if let profilePicURL = user?.profilePicURL   {
                userImageView.pin_setImage(from: URL(string: profilePicURL), placeholderImage: UIImage(named: "ic_profilePicture"))
            } else {
                userImageView.pin_setPlaceholder(with: UIImage(named: "ic_profilePicture"))
            }
        }
    }
    
    lazy var sectionHeaderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.text = "My Events"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowProfile)))
        imageView.layer.cornerRadius = 16.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.brandBackground
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(sectionHeaderLabel)
        self.addSubview(userImageView)
        self.addSubview(detailLabel)
        
        userImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        userImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 32.0).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 32.0).isActive = true

        sectionHeaderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        sectionHeaderLabel.rightAnchor.constraint(equalTo: userImageView.leftAnchor, constant: -20).isActive = true
        sectionHeaderLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor).isActive = true
        sectionHeaderLabel.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
        
        detailLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0).isActive = true
        detailLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
    }
    
    @objc private func handleShowProfile() {
        self.delegate?.handleShowProfile()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
