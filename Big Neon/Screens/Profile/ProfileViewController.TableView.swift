

import Foundation
import UIKit
import BigNeonUI

extension ProfileViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 36.0))
        sectionHeaderView.backgroundColor = UIColor.brandBackground
        
        let sectionHeaderLabel: UILabel = UILabel.init(frame: CGRect(x: 20.0, y: 10.0, width: tableView.frame.width - 40, height: 16))
        sectionHeaderLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        sectionHeaderLabel.textColor = UIColor.brandGrey
        sectionHeaderLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        sectionHeaderView.addSubview(sectionHeaderLabel)
        return sectionHeaderView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Event Tools"
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        default:
            return 1
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell: ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.cellID, for: indexPath) as! ProfileTableCell
        return profileCell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
