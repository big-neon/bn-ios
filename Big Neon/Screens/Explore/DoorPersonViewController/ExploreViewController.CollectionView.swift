
import Foundation
import UIKit
import Big_Neon_UI
import Big_Neon_Core

extension DoorPersonViewController {
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let eventCell: UpcomingEventCell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingEventCell.cellID, for: indexPath) as! UpcomingEventCell
            guard let events = self.doorPersonViemodel.events?.data else {
               return eventCell
            }
            let event = events[indexPath.item]
            
            //  Event Show
            eventCell.eventNameLabel.text = event.name
            let eventImageURL: URL = URL(string: event.compressImage(url:event.promoImageURL!))!;
            eventCell.eventImageView.pin_setImage(from: eventImageURL, placeholderImage: nil)
            
            // External Event
            if event.isExternal == true || (event.minTicketPrice == nil && event.maxTicketPrice == nil) {
                eventCell.priceView.isHidden = true
            } else {
                eventCell.priceView.isHidden = false
                eventCell.priceView.setTitle(event.priceTag(), for: UIControl.State.normal)
            }
            
            //  Time Zone
//            if event.venue!.timezone != nil {
//                let eventStart = event.eventStart
//                guard let eventDate = DateConfig.dateFromString(stringDate: eventStart!) else {
//                    eventCell.eventDateLabel.text = "-"
//                    return eventCell
//                }
//                eventCell.eventDateLabel.text = DateConfig.eventDate(date: eventDate)
//            } else {
//                let eventStart = event.eventStart
//                guard let eventDate = DateConfig.dateFromUTCString(stringDate: eventStart!) else {
//                    eventCell.eventDateLabel.text = "-"
//                    return eventCell
//                }
//                eventCell.eventDateLabel.text = DateConfig.localTime(date: eventDate)
//            }

            return eventCell
        default:
            let sectionLabelCell: SectionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.cellID, for: indexPath) as! SectionHeaderCell
            sectionLabelCell.sectionHeaderLabel.text = "Upcoming"
            return sectionLabelCell
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 210)
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.showScanner(forTicketIndex: indexPath.item)
//        if indexPath.section == 0 {
//            guard let events = self.exploreViewModel.events?.data else {
//                return
//            }
//            self.showEvent(event: events[indexPath.item])
//        }
        
    }
    
}
