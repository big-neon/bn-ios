

import Foundation
import SwiftKeychainWrapper

public class DatabaseService {
    
    public class var shared: DatabaseService {
        struct Static {
            static let instance: DatabaseService = DatabaseService()
        }
        return Static.instance
    }
    
    public init() {
    }
    
    internal func fetchAcessToken() -> String? {
        return KeychainWrapper.standard.string(forKey: Constants.keychainAccessToken)
    }
    
}
