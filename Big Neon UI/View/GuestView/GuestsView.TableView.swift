

import Foundation
import UIKit

extension GuestListView {
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let sectionHeaderView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80.0))
//        sectionHeaderView.backgroundColor = UIColor.brandBackground
//
//        let sectionHeaderLabel: UILabel = UILabel.init(frame: CGRect(x: 20.0, y: 50.0, width: tableView.frame.width - 40, height: 16))
//        sectionHeaderLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
//        sectionHeaderLabel.textColor = UIColor.brandGrey
//        sectionHeaderLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
//
//        sectionHeaderView.addSubview(sectionHeaderLabel)
//        return sectionHeaderView
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 80.0
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Account Details"
//        default:
//            return "Event Tools"
//        }
//    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let guestCell: GuestTableViewCell = tableView.dequeueReusableCell(withIdentifier: GuestTableViewCell.cellID, for: indexPath) as! GuestTableViewCell
        return guestCell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
