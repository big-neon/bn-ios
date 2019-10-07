

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
        
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: 100, page: 1, guestQuery: nil) { (error, guestsFetched, serverGuests, totalGuests) in
            DispatchQueue.main.async {

                if error != nil {
                    completion(.failure(error! as NSError))
                    return
                }
                
                //  Core Data Checks
                guard let guests = serverGuests else {
                    return
                }

//                do {
//                    try self?.deleteAllData(GUEST_ENTITY_NAME)
//                } catch let err {
//                    completion(.failure(err as NSError))
//                }
                
                print(totalGuests)
                print(guests.data)
                print(guests.data.count)

//                self.dataStack.sync(guests.data, inEntityNamed: GUEST_ENTITY_NAME) { error in
//                    completion(.success)
//                }
                
                completion(.success)
                return
            }
        }
        
//        self.repository.fetchGuests(forEventID: eventID, limit: 100, page: 1, guestQuery: "") { (error, guestsFetched, serverGuests, totalGuests) in
//
//        }
    }
}
