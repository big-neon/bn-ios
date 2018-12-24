
import Foundation
import UIKit

public class HotWeekCell: UICollectionViewCell {
    
    public static let cellID = "UpcomingEventCellID"
    
    public let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.brandBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4.0
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
        label.textColor = UIColor.white
        label.text = "Future Islands"
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let eventLocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandLightGrey
        label.text = "Fox Theater  •  Oakland, CA"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let eventDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.brandLightGrey
        label.text = "July 15 2018"
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
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
        self.configureImageView()
        self.configureDarkBackgroundGradient()
        self.configureView()
    }
    
    private func configureImageView() {
        self.addSubview(eventImageView)
        
        eventImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        eventImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        eventImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        eventImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func configureView() {
        self.addSubview(favouriteButton)
        self.addSubview(eventDateLabel)
        self.addSubview(eventLocationLabel)
        self.addSubview(eventNameLabel)
        self.addSubview(priceView)
        
        favouriteButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15.0).isActive = true
        favouriteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15.0).isActive = true
        favouriteButton.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        favouriteButton.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        eventDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15.0).isActive = true
        eventDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -13.0).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        eventDateLabel.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        
        eventLocationLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15.0).isActive = true
        eventLocationLabel.rightAnchor.constraint(equalTo: eventDateLabel.leftAnchor, constant: -10.0).isActive = true
        eventLocationLabel.bottomAnchor.constraint(equalTo: eventDateLabel.bottomAnchor).isActive = true
        eventLocationLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
        
        eventNameLabel.leftAnchor.constraint(equalTo: eventLocationLabel.leftAnchor).isActive = true
        eventNameLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        eventNameLabel.bottomAnchor.constraint(equalTo: eventLocationLabel.topAnchor, constant: -6.0).isActive = true
        eventNameLabel.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
        
        priceView.leftAnchor.constraint(equalTo: eventLocationLabel.leftAnchor).isActive = true
        priceView.bottomAnchor.constraint(equalTo: eventNameLabel.topAnchor, constant: -6.0).isActive = true
        priceView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        priceView.widthAnchor.constraint(equalToConstant: 38.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureDarkBackgroundGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = self.eventImageView.bounds
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.55)
        let colors: [CGColor] = [UIColor(white: 0.0, alpha: 0.0).cgColor,
                                 UIColor(white: 0.0, alpha: 0.4).cgColor,
                                 UIColor(white: 0.0, alpha: 0.0).cgColor]
        let location = [0.0, 0.6, 0.9]
        gradient.colors = colors
        gradient.isOpaque = true
        gradient.locations = location as [NSNumber]
        eventImageView.layer.addSublayer(gradient)
    }
}
