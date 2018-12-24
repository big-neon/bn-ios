
import Foundation
import UIKit

public class UpcomingEventCell: UICollectionViewCell {
    
    public static let cellID = "UpcomingEventCellID"
    
    public let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.brandGrey
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 2.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
//    public let rideDirectionLabel: BrandHeaderLabel = {
//        let label = BrandHeaderLabel()
//        label.textColor = UIColor.brandBlack
//        label.text = "Ride Home"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    public let rideDetailsLabel: BrandHeaderLabel = {
//        let label = BrandHeaderLabel()
//        label.font = UIFont.header.withSize(16)
//        label.textColor = UIColor.brandMediumGrey
//        label.text = "Tuesday, 24 July"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    public let rideTimeLabel: BrandSubHeaderLabel = {
//        let label = BrandSubHeaderLabel()
//        label.textColor = UIColor.brandMediumGrey
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(eventImageView)
        eventImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        eventImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        eventImageView.heightAnchor.constraint(equalToConstant: 162.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
