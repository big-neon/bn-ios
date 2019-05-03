
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

// MARK: internal is default access level - not need for explicit definition

final class ProfileViewModel {
    
    internal let sectionOneLabels = ["Account"]
//                                    "Notification Preferences",
//                                    "Billing Information",
//                                    "Order History"]
    
    internal let sectionOneImages = ["ic_account"]
//                                     "ic_notitifations",
//                                     "ic_billingInfo",
//                                     "ic_orderHistory"]
    
    internal let doorManLabel = ["Doorman"]
    
    internal var user: User?
    
    internal func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.tokenIsExpired { (expired) in
            if expired == true {
                //  Fetch New Token
                self.fetchNewAccessToken(completion: { (completed) in
                    completion(completed)
                    return
                })
            } else {
                self.fetchUser(completion: { (completed) in
                    completion(completed)
                    return
                })
            }
        }
    }
    
    internal func fetchNewAccessToken(completion: @escaping(Bool) -> Void) {
        BusinessService.shared.database.fetchNewAccessToken { (error, tokens) in
            guard let tokens = tokens else {
                completion(false)
                return
            }
            
            self.saveTokensInKeychain(token: tokens)
            self.fetchUser(completion: { (completed) in
                completion(completed)
                return
            })
        }
    }
    
    private func fetchUser(completion: @escaping(Bool) -> Void) {
        
        guard let accessToken = BusinessService.shared.database.fetchAcessToken() else {
            completion(false)
            return
        }
        
        BusinessService.shared.database.fetchUser(withAccessToken: accessToken) { (error, userFound) in
            guard let user = userFound else {
                completion(false)
                return
            }
            
            self.user = user
            completion(true)
            return
        }
        
    }
    
    //MARK: could  be helper function:
    // e.g.  func saveTokensInKeychain(token: Tokens, keys: [String])
    private func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(token.refreshToken, forKey: "refreshToken")
        return
    }
}


