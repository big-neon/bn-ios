

import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class RoutingViewModel {
    
    func fetchToken() -> Bool {
        return TokenService.shared.fetchRefreshToken() == nil ? false : true
    }

}
