
import UIKit
import Big_Neon_Core

final class ExploreDetailViewModel {
    
    internal var event: Event?
    internal var eventDetail: EventDetail?
    
    internal let sectionLabels = ["Performing Artists",
                                 "AGE RESTRICTIONS",
                                 "Event Description"]
    
    internal let sectionImages = ["ic_perfomingArts",
                                  "ic_ageRestriction",
                                  "ic_eventDescription"]
    
    internal func fetchEvent(completion: @escaping(Bool) -> Void) {
        
        guard let event = self.event else {
            completion(false)
            return
        }
        
        print(event.id)
        
        BusinessService.shared.database.fetchEvent(withID: event.id) { (error, eventFetched) in
            if error != nil {
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            guard let event = eventFetched else {
                completion(false)
                return
            }
            
            self.eventDetail = event
            completion(true)
            return
        }
        
    }
}
