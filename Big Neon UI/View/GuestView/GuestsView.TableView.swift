

import Foundation
import UIKit

extension GuestListView {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80.0))
        sectionHeaderView.backgroundColor = UIColor.brandBackground
        
        let sectionHeaderLabel: UILabel = UILabel.init(frame: CGRect(x: 20.0, y: 50.0, width: tableView.frame.width - 40, height: 16))
        sectionHeaderLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        sectionHeaderLabel.textColor = UIColor.brandGrey
        sectionHeaderLabel.text = self.tableView(tableView, titleForHeaderInSection: section)
        
        sectionHeaderView.addSubview(sectionHeaderLabel)
        return sectionHeaderView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Account Details"
        default:
            return "Event Tools"
        }
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.profileViewModel.sectionOneLabels.count
        default:
            return self.profileViewModel.doorManLabel.count
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell: ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileTableCell.cellID, for: indexPath) as! ProfileTableCell
        
        switch indexPath.section {
        case 0:
            profileCell.cellLabel.text = self.profileViewModel.sectionOneLabels[indexPath.row]
            profileCell.cellImageView.image = UIImage(named: self.profileViewModel.sectionOneImages[indexPath.row])
        default:
            profileCell.cellLabel.text = self.profileViewModel.doorManLabel[indexPath.row]
            profileCell.cellImageView.image = UIImage(named: "ic_doorman")
        }
        
        return profileCell
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                self.editProfileViewController()
                return
            }
        default:
            print("Doorman")
            return
        }
    }
    
}
