import Foundation
import UIKit
import PINRemoteImage
import Big_Neon_UI
import Big_Neon_Core

extension DoorPersonViewController {

    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return  self.doorPersonViemodel.eventCoreData.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let sectionLabelCell: SectionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.cellID, for: indexPath) as! SectionHeaderCell
            sectionLabelCell.sectionHeaderLabel.text = "Upcoming"
            return sectionLabelCell
        }
        let eventCell: DoorPersonCell = collectionView.dequeueReusableCell(withReuseIdentifier: DoorPersonCell.cellID, for: indexPath) as! DoorPersonCell
        let event = self.doorPersonViemodel.eventCoreData[indexPath.item]
        eventCell.eventNameLabel.text = event.name
        //MARK: do not use explicite unwraping can be dangerous
        if let eventImageURL: URL = URL(string: event.promo_image_url!) {
            eventCell.eventImageView.pin_setImage(from: eventImageURL, placeholderImage: #imageLiteral(resourceName: "ic_placeholder_image"))
        }
        
        eventCell.eventDetailsLabel.text = self.configureEventDetails(event: event)
        eventCell.eventDateLabel.text = self.configureEventDate(event: event)
        return eventCell
       
    }

    private func configureEventDetails(event: EventsData) -> String {
        guard let venue = event.venue else {
            return ""
        }
        guard let venueName = venue.name, let venueCity = venue.city, let venueState = venue.state else {
            return ""
        }
        return venueName + "   •   " + venueCity + ", " + venueState
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
        let height: CGFloat = indexPath.section == 0 ? 60 : 100
        return CGSize(width: UIScreen.main.bounds.width - 40, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section > 0 {
            self.showScanner(forTicketIndex: indexPath.item)
        }
    }

}
