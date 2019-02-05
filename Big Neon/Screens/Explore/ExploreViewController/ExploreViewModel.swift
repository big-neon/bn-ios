
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper

final class ExploreViewModel {
    
    internal var events: Events?
    
    internal func fetchEvents(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.fetchEvents { (error, eventsFetched) in
            if error != nil {
                completion(false)
                return
            }

            guard let events = eventsFetched else {
                completion(false)
                return
            }
            print(events)
            self.events = events
            completion(true)
            return
        }
        
    }
    
}
