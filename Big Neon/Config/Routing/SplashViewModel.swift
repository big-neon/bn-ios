

import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class RoutingViewModel {
    
    internal func fetchToken() -> Bool {
        if BusinessService.shared.database.fetchAcessToken() == nil {
            return false
        }
        
        return true
    }

}
