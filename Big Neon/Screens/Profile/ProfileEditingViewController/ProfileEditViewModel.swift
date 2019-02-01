


import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class ProfileEditViewModel {
    
    internal let profileEditLabels: [String] = ["First Name", "Last Name", "Mobile", "Email", "Password"]
    
    internal var userImageRL: String?
    internal var firstName: String?
    internal var lastName: String?
    internal var mobileNumber: String?
    internal var email: String?
    internal var user: User?
    
    internal func configureUserData() {
        self.userImageRL    = user?.profilePicURL
        self.firstName      = user?.firstName
        self.lastName       = user?.lastName
        self.mobileNumber   = user?.phone
        self.email          = user?.email
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
