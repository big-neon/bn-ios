

import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper


// MARK: internal is default access level - not need for explicit definition


final class AccountViewModel {
    
    internal func createAccount(email: String, password: String, completion: @escaping(Bool, String?) -> Void) {
        
        BusinessService.shared.database.createUser(withEmail: email, password: password) { (error, tokens) in
            
            if error != nil {
                completion(false, (error?.localizedDescription)!)
                return
            }
            
            guard let tokens = tokens else {
                return
            }
            self.saveTokensInKeychain(token: tokens)
            
            completion(true, nil)
            return
        }
    }
    
    internal func login(email: String, password: String, completion: @escaping(Bool, String?) -> Void) {
        BusinessService.shared.database.loginToAccount(withEmail: email, password: password) { (error, tokens) in
            
            if error != nil {
                completion(false, error?.localizedDescription)
                return
            }
            
            guard let tokens = tokens else {
                return
            }
            
            self.saveTokensInKeychain(token: tokens)
            
            completion(true, nil)
            return
        }
    }
    
    internal func insert(name: String, lastName: String, completion: @escaping(Error?) -> Void) {
        
        BusinessService.shared.database.insert(name: name, lastName: lastName) { (error, userFetched) in
            if error != nil {
                completion(error)
                return
            }
            
            completion(nil)
            return
        }
        
    }
    
    private func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(token.refreshToken, forKey: "refreshToken")
        return
    }
}
