
import Foundation
import UIKit
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
            guard let total = self.doorPersonViemodel.events?.paging.total else {
                return 0
            }
            guard let limit = self.doorPersonViemodel.events?.paging.limit else {
                return 0
            }
            if total > limit {
                return limit
            }
            return total
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let sectionLabelCell: SectionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.cellID, for: indexPath) as! SectionHeaderCell
            sectionLabelCell.sectionHeaderLabel.text = "Upcoming"
            return sectionLabelCell
        case 1:
            let eventCell: DoorPersonCell = collectionView.dequeueReusableCell(withReuseIdentifier: DoorPersonCell.cellID, for: indexPath) as! DoorPersonCell
            guard let events = self.doorPersonViemodel.events?.data else {
               return eventCell
            }
            let event = events[indexPath.item]
            eventCell.eventNameLabel.text = event.name
            let eventImageURL: URL = URL(string: event.compressImage(url:event.promoImageURL!))!;
            eventCell.eventImageView.pin_setImage(from: eventImageURL, placeholderImage: nil)
            eventCell.eventDetailsLabel.text = self.configureEventDetails(event: event)
            eventCell.eventDateLabel.text = self.configureEventDate(event: event)
            return eventCell
        default:
            let sectionLabelCell: SectionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.cellID, for: indexPath) as! SectionHeaderCell
            sectionLabelCell.sectionHeaderLabel.text = "Upcoming"
            return sectionLabelCell
        }
    }
    
    private func configureEventDetails(event: Event) -> String {
        return event.venue!.name + "   •   " + event.venue!.city + ", " + event.venue!.state
    }
    
    private func configureEventDate(event: Event) -> String {
        if event.venue!.timezone != nil {
            let eventStart = event.eventStart
            guard let eventDate = DateConfig.dateFromString(stringDate: eventStart!) else {
                return "-"
            }
            return DateConfig.dateFormatShort(date: eventDate)
        } else {
            let eventStart = event.eventStart
            guard let eventDate = DateConfig.dateFromUTCString(stringDate: eventStart!) else {
                return "-"
            }
            return DateConfig.dateFormatShort(date: eventDate)
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 60)
        default:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            return
        default:
            self.showScanner(forTicketIndex: indexPath.item)
        }
    }
    
}
