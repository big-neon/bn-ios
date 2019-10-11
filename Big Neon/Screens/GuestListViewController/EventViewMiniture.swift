

import UIKit
import Big_Neon_UI
import Big_Neon_Core

class EventViewMiniture: UIView {
    
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

    public lazy var eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.brandBackground
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var eventDetailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
   
    public lazy var eventDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var eventBackgroundView: BrandShadowView = {
        let view = BrandShadowView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.brandBackground
        self.configureView()
    }

    func configureView() {
        addSubview(eventBackgroundView)
        eventBackgroundView.addSubview(eventImageView)
        eventBackgroundView.addSubview(eventNameLabel)
        eventBackgroundView.addSubview(eventDetailsLabel)
        eventBackgroundView.addSubview(eventDateLabel)

        eventBackgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        eventBackgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -LayoutSpec.Spacing.sixteen).isActive = true
        eventBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        eventBackgroundView.heightAnchor.constraint(equalToConstant: 112.0).isActive = true

        eventImageView.leftAnchor.constraint(equalTo: eventBackgroundView.leftAnchor).isActive = true
        eventImageView.topAnchor.constraint(equalTo: eventBackgroundView.topAnchor).isActive = true
        eventImageView.bottomAnchor.constraint(equalTo: eventBackgroundView.bottomAnchor).isActive = true
        eventImageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
       
        eventNameLabel.leftAnchor.constraint(equalTo: eventImageView.rightAnchor, constant: LayoutSpec.Spacing.sixteen).isActive = true
        eventNameLabel.rightAnchor.constraint(equalTo: eventBackgroundView.rightAnchor, constant: -32).isActive = true
        eventNameLabel.topAnchor.constraint(equalTo: eventBackgroundView.topAnchor, constant: LayoutSpec.Spacing.twenty).isActive = true
        eventNameLabel.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
       
        eventDetailsLabel.leftAnchor.constraint(equalTo: eventNameLabel.leftAnchor).isActive = true
        eventDetailsLabel.rightAnchor.constraint(equalTo: eventNameLabel.rightAnchor).isActive = true
        eventDetailsLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 6).isActive = true
        eventDetailsLabel.heightAnchor.constraint(equalToConstant: 16.0).isActive = true
       
        eventDateLabel.leftAnchor.constraint(equalTo: eventNameLabel.leftAnchor).isActive = true
        eventDateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        eventDateLabel.topAnchor.constraint(equalTo: eventDetailsLabel.bottomAnchor, constant: 6).isActive = true
        eventDateLabel.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
    }
   
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
