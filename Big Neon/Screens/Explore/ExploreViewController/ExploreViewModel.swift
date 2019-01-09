
import Foundation
import BigNeonCore

final class ExploreViewModel {
    
    internal var events: Events?
    
    internal func fetchEvents(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.fetchEvents { (error, eventsFetched) in
            if error != nil {
                print(error?.localizedDescription)
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
