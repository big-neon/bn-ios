

import Foundation
import Big_Neon_Core

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
    
    
    private func saveTokensInKeychain(token: Tokens) {
        print("Save tokens to Keychain")
        return
    }
}
