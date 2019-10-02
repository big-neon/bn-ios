


import UIKit
import Big_Neon_UI
import Big_Neon_Core

class EventView: UIView {
    
    var eventData: EventsData? {
        didSet {
            guard let event = self.eventData else {
                return
            }
            
            eventNameLabel.text = event.name
            eventDetailsLabel.text = event.venue?.name
            eventDateLabel.text = self.configureEventDate(event: event)
            if let eventImageURL =  event.promo_image_url  {
                let url = URL(string: eventImageURL)
                eventImageView.pin_setImage(from: url, placeholderImage: #imageLiteral(resourceName: "ic_placeholder_image"))
            }
        }
    }
    lazy var eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.brandBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = LayoutSpec.Spacing.eight
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: LayoutSpec.Spacing.twentyFour, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var eventDetailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var eventDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.configureView()
    }
    
    private func configureEventDate(event: EventsData) -> String {
           let utcEventStart = event.event_start
           
           guard let timezone = event.venue else {
               return "-"
           }
           
           guard let eventDate = DateConfig.formatServerDate(date: utcEventStart!, timeZone: timezone.timezone!) else {
               return "-"
           }
           return DateConfig.dateFormatShort(date: eventDate)
       }

    private func configureView() {
        self.addSubview(eventImageView)
        self.addSubview(eventNameLabel)
        self.addSubview(eventDetailsLabel)
        self.addSubview(eventDateLabel)
        
        eventImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        eventImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        eventImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        eventImageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        eventNameLabel.leftAnchor.constraint(equalTo: eventImageView.leftAnchor).isActive = true
        eventNameLabel.rightAnchor.constraint(equalTo: eventImageView.rightAnchor, constant: -150).isActive = true
        eventNameLabel.topAnchor.constraint(equalTo: eventImageView.bottomAnchor, constant: LayoutSpec.Spacing.twelve).isActive = true
        eventNameLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        eventDetailsLabel.leftAnchor.constraint(equalTo: eventNameLabel.leftAnchor).isActive = true
        eventDetailsLabel.rightAnchor.constraint(equalTo: eventNameLabel.rightAnchor).isActive = true
        eventDetailsLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 8).isActive = true
        eventDetailsLabel.heightAnchor.constraint(equalToConstant: LayoutSpec.Spacing.twentyFour).isActive = true

        eventDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        eventDateLabel.centerYAnchor.constraint(equalTo: eventNameLabel.centerYAnchor).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
