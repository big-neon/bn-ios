
import Foundation
import UIKit
import BigNeonUI

extension ExploreViewController {
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let sectionLabelCell: SectionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.cellID, for: indexPath) as! SectionHeaderCell
            sectionLabelCell.sectionHeaderLabel.text = "Hot This Week"
            return sectionLabelCell
        case 1:
            let upComingEvent: UpcomingEventCell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingEventCell.cellID, for: indexPath) as! UpcomingEventCell
            return upComingEvent
        case 2:
            let sectionLabelCell: SectionHeaderCell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionHeaderCell.cellID, for: indexPath) as! SectionHeaderCell
            sectionLabelCell.sectionHeaderLabel.text = "Upcoming"
            return sectionLabelCell
        default:
            let upComingEvent: UpcomingEventCell = collectionView.dequeueReusableCell(withReuseIdentifier: UpcomingEventCell.cellID, for: indexPath) as! UpcomingEventCell
            upComingEvent.favouriteButton.setImage(UIImage(named: "ic_favourite_inactive")!, for: UIControl.State.normal)
            upComingEvent.eventImageView.image = UIImage(named: "drake")
            return upComingEvent
        }
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        case 1:
            return CGSize(width: UIScreen.main.bounds.width, height: 290)
        case 2:
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        default:
            return CGSize(width: UIScreen.main.bounds.width - 40, height: 210)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
