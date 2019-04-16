//
//  Module.swift
//  EasyCoreData
//
//  Created by Cyril Garcia on 5/11/17.
//  Copyright © 2017 ByCyril. All rights reserved.
//

import UIKit
import CoreData

public class Module {
    
    private var xcDataModelID: String!
    private var data: [NSManagedObject]!
    
    init(xcDataModelID: String) {
        self.xcDataModelID = xcDataModelID
    }
    
    public func setData(_ data: [NSManagedObject]) {
        self.data = data
    }
    
    public func clearData() {
        self.data.removeAll()
    }
    
    public func removeAt(_ index: Int) {
        self.data.remove(at: index)
    }
    
    public func getData() -> [NSManagedObject] {
        return self.data
    }
    
    public func managedObjectModel() -> NSManagedObjectModel  {

        let modelURL = Bundle.main.url(forResource: xcDataModelID!, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }
    
    public func persistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: xcDataModelID!)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
        
    }
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {

        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel())
        
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {

            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    private lazy var applicationDocumentsDirectory: URL = {

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    public lazy var managedObjectContext: NSManagedObjectContext = {

        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    public func saveContext () {
        let context = persistentContainer().viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
