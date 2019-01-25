
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class ProfileViewModel {
    
    internal let sectionOneLabels = ["Account",
                                    "Notification Preferences",
                                    "Billing Information",
                                    "Order History"]
    
    internal let sectionOneImages = ["ic_account",
                                     "ic_notitifations",
                                     "ic_billingInfo",
                                     "ic_orderHistory"]
    
    internal let doorManLabel = ["Doorman"]
    
    internal func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.checkTokenExpiration { (expired) in
            if expired == true {
                //  Fetch New Token
                self.fetchNewAccessToken(completion: { (completed) in
                    completion(completed)
                    return
                })
            }
            
            // Continue Fetching User
            completion(true)
            return
        }
    }
    
    internal func fetchNewAccessToken(completion: @escaping(Bool) -> Void) {
        BusinessService.shared.database.fetchNewAccessToken { (error, tokens) in
            guard let tokens = tokens else {
                completion(false)
                return
            }
            
            self.saveTokensInKeychain(token: tokens)
            //  Continue Fetching User
        }
    }
    
    
    
    private func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(token.refreshToken, forKey: "refreshToken")
        return
    }
}


