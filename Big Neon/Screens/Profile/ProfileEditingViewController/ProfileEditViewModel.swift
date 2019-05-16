


import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper  // do we need this one

// MARK: internal is default access level - not need for explicit definition

final class ProfileEditViewModel {
    
    let profileEditLabels: [String] = ["First Name", "Last Name", "Mobile", "Email", "Password"]
    
    var userImageRL: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var user: User?
    var imageToUpload: UIImage?
    
    internal func configureUserData() {
        self.userImageRL    = user?.profilePicURL
        self.firstName      = user?.firstName
        self.lastName       = user?.lastName
        self.mobileNumber   = user?.phone
        self.email          = user?.email
    }
    
    internal func updateUserImage(image: UIImage, completion: @escaping(Error?) -> Void) {
        
        BusinessService.shared.database.updateUser(firstName: firstName, lastName: lastName, email: email) { (error, user) in
            if error != nil {
                completion(error)
                return
            }
            
            self.user = user
            self.configureUserData()
            completion(nil)
            return
        }
    }
    
    internal func updateUserAccount(firstName: String, lastName: String, email: String, completion: @escaping(Error?) -> Void) {
        BusinessService.shared.database.updateUser(firstName: firstName, lastName: lastName, email: email) { (error, user) in
            if error != nil {
                completion(error)
                return
            }
            
            self.user = user
            self.configureUserData()
            completion(nil)
            return
        }
    }

    internal func handleLogout(completion: @escaping (Bool) -> Void) {
        BusinessService.shared.database.logout { (completed) in
            completion(completed)
        }
    }
}
