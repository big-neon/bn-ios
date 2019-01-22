
import Foundation
import Big_Neon_Core

final class ExploreViewModel {
    
    internal var events: Events?
    
    internal func fetchEvents(completion: @escaping(Bool) -> Void) {
        
        completion(true)
//        BusinessService.shared.database.fetchEvents { (error, eventsFetched) in
//            if error != nil {
//                print(error?.localizedDescription)
//                completion(false)
//                return
//            }
//
//            guard let events = eventsFetched else {
//                completion(false)
//                return
//            }
//
//            self.events = events
//            completion(true)
//            return
//        }
        
    }
    
}
