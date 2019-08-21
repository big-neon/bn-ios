

import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class AccountViewModel {
    
    func createAccount(email: String, password: String, completion: @escaping(Bool, String?) -> Void) {
        
        BusinessService.shared.database.createUser(withEmail: email, password: password) { (error, tokens) in
            
            if error != nil {
                completion(false, (error?.localizedDescription)!)
                return
            }
            
            guard let tokens = tokens else {
                return
            }
            
            TokenService.shared.saveTokensInKeychain(token: tokens)
            
            completion(true, nil)
            return
        }
    }
    
    func login(email: String, password: String, completion: @escaping(Bool, String?) -> Void) {
        BusinessService.shared.database.loginToAccount(withEmail: email, password: password) { (error, tokens) in
            
            if error != nil {
                print(error)
                AnalyticsService.reportError(errorType: ErrorType.authentication, error: error ?? "")
                completion(false, error)
                return
            }
            
            guard let tokens = tokens else {
                return
            }
             TokenService.shared.saveTokensInKeychain(token: tokens)
            
            completion(true, nil)
            return
        }
    }
    
    func insert(name: String, lastName: String, completion: @escaping(Error?) -> Void) {
        
        BusinessService.shared.database.insert(name: name, lastName: lastName) { (error, userFetched) in
            if error != nil {
                completion(error)
                return
            }
            
            completion(nil)
            return
        }
        
    }
    
}
