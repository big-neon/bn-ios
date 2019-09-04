
import CoreData
import Sync
import Alamofire
import Big_Neon_Core

enum VoidResult {
    case success
    case failure(NSError?)
}

class EventsFetcher {
    
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
    
    func deleteLocalCache() {
        
        //  Delete Venues
        self.dataStack.viewContext.delete(Venue.init())

        //  Delete Events
        self.dataStack.viewContext.delete(EventsData.init())
    }

    func fetchLocalGuests() -> [RedeemedTicket] {
        let guests: NSFetchRequest<RedeemedTicket> = RedeemedTicket.fetchRequest()
        return try! self.dataStack.viewContext.fetch(guests)
    }

    func syncCheckins(completion: @escaping (_ result: VoidResult) -> ()) {
        
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
            
            print(venues)
            print(Venue.entity().managedObjectClassName)
            
            guard let venue = Venue.entity().managedObjectClassName else {
                print("Failed to fetch the Venue")
                completion(.failure(nil))
                return
            }
            
            self.dataStack.sync(venues, inEntityNamed: venue) { error in
            }
            
            self.dataStack.sync(events, inEntityNamed: EventsData.entity().managedObjectClassName) { error in
                completion(.success)
            }
        }
    }
    
    func syncToDelete(completion: @escaping (_ result: VoidResult) -> ()) {
        
        self.repository.fetchEvents { (eventsFetchedDict, error) in
            if let err = error {
                completion(.failure(err as NSError))
                return
            }
            
            guard let events = eventsFetchedDict else {
                return
            }
            
            do {
                try self.dataStack.delete(events, inEntityNamed: EventsData.entity().managedObjectClassName)
            } catch {
                
            }
    
            
        }
    }
}
