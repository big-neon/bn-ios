

import Foundation
import SwiftKeychainWrapper

public class DatabaseService {
    
    public class var shared: DatabaseService {
        struct Static {
            static let instance: DatabaseService = DatabaseService()
        }
        return Static.instance
    }
}
