

import Foundation
import UIKit
import Big_Neon_UI

extension EventDetailViewController {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let timeLocationCell: EventTimeAndLocationCell = tableView.dequeueReusableCell(withIdentifier: EventTimeAndLocationCell.cellID, for: indexPath) as! EventTimeAndLocationCell
            timeLocationCell.headerLabel.text = self.eventDetailViewModel.sectionLabels[0].uppercased()
            timeLocationCell.headerIconImageView.image = UIImage(named: self.eventDetailViewModel.sectionImages[0])
            guard let eventDetail = self.eventDetailViewModel.eventDetail else {
                return timeLocationCell
            }
            timeLocationCell.eventDetail = eventDetail
            return timeLocationCell
        case 1:
            let eventDetailCell: EventDetailCell = tableView.dequeueReusableCell(withIdentifier: EventDetailCell.cellID, for: indexPath) as! EventDetailCell
            eventDetailCell.headerLabel.text = self.eventDetailViewModel.sectionLabels[1].uppercased()
            eventDetailCell.headerIconImageView.image = UIImage(named: self.eventDetailViewModel.sectionImages[1])
            guard let eventDetail = self.eventDetailViewModel.eventDetail else {
                return eventDetailCell
            }
            for artist in eventDetail.artists {
                eventDetailCell.descriptionTextView.text += artist.artist.name + " "
            }
            return eventDetailCell
        case 2:
            let eventDetailCell: EventDetailCell = tableView.dequeueReusableCell(withIdentifier: EventDetailCell.cellID, for: indexPath) as! EventDetailCell
            eventDetailCell.headerLabel.text = self.eventDetailViewModel.sectionLabels[2].uppercased()
            eventDetailCell.headerIconImageView.image = UIImage(named: self.eventDetailViewModel.sectionImages[2])
            guard let eventDetail = self.eventDetailViewModel.eventDetail else {
                return eventDetailCell
            }
            eventDetailCell.descriptionTextView.text = "You must be \(eventDetail.ageLimit) to enter this event"
            return eventDetailCell
        default:
            let eventDetailCell: EventDetailCell = tableView.dequeueReusableCell(withIdentifier: EventDetailCell.cellID, for: indexPath) as! EventDetailCell
            eventDetailCell.headerLabel.text = self.eventDetailViewModel.sectionLabels[3].uppercased()
            eventDetailCell.headerIconImageView.image = UIImage(named: self.eventDetailViewModel.sectionImages[3])
            guard let eventDetail = self.eventDetailViewModel.eventDetail else {
                return eventDetailCell
            }
            guard let additionalInfo = eventDetail.additionalInfo as? String else {
                return eventDetailCell
            }
            eventDetailCell.descriptionTextView.text = additionalInfo
            return eventDetailCell
        }
        
        
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 190.0
        case 1:
            guard let eventDetail = self.eventDetailViewModel.eventDetail else {
                return 70.0
            }
            var artists = ""
            for artist in eventDetail.artists {
                artists += artist.artist.name + ", "
            }
            return 90.0 + estimateFrameForText(artists).height
        case 2:
            guard let eventDetail = self.eventDetailViewModel.eventDetail else {
                return 70.0
            }
            let ageLimitText = "You must be \(eventDetail.ageLimit) to enter this event"
            return 90.0 + estimateFrameForText(ageLimitText).height
        default:
            guard let eventDetail = self.eventDetailViewModel.eventDetail else {
                return 70.0
            }
            return 70.0 //+ estimateFrameForText(eventDetail.additionalInfo).height
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)], context: nil)
    }
    
}
