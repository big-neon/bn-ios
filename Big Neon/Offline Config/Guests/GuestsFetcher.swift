

import CoreData
import Sync
import Alamofire
import Big_Neon_Core

let GUEST_ENTITY_NAME = "GuestData"

class GuestsFetcher {
    
    private let dataStack: DataStack
    private let repository: GuestsApiRepository
    
    init() {
        self.dataStack = DataStack(modelName: "Big Neon")
        self.repository = GuestsApiRepository.shared
    }
    
    func fetchLocalGuests() -> [GuestData] {
        let guests: NSFetchRequest<GuestData> = GuestData.fetchRequest()
        return try! self.dataStack.viewContext.fetch(guests)
    }

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

    func syncGuests(forEventID eventID: String, completion: @escaping (_ result: VoidResult) -> ()) {
        
        self.repository.fetchGuests(forEventID: eventID, limit: 100, page: 1, guestQuery: "") { (error, guestsFetched, serverGuests, totalGuests) in
            if error != nil {
                completion(.failure(error! as NSError))
                return
            }

            guard let guests = guestsFetched else {
                return
            }

            do {
                try self.deleteAllData(GUEST_ENTITY_NAME)
            } catch let err {
                completion(.failure(err as NSError))
            }

            self.dataStack.sync(guests, inEntityNamed: GUEST_ENTITY_NAME) { error in
                completion(.success)
            }
        }
    }
}
