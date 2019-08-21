
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class ProfileViewModel {
    
    let sectionOneLabels = ["Account"]
                                    
    //  TO DO
    /*
     "Notification Preferences",
     "Billing Information",
     "Order History"]
    */
    
    let sectionOneImages = ["ic_account"]
    //  TO DO
    /*
    "ic_notitifations",
    "ic_billingInfo",
    "ic_orderHistory"]
    */
    
    let doorManLabel = ["Doorman"]
    
    var user: User?
    
    func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.checkTokenExpirationAndUpdate { (tokenResult, error) in
            if error != nil {
                print(error)
                completion(false)
                return
            }
            
            switch tokenResult {
            case .noAccessToken?:
               print("No Access Token Found")
               completion(false)
            case .tokenExpired?:
                print("Token has expired")
                completion(false)
            default:
                self.fetchUser(completion: { (completed) in
                    completion(completed)
                    return
                })
            }
        }
    
    }
    
    private func fetchUser(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.fetchUser() { (error, userFound) in
            guard let user = userFound else {
                completion(false)
                return
            }
            
            self.user = user
            completion(true)
            return
        }
        
    }
    
}


