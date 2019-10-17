
import Foundation
import Big_Neon_Core
import CoreData
import Sync

extension CheckinService {
    
    /*
     Save Scanned Ticket In Core Data
    */
    func saveScannedTicketInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createScannedTicketFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    func createScannedTicketFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let scannedTicketEntity = NSEntityDescription.insertNewObject(forEntityName: SCANNED_TICKET_ENTITY_NAME, into: context) as? ScannedTicketData {
            scannedTicketEntity.id = dictionary["id"] as? String
            scannedTicketEntity.event_id = dictionary["event_id"] as? String
            return scannedTicketEntity
        }
        return nil
    }
    
    /*
     Fetch guests from data and sync up to network
    */
    func fetchScannedAndUploadLocalGuests(completion: @escaping(Bool) -> Void) {
        let context:NSManagedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SCANNED_TICKET_ENTITY_NAME)
        
        do {
            if let scannedTicket = try context.fetch(fetchRequest) as? [ScannedTicketData] {
                for ticket in scannedTicket {
                    self.automaticallyCheckin(ticketID: ticket.id!, eventID: ticket.event_id!) { (scanFeedBack, errorString, redeemedTicket) in
                        print("Scan Feedback: \(scanFeedBack), \(errorString), \(redeemedTicket)")
                    }
                    
                    //  Delete the Ticket Value Here from Core Data
                    
                }
            }
        } catch let error {
            print("Error fetching all data in \(SCANNED_GUEST_ENTITY_NAME):", error)
        }
        
    }
        
    /*
     Delete Scanned Ticket
     */
    func deleteScannedData(ticketID: String) {
        let context:NSManagedObjectContext = CoreDataStack.sharedInstance.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SCANNED_TICKET_ENTITY_NAME)
        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.predicate
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Error deteling all data in \(SCANNED_TICKET_ENTITY_NAME):", error)
        }
    }
    
}
