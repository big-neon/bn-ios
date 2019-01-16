

import Foundation
import BigNeonCore

final class CreateAccountViewModel {
    
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
}
