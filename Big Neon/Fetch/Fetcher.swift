
import CoreData
import Sync
import Alamofire
import Big_Neon_Core

class Fetcher {
    
    private let dataStack: DataStack
    private let repository: EventsApiRepository
    
    init() {
        self.dataStack = DataStack(modelName: "Big Neon")
        self.repository = EventsApiRepository.shared
    }
    
    func fetchLocalEvents() -> [EventsData] {
        let request: NSFetchRequest<EventsData> = EventsData.fetchRequest()
        return try! self.dataStack.viewContext.fetch(request)
    }
    
    func syncUsingNetworking(completion: @escaping (_ result: VoidResult) -> ()) {
        
        self.repository.fetchEvents { (eventsFetchedDict, error) in
            if error != nil {
                completion(.failure(error! as NSError))
                return
            }
            
            guard let events = eventsFetchedDict else {
                return
            }
    
            var venues: [[String: Any]] = []
            for eachEvent in events {
                venues.append(eachEvent["venue"] as! [String : Any])
            }
            
            self.dataStack.sync(venues, inEntityNamed: Venue.entity().name!) { error in
                print("Venues Saved")
            }
            
            self.dataStack.sync(events, inEntityNamed: EventsData.entity().managedObjectClassName) { error in
                completion(.success)
            }
        }
    }
}

enum VoidResult {
    case success
    case failure(NSError)
}
