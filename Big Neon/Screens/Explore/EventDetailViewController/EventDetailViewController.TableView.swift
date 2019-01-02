

import Foundation
import UIKit
import BigNeonUI

extension EventDetailViewController {
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventDetailViewModel.sectionLabels.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let eventDetailCell: EventDetailCell = tableView.dequeueReusableCell(withIdentifier: EventDetailCell.cellID, for: indexPath) as! EventDetailCell
        eventDetailCell.headerLabel.text = self.eventDetailViewModel.sectionLabels[indexPath.row].uppercased()
        eventDetailCell.headerIconImageView.image = UIImage(named: self.eventDetailViewModel.sectionImages[indexPath.row])
        eventDetailCell.descriptionTextView.text = self.eventDetailViewModel.sectionDescriptions[indexPath.row]
        return eventDetailCell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = estimateFrameForText(self.eventDetailViewModel.sectionDescriptions[indexPath.row]).height
        return 50.0 + height
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
