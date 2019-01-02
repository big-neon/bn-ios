

import UIKit

final public class EventHeaderView: UIView {
    
    public let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "drake")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let eventHeader: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14.0
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let presentLabel: UILabel = {
        let label = UILabel()
        label.text = "All star promoter events presents"
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let eventDateView: EventDateView = {
        let view = EventDateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public let eventNameLabel: UILabel = {
        let label = UILabel()
        label.text = "The Taylor Swift Reputation Tour Concert"
        label.numberOfLines = 0
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var interestedButton: InterestedButtonView = {
        let button = InterestedButtonView()
        button.buttonLabel.text = "I’m Interested"
        button.buttonIconView.image = UIImage(named: "interested_star")?.withRenderingMode(.alwaysTemplate)
        button.buttonIconView.tintColor = UIColor.brandMediumGrey
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public lazy var shareEventButton: InterestedButtonView = {
        let button = InterestedButtonView()
        button.buttonLabel.text = "Share Event"
        button.buttonIconView.image = UIImage(named: "ic_shareEvent")?.withRenderingMode(.alwaysTemplate)
        button.buttonIconView.tintColor = UIColor.brandMediumGrey
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.configureView()
        self.configureTextView()
    }
    
    private func configureView() {
        self.addSubview(eventImageView)
        self.eventImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.eventImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.eventImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.eventImageView.heightAnchor.constraint(equalToConstant: 260).isActive = true
    }
    
    private func configureTextView() {
        self.addSubview(eventHeader)
        self.addSubview(presentLabel)
        self.addSubview(eventDateView)
        self.addSubview(eventNameLabel)
        self.addSubview(interestedButton)
        self.addSubview(shareEventButton)
        
        self.eventHeader.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.eventHeader.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.eventHeader.topAnchor.constraint(equalTo: self.topAnchor, constant: 240).isActive = true
        self.eventHeader.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.presentLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.presentLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.presentLabel.topAnchor.constraint(equalTo: eventHeader.bottomAnchor, constant: 10).isActive = true
        self.presentLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        self.eventDateView.topAnchor.constraint(equalTo: presentLabel.bottomAnchor, constant: 5).isActive = true
        self.eventDateView.rightAnchor.constraint(equalTo: presentLabel.rightAnchor).isActive = true
        self.eventDateView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.eventDateView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.eventNameLabel.leftAnchor.constraint(equalTo: presentLabel.leftAnchor).isActive = true
        self.eventNameLabel.rightAnchor.constraint(equalTo: eventDateView.leftAnchor, constant: -24).isActive = true
        self.eventNameLabel.topAnchor.constraint(equalTo: presentLabel.bottomAnchor, constant: 10).isActive = true
        self.eventNameLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.interestedButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -90).isActive = true
        self.interestedButton.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 24).isActive = true
        self.interestedButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.interestedButton.leftAnchor.constraint(equalTo: eventNameLabel.leftAnchor).isActive = true
        
        self.shareEventButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 90).isActive = true
        self.shareEventButton.centerYAnchor.constraint(equalTo: interestedButton.centerYAnchor).isActive = true
        self.shareEventButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.shareEventButton.rightAnchor.constraint(equalTo: eventDateView.rightAnchor).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
