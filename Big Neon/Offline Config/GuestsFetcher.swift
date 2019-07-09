

import CoreData
import Sync
import Alamofire
import Big_Neon_Core

class GuestsFetcher {

    private let dataStack: DataStack
    private let repository: GuestsApiRepository

    init() {
        self.dataStack = DataStack(modelName: "Big Neon")
        self.repository = GuestsApiRepository.shared
    }

    func fetchLocalGuests() -> [RedeemedTicket] {
        let guests: NSFetchRequest<RedeemedTicket> = RedeemedTicket.fetchRequest()  //  Fetching Local Guests
        return try! self.dataStack.viewContext.fetch(guests)
    }
    
    func syncGuestsData(withEventID eventID: String, completion: @escaping (_ result: VoidResult) -> ()) {
        print(eventID)
        self.repository.fetchGuests(forEventID: eventID) { (guestsFetchedDict, error) in
            if error != nil {
                completion(.failure(error! as NSError))
                return
            }
            
            guard let guests = guestsFetchedDict else {
                return
            }
            
            print(guests)
//            var venues: [[String: Any]] = []
//            for eachEvent in guests {
//                venues.append(eachEvent["venue"] as! [String : Any])
//            }
//
//            self.dataStack.sync(venues, inEntityNamed: Venue.entity().managedObjectClassName) { error in
//            }
            
            self.dataStack.sync(guests, inEntityNamed: RedeemedTicket.entity().managedObjectClassName) { error in
                completion(.success)
            }
        }
    }
}
