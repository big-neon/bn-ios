import Foundation
import UIKit
import PINRemoteImage
import Big_Neon_UI
import Big_Neon_Core

extension DoorPersonViewController {

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            print(self.doorPersonViemodel.eventCoreData.count)
            print(self.doorPersonViemodel.todayEvents.count)
            return self.doorPersonViemodel.todayEvents.count == 0 ? 0 : self.doorPersonViemodel.todayEvents.count
        case 2:
            return 1
        default:
            print(self.doorPersonViemodel.upcomingEvents.count)
            return self.doorPersonViemodel.upcomingEvents.count
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let sectionLabelCell: SectionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.cellID, for: indexPath) as! SectionHeaderCell
            sectionLabelCell.delegate = self
            sectionLabelCell.detailLabel.text = self.doorPersonViemodel.todayEvents.isEmpty == true ? "" : "Today's Events"
            sectionLabelCell.sectionHeaderLabel.text = "My Events"
            self.doorPersonViemodel.fetchUser { [weak self] (_) in
                DispatchQueue.main.async {
                    sectionLabelCell.user = self?.doorPersonViemodel.user
                }
            }
            return sectionLabelCell
        case 1:
            let eventCell: DoorPersonCell = collectionView.dequeueReusableCell(withReuseIdentifier: DoorPersonCell.cellID, for: indexPath) as! DoorPersonCell
            if self.doorPersonViemodel.todayEvents.isEmpty == true {
                return eventCell
            }
            let event = self.doorPersonViemodel.todayEvents[indexPath.item]
            eventCell.eventNameLabel.text = event.name
            if let eventImageURL =  event.promo_image_url  {
                let url = URL(string: eventImageURL)
                eventCell.eventImageView.pin_setImage(from: url, placeholderImage: #imageLiteral(resourceName: "ic_placeholder_image"))
            }
            eventCell.eventDetailsLabel.text = self.configureEventDetails(event: event)
            eventCell.eventDateLabel.text = self.configureEventDate(event: event)
            return eventCell
        case 2:
            let sectionLabelCell: HomeSectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeSectionCell.cellID, for: indexPath) as! HomeSectionCell
            sectionLabelCell.sectionLabel.text = self.doorPersonViemodel.upcomingEvents.isEmpty == true ? "No Upcoming Events" : "Upcoming Events"
            return sectionLabelCell
        default:
            let eventCell: DoorPersonCell = collectionView.dequeueReusableCell(withReuseIdentifier: DoorPersonCell.cellID, for: indexPath) as! DoorPersonCell
            let event = self.doorPersonViemodel.upcomingEvents[indexPath.item]
            eventCell.eventNameLabel.text = event.name
            if let eventImageURL =  event.promo_image_url  {
                let url = URL(string: eventImageURL)
                eventCell.eventImageView.pin_setImage(from: url, placeholderImage: #imageLiteral(resourceName: "ic_placeholder_image"))
            }
            eventCell.eventDetailsLabel.text = self.configureEventDetails(event: event)
            eventCell.eventDateLabel.text = self.configureEventDate(event: event)
            return eventCell
        }
       
    }

    private func configureEventDetails(event: EventsData) -> String {
        guard let venue = event.venue else {
            return ""
        }
        guard let venueName = venue.name, let venueCity = venue.city, let venueState = venue.state else {
            return ""
        }
        return venueName //+ "   •   " + venueCity + ", " + venueState
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

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
        switch indexPath.section {
        case 0:
            let height: CGFloat = self.doorPersonViemodel.todayEvents.count == 0 ? 80 : 140
            return CGSize(width: UIScreen.main.bounds.width, height: height)
        case 1:
            return cellSize
        case 2:
            return CGSize(width: UIScreen.main.bounds.width, height: 80.0)
        default:
            return cellSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 || indexPath.section == 2 {
            return
        }
//        self.showScanner(forTicketIndex: indexPath.item, section: indexPath.section)
        self.showEvent(forTicketIndex: indexPath.item, section: indexPath.section)
         
    }

}
