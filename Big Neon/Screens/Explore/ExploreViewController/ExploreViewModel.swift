
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class ExploreViewModel {
    
    internal var events: Events?
    
    internal func fetchEvents(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.fetchEvents { (error, eventsFetched) in
            if error != nil {
                completion(false)
                return
            }

            guard let events = eventsFetched else {
                completion(false)
                return
            }

            self.events = events
            completion(true)
            return
        }
        
    }
    
}
