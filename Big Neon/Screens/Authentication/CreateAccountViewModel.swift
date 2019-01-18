

import Foundation
import Big_Neon_Core

final class AccountViewModel {
    
    internal func createAccount(email: String, password: String, completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.createUser(withEmail: email, password: password) { (error, tokens) in
            guard let tokens = tokens else {
                completion(false)
                return
            }
            
            if error != nil {
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            print(tokens)
            completion(true)
            return
        }
        
    }
    
    internal func login(email: String, password: String, completion: @escaping(Bool) -> Void) {
        completion(true)
        
        /*
        BusinessService.shared.database.loginToAccount(withEmail: email, password: password) { (error, tokens) in
            guard let tokens = tokens else {
                completion(false)
                return
            }
            
            if error != nil {
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            print(tokens)
            completion(true)
            return
        }
        */
    }
}
