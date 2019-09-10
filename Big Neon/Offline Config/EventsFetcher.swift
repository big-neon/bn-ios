
import CoreData
import Sync
import Alamofire
import Big_Neon_Core

enum VoidResult {
    case success
    case failure(NSError?)
}

let EVENT_ENTITY_NAME = "EventsData"
let VENUE_ENTITY_NAME = "Venue"

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
    
    func deleteLocalCache() throws {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EVENT_ENTITY_NAME)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try managedObjectContext.execute(batchDeleteRequest)
    }

    func deleteAllData(_ entity:String) {

        let appDel =  UIApplication.shared.delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
            print("Deleted all data")
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
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

            do {
                try self.deleteAllData(EVENT_ENTITY_NAME)
                try self.deleteAllData(VENUE_ENTITY_NAME)
            } catch {
            }

            var venues: [[String: Any]] = []
            for eachEvent in events {
                venues.append(eachEvent["venue"] as! [String : Any])
            }

            self.dataStack.sync(venues, inEntityNamed: VENUE_ENTITY_NAME) { error in
            }
            self.dataStack.sync(events, inEntityNamed: EVENT_ENTITY_NAME) { error in
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
                try self.dataStack.delete(events, inEntityNamed: EVENT_ENTITY_NAME)
            } catch {
                
            }
    
            
        }
    }
}
