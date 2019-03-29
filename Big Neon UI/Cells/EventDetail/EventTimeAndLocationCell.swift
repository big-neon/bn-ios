

import Foundation
import UIKit
import Big_Neon_Core

final public class EventTimeAndLocationCell: UITableViewCell {
    
    public static let cellID = "EventTimeAndLocationCellID"
    
    public var eventDetail: EventDetail? {
        didSet {
            guard let eventDetail = self.eventDetail else {
                return
            }
            
            self.venueLabel.text = eventDetail.venue.name
            self.addressLabel.text = eventDetail.venue.address


            //Event Date
            if eventDetail.venue.timezone != nil {
                let eventStart = eventDetail.eventStart
                guard let eventDate = DateConfig.dateFromString(stringDate: eventStart) else {
                    self.dateLabel.text = "-"
                    return
                }
                self.dateLabel.text = DateConfig.eventFullDate(date: eventDate)
            } else {
                let eventStart = eventDetail.eventStart
                guard let eventDate = DateConfig.dateFromUTCString(stringDate: eventStart) else {
                    self.dateLabel.text = "-"
                    return
                }
                self.dateLabel.text = DateConfig.dateFormatLong(date: eventDate)
            }

            //  Doors Label
            // Doors 7:00 PM PDT  -  Show 8:00 PM PDT"
        }
    }
    
    public let headerIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.white
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "TIME AND LOCATION"
        label.textColor = UIColor.brandBlack
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let venueLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandPrimary
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let doorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Doors 7:00 PM PDT  -  Show 8:00 PM PDT"
        label.textColor = UIColor.brandMediumGrey
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
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
        self.addSubview(headerIconImageView)
        self.addSubview(headerLabel)
        self.addSubview(venueLabel)
        self.addSubview(addressLabel)
        self.addSubview(dateLabel)
        self.addSubview(doorsLabel)
        
        self.headerIconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24).isActive = true
        self.headerIconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        self.headerIconImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        self.headerIconImageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        self.headerLabel.leftAnchor.constraint(equalTo: headerIconImageView.rightAnchor, constant: 10).isActive = true
        self.headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        self.headerLabel.centerYAnchor.constraint(equalTo: headerIconImageView.centerYAnchor).isActive = true
        self.headerLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        self.venueLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 15).isActive = true
        self.venueLabel.leftAnchor.constraint(equalTo: headerLabel.leftAnchor).isActive = true
        self.venueLabel.rightAnchor.constraint(equalTo: headerLabel.rightAnchor).isActive = true
        self.venueLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        self.addressLabel.topAnchor.constraint(equalTo: venueLabel.bottomAnchor, constant: 15).isActive = true
        self.addressLabel.leftAnchor.constraint(equalTo: venueLabel.leftAnchor).isActive = true
        self.addressLabel.rightAnchor.constraint(equalTo: venueLabel.rightAnchor).isActive = true
        self.addressLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        self.dateLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 30).isActive = true
        self.dateLabel.leftAnchor.constraint(equalTo: addressLabel.leftAnchor).isActive = true
        self.dateLabel.rightAnchor.constraint(equalTo: addressLabel.rightAnchor).isActive = true
        self.dateLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        self.doorsLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8).isActive = true
        self.doorsLabel.leftAnchor.constraint(equalTo: dateLabel.leftAnchor).isActive = true
        self.doorsLabel.rightAnchor.constraint(equalTo: dateLabel.rightAnchor).isActive = true
        self.doorsLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
