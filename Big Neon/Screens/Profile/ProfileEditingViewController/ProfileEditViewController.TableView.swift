

import Foundation
import UIKit
import Big_Neon_UI
import PINRemoteImage

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
                if let profilePicURL = self.profleEditViewModel.user?.profilePicURL   {
                    profileCell.userImageView.pin_setImage(from: URL(string: profilePicURL), placeholderImage: nil)
                }
                return profileCell
            } else if indexPath.row == 1 {
                let profileCell: ProfileEditTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableCell.cellID, for: indexPath) as! ProfileEditTableCell
                profileCell.entryTextField.tag = 0
                profileCell.entryTextField.delegate = self
                profileCell.entryTextField.attributedPlaceholder =  NSAttributedString(string: self.profleEditViewModel.profileEditLabels[0],
                                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandLightGrey.withAlphaComponent(0.2)])
                profileCell.cellLabel.text = self.profleEditViewModel.profileEditLabels[0]
                if let name = self.profleEditViewModel.user?.firstName {
                    profileCell.entryTextField.text = name
                }
                return profileCell
            }
            let profileCell: ProfileEditTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableCell.cellID, for: indexPath) as! ProfileEditTableCell
            profileCell.entryTextField.tag = 1
            profileCell.entryTextField.delegate = self
            profileCell.entryTextField.attributedPlaceholder =  NSAttributedString(string: self.profleEditViewModel.profileEditLabels[1],
                                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandLightGrey.withAlphaComponent(0.2)])
            profileCell.cellLabel.text = self.profleEditViewModel.profileEditLabels[1]
            if let surname = self.profleEditViewModel.user?.lastName {
                profileCell.entryTextField.text = surname
            }
            return profileCell
        case 1:
            if indexPath.row == 0 {
                let profileCell: ProfileEditPhoneNumberTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditPhoneNumberTableCell.cellID, for: indexPath) as! ProfileEditPhoneNumberTableCell
                profileCell.entryTextField.delegate = self
                profileCell.entryTextField.tag = 2
                profileCell.entryTextField.attributedPlaceholder =  NSAttributedString(string: self.profleEditViewModel.profileEditLabels[2],
                                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandLightGrey.withAlphaComponent(0.2)])
                profileCell.cellLabel.text = self.profleEditViewModel.profileEditLabels[2]
                if let phone = self.profleEditViewModel.user?.phone {
                    profileCell.entryTextField.text = phone
                }
                return profileCell
            } else if indexPath.row == 1 {
                let profileCell: ProfileEditTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableCell.cellID, for: indexPath) as! ProfileEditTableCell
                profileCell.entryTextField.tag = 3
                profileCell.entryTextField.delegate = self
                profileCell.entryTextField.attributedPlaceholder =  NSAttributedString(string: self.profleEditViewModel.profileEditLabels[3],
                                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandLightGrey.withAlphaComponent(0.2)])
                profileCell.cellLabel.text = self.profleEditViewModel.profileEditLabels[3]
                if let email = self.profleEditViewModel.user?.email {
                    profileCell.entryTextField.text = email
                }
                return profileCell
            }
            let profileCell: ProfileEditTableCell = tableView.dequeueReusableCell(withIdentifier: ProfileEditTableCell.cellID, for: indexPath) as! ProfileEditTableCell
            profileCell.entryTextField.tag = 4
            profileCell.entryTextField.delegate = self
            profileCell.entryTextField.attributedPlaceholder =  NSAttributedString(string: self.profleEditViewModel.profileEditLabels[4],
                                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.brandLightGrey.withAlphaComponent(0.2)])
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
