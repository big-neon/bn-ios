

import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class RoutingViewModel {
    
    // MARK: internal is default access level - not need for explicit definition
    internal func fetchToken() -> Bool {
        // MARK: this is 101 example of guard statement
        // add  @discardableResult on fetchRefreshToken
//        guard let _ = BusinessService.shared.database.fetchRefreshToken() else {
//            return false
//        }
//        return true
                
        if  TokenService.shared.fetchRefreshToken() == nil {
            return false
        }
        return true
        
        
        
    }

}
