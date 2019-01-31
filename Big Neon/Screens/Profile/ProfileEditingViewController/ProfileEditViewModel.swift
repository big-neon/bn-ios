


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
    
    internal func updateUserAccount(firstName: String, lastName: String, mobileNumber: String, email: String, completion: @escaping(Bool) -> Void) {
        
        print(firstName)
        print(lastName)
        print(mobileNumber)
        print(email)
       
    }

    internal func handleLogout(completion: @escaping (Bool) -> Void) {
        BusinessService.shared.database.logout { (completed) in
            completion(completed)
        }
    }
}
