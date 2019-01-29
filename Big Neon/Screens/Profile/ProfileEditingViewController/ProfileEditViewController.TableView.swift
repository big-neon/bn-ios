

import Foundation
import UIKit
import Big_Neon_UI

extension ProfileEditViewController {
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        default:
            return 1
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let profileCell: ProfileImageUploadCell = tableView.dequeueReusableCell(withIdentifier: ProfileImageUploadCell.cellID, for: indexPath) as! ProfileImageUploadCell
                return profileCell
            } else if indexPath.row == 1 {
                let profileCell: ProfileEditTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableCell.cellID, for: indexPath) as! ProfileEditTableCell
                profileCell.cellLabel.text = self.profleEditViewModel.profileEditLabels[0]
                return profileCell
            }
            let profileCell: ProfileEditTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableCell.cellID, for: indexPath) as! ProfileEditTableCell
            profileCell.cellLabel.text = self.profleEditViewModel.profileEditLabels[1]
            return profileCell
        case 1:
            if indexPath.row == 0 {
                let profileCell: ProfileEditTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableCell.cellID, for: indexPath) as! ProfileEditTableCell
                profileCell.cellLabel.text = self.profleEditViewModel.profileEditLabels[2]
                return profileCell
            } else if indexPath.row == 1 {
                let profileCell: ProfileEditTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableCell.cellID, for: indexPath) as! ProfileEditTableCell
                profileCell.cellLabel.text = self.profleEditViewModel.profileEditLabels[3]
               return profileCell
            }
            let profileCell: ProfileEditTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableCell.cellID, for: indexPath) as! ProfileEditTableCell
            profileCell.cellLabel.text = self.profleEditViewModel.profileEditLabels[4]
            return profileCell
        default:
            let logoutCell: LogoutCell = tableView.dequeueReusableCell(withIdentifier: LogoutCell.cellID, for: indexPath) as! LogoutCell
            return logoutCell
        }
        
        
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                return 80.0
            }
            return 60.0
        default:
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            print("TO Interact Cell")
            return
        case 1:
            print("TO Interact Cell")
            return
        default:
            self.handleLogout()
        }
        
    }
    
}
