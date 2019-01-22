

import Foundation

public class DatabaseService {
    
    public class var shared: DatabaseService {
        struct Static {
            static let instance: DatabaseService = DatabaseService()
        }
        return Static.instance
    }
    
    public init() {
    }
    
    internal func fetchAuthorizationKey() {
        let retrievedPassword: String? = KeychainWrapper.standard.string(forKey: "userPassword")
        print("Retrieved passwork is: \(retrievedPassword!)")
    }
    
}
