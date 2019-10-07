



import Foundation
import Big_Neon_Core
import CoreData
import Sync

let GUEST_ENTITY_NAME = "GuestData"

final class EventViewModel {
    
    var eventData: EventsData?
    var guests: Guests?
    var totalGuests: Int?
    var eventTimeZone: String?
    var currentTotalGuests: Int = 0
    var currentPage: Int = 0
    let limit = 100
    var guestCoreData: [GuestData] = []
    var guestSearchResults: [RedeemableTicket] = []
    
    let dataStack = DataStack(modelName: "Big Neon")

    func fetchNextEventGuests(page: Int, completion: @escaping(Bool) -> Void) {
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(false)
                return
            }

            self.fetchGuests(page: page) { (completed) in
                completion(completed)
                return
            }
        }
    }
    
    /*
    Fetch Local Guests from Core Data
    */
    func fetchLocalGuests() -> [GuestData] {
        let guests: NSFetchRequest<GuestData> = GuestData.fetchRequest()
        return try! self.dataStack.viewContext.fetch(guests)
    }
    
    /*
     Delete Core Data Guests
     */
    func deleteAllData(_ entity: String) {

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
        } catch let error {
            print("Error deteling all data in \(entity):", error)
        }
    }
    
    /*
     Fetch guests from data
     */
    func fetchGuests(page: Int, completion: @escaping(Bool) -> Void) {

        guard let eventID = self.eventData!.id else {
            completion(false)
            return
        }

        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: nil) { [weak self] (error, guestsFetched, serverGuests, totalGuests) in
            DispatchQueue.main.async {

                //  Core Data Checks
                guard let fetchedGuests = guestsFetched else {
                    completion(false)
                    return
                }
                
                do {
                    try self?.deleteAllData(GUEST_ENTITY_NAME)
                } catch let err {
                    print("Error while trying to delete guests: \(err)")
                    completion(false)
                }
             
                 self?.totalGuests = totalGuests
                 // self?.ticketsFetched += guests.data
                 self?.currentTotalGuests += fetchedGuests.count
                 self?.currentPage += 1
                
                self?.dataStack.sync(fetchedGuests, inEntityNamed: GUEST_ENTITY_NAME) { error in
                    completion(true)
                    return
                }
                
                
            }
        }
    }
    
    /*
     Searching for Guests
     */
    func fetchSearchGuests(withQuery query: String?, page: Int?, isSearching: Bool, completion: @escaping(Bool) -> Void) {
        
        guard let eventID = self.eventData?.id else {
            completion(false)
            return
        }
        
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: query) { [weak self] (error, guestsFetched, serverGuests, totalGuests) in
            DispatchQueue.main.async {
                guard let guests = serverGuests else {
                    completion(false)
                    return
                }
                
                if isSearching == true {
                    self?.guestSearchResults = guests.data
                    completion(true)
                    return
                }
                
                self?.totalGuests = totalGuests
//                self?.ticketsFetched += guests.data
                self?.currentTotalGuests += guests.data.count
                self?.currentPage += 1
                completion(true)
                return
            }
        }
    }
}
