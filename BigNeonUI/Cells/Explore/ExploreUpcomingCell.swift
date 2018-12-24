
import Foundation
import UIKit

public class UpcomingEventCell: UICollectionViewCell {
    
    public static let cellID = "UpcomingEventCellID"
    
    public let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.brandBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 2.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public lazy var favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_favourite_inactive"), for: UIControl.State.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let eventNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.text = "The Weeknd"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public let eventDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.text = "Fri, July 20"
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override func layoutSubviews() {
        self.priceView.roundCorners([.topLeft, .topRight, .bottomRight], radius: 5.0)
        self.priceView.layer.masksToBounds = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.configureView()
    }
    
    private func configureView() {
        self.addSubview(eventImageView)
        self.addSubview(eventNameLabel)
        self.addSubview(eventDateLabel)
        self.addSubview(favouriteButton)
        self.addSubview(priceView)
        
        eventImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        eventImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        eventImageView.heightAnchor.constraint(equalToConstant: 162.0).isActive = true
        
        favouriteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15.0).isActive = true
        favouriteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0).isActive = true
        favouriteButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        favouriteButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        eventNameLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        eventNameLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: 12).isActive = true
        eventNameLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        
        eventDateLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        eventDateLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: 14.0).isActive = true
        
        priceView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15.0).isActive = true
        priceView.bottomAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: -15.0).isActive = true
        priceView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        priceView.widthAnchor.constraint(equalToConstant: 38.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
