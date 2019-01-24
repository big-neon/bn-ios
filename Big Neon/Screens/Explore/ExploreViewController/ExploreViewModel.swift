
import Foundation
import Big_Neon_Core

final class ExploreViewModel {
    
    internal var events: Events?
    
    internal func fetchEvents(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.tokenIsAvailable { (tokenAvailable) in
            print(tokenAvailable)
        }
        
        BusinessService.shared.database.fetchNewAccessToken { (accessToken) in
            print(accessToken)
        }
        
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
