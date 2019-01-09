
import UIKit
import BigNeonCore

final class ExploreDetailViewModel {
    
    internal var event: Event?
    internal var eventDetail: EventDetail?
    
    internal let sectionLabels = ["TIME and Location",
                                 "Performing Artists",
                                 "AGE RESTRICTIONS",
                                 "Event Description"]
    
    internal let sectionImages = ["ic_eventTime",
                                  "ic_perfomingArts",
                                  "ic_ageRestriction",
                                  "ic_eventDescription"]
    
    internal let sectionDescriptions = ["The Warfield \n982 Market St, San Francisco, CA 94102, USA \n\nThursday, 27 September 2018 \nDoors 7:00 PM PDT  -  Show 8:00 PM PDT",
                                  "Taylor Swift, Kanye West, Drake, Beyonce, Ed sheeran, Elton John, Eminem, Paul McCartney, Florida Georgia Line, Coldplay, Maroon 5 and Carrie Underwood.",
                                  "This event is for all ages.",
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam in lacus non magna tincidunt lacinia. Donec est ut quam nec sapien tempus luctus id quis magna. Lo Vestibulum dolor lacus, loborti."]
    
    internal func fetchEvent(completion: @escaping(Bool) -> Void) {
        
        guard let event = self.event else {
            completion(false)
            return
        }
        
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
