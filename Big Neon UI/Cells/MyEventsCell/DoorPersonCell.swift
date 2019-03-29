

import Foundation
import UIKit
import PINRemoteImage

public class DoorPersonCell: UICollectionViewCell {

    public static let cellID = "DoorPersonCellID"
    public var eventImageTopAnchor: NSLayoutConstraint?

    override public var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    override public var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                self.transform = self.isSelected ? CGAffineTransform(scaleX: 0.9, y: 0.9) : CGAffineTransform.identity
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    public let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.brandBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public let eventNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public let eventDetailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let eventDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 12.0
        self.layer.masksToBounds = true
        self.configureView()
    }

    private func configureView() {
        self.addSubview(eventImageView)
        self.addSubview(eventNameLabel)
        self.addSubview(eventDetailsLabel)
        self.addSubview(eventDateLabel)
        
        eventImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        eventImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        eventImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        
        eventNameLabel.leftAnchor.constraint(equalTo: eventImageView.rightAnchor, constant: 16).isActive = true
        eventNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -29).isActive = true
        eventNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        eventNameLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        
        eventDetailsLabel.leftAnchor.constraint(equalTo: eventNameLabel.leftAnchor).isActive = true
        eventDetailsLabel.rightAnchor.constraint(equalTo: eventNameLabel.rightAnchor).isActive = true
        eventDetailsLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 6).isActive = true
        eventDetailsLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        
        eventDateLabel.leftAnchor.constraint(equalTo: eventNameLabel.leftAnchor).isActive = true
        eventDateLabel.rightAnchor.constraint(equalTo: eventNameLabel.rightAnchor).isActive = true
        eventDateLabel.topAnchor.constraint(equalTo: eventDetailsLabel.bottomAnchor, constant: 6).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
