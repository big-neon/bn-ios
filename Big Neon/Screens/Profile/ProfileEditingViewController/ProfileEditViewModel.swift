


import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class ProfileEditViewModel {
    
    internal let profileEditLabels: [String] = ["First Name", "Last Name", "Mobile", "Email", "Password"] 
    
    internal var user: User?

    internal func handleLogout(completion: @escaping (Bool) -> Void) {
        BusinessService.shared.database.logout { (completed) in
            completion(completed)
        }
    }
}
