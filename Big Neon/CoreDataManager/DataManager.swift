

import CoreData
import Big_Neon_UI
import Big_Neon_Core

let dataErrorDomain = "dataErrorDomain"

enum DataErrorCode: NSInteger {
    case networkUnavailable = 101
    case wrongDataFormat = 102
}

class DataManager {
    
    private let persistentContainer: NSPersistentContainer
    private let repository: EventsApiRepository
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(persistentContainer: NSPersistentContainer, repository: EventsApiRepository) {
        self.persistentContainer = persistentContainer
        self.repository = repository
    }
    
    func fetchEvents(completion: @escaping(Error?) -> Void) {
        
        repository.fetchEvents { (jsonDictionary, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let jsonDictionary = jsonDictionary else {
                let error = NSError(domain: dataErrorDomain, code: DataErrorCode.wrongDataFormat.rawValue, userInfo: nil)
                completion(error)
                return
            }
            
            let taskContext = self.persistentContainer.newBackgroundContext()
            taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            taskContext.undoManager = nil
            
            self.syncEvents(jsonDictionary: jsonDictionary, taskContext: taskContext, completion: { (completed) in
                print(completed)
                completion(nil)
                return
            })
        }
    }
    
    private func syncEvents(jsonDictionary: [[String: Any]], taskContext: NSManagedObjectContext, completion: @escaping(Bool) -> Void) {
        
        let matchingRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventsData")
        
        let eventIds = jsonDictionary.map { $0["id"] as? String }.compactMap { $0 }
        matchingRequest.predicate = NSPredicate(format: "id in %@", argumentArray: [eventIds])
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: matchingRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        
        // Execute the request to de batch delete and merge the changes to viewContext, which triggers the UI update
//        do {
//            let batchDeleteResult = try taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult
//
//            if let deletedObjectIDs = batchDeleteResult?.result as? [NSManagedObjectID] {
//                NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIDs],
//                                                    into: [self.persistentContainer.viewContext])
//            }
//
//        } catch {
//
//            print("Error: \(error)\nCould not batch delete existing records.")
//            completion(false)
//        }
        
        // Create new records.
        print(jsonDictionary)
        for eventDictionary in jsonDictionary {
            
            print(eventDictionary)
            
            guard let event = NSEntityDescription.insertNewObject(forEntityName: "EventsData", into: taskContext) as? EventsData else {
                print("Error: Failed to create a new EventsData model!")
                completion(false)
                return
            }
            
            do {
                try event.update(with: eventDictionary)
            } catch {
                completion(false)
                print("Error: \(error)\nThe quake object will be deleted.")
                taskContext.delete(event)
            }
        }
        
        // Save all the changes just made and reset the taskContext to free the cache.
        if taskContext.hasChanges {
            do {
                try taskContext.save()
            } catch {
                completion(false)
                print("Error: \(error)\nCould not save Core Data context.")
            }
            taskContext.reset() // Reset the context to clean up the cache and low the memory footprint.
        }
        completion(true)
    }
}
