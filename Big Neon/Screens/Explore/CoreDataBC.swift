//
//  CoreDataModule.swift
//  Stack Report
//
//  Created by Cyril Garcia on 5/10/17.
//  Copyright © 2017 ByCyril. All rights reserved.
//

import UIKit
import CoreData

public class CoreDataBC: Module {
    
    private var entity: String!
    public typealias CompletionHandler = (_ error: Error?) -> Void
    
    
    /// Initialize One CoreData Entity
    ///
    /// - Parameters:
    ///   - entity: The name of your entity you want to access
    ///   - xcDataModelID: The XCDataModelID file name without the extension
    public init(_ entity: String, _ xcDataModelID: String) {
        super.init(xcDataModelID: xcDataModelID)
        self.entity = entity
    }
    
    /// Save a single record with only one object. Call the pushMultipleValues() function to save multiple records.
    ///
    /// - Parameter item: A dictionary of type [String: Any]
    public func pushSingleValue<Values>(_ item: [String: Values]) {
        
        let entity = NSEntityDescription.entity(forEntityName: self.entity!, in: self.managedObjectContext)
        let coreData = NSManagedObject(entity: entity!, insertInto: self.managedObjectContext)
        
        for i in item {
            let key = i.key
            let value = i.value
            coreData.setValue(value, forKey: key)
        }
        
        do {
            try self.managedObjectContext.save()
            self.retrieveData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// Save multiple records with an array of objects. Call the pushSingleValue() function to save one record.
    ///
    /// - Parameter items: An array of dictionaries of type [String: Any]
    public func pushMultipleValues<Values>(_ items: [[String: Values]]) {
        for item in items {
            self.pushSingleValue(item)
        }
    }
    
    
    /// Generically retrieve all records from your entity.
    public func retrieveData() {
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entity!)
        
        do {
            let data = try self.managedObjectContext.fetch(fetchrequest) as? [NSManagedObject]
            self.setData(data!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// Retrieves all records and sorted by key.
    ///
    /// - Parameters:
    ///   - byKey: The key you want to sort by
    ///   - ascending: Set to ascending or descending
    public func retrieveAndSort(_ byKey: String, _ ascending: Bool) {
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entity!)
        
        let sectionSortDescriptor = NSSortDescriptor(key: byKey, ascending: ascending)
        let sortDescriptor = [sectionSortDescriptor]
        fetchrequest.sortDescriptors = sortDescriptor
        
        do {
            let data = try self.managedObjectContext.fetch(fetchrequest) as? [NSManagedObject]
            self.setData(data!)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    /// Retrieves data and filters it by value
    ///
    /// - Parameters:
    ///   - value: The value you want to filter by
    ///   - withKey: The key where the value lives in
    public func retriveAndFilterBy<Values>(_ value: Values, _ withKey: String) {
        
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: self.entity!)
        
        var predicate: NSPredicate!
        
        if let intValue = value as? Int {
            predicate = NSPredicate(format: "\(withKey) = %i", intValue)
        }
        
        if let double = value as? Double {
            predicate = NSPredicate(format: "\(withKey) = %f", double)
        }
        
        if let strValue = value as? String {
            predicate = NSPredicate(format: "\(withKey) = %@", strValue)
        }
        
        fetchrequest.predicate = predicate
        
        do {
            let results = try self.managedObjectContext.fetch(fetchrequest) as? [NSManagedObject]
            self.setData(results!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// Update an existing record
    ///
    /// - Parameters:
    ///   - object: A reference of the record you want to update
    ///   - newValues: Values to replace with
    public func update(_ referenceObject: NSManagedObject, newValues: [String: Any]) {
        
        for value in newValues {
            let key = value.key
            let val = value.value
            referenceObject.setValue(val, forKey: key)
        }
        
        
        do {
            try self.managedObjectContext.save()
            self.retrieveData()
            
        } catch {
            
        }
    }
    
    /// Remove a specific record by index
    ///
    /// - Parameter index: The index of the record
    public func delete(_ index: Int) {
        let managedContext = managedObjectContext
        managedContext.delete(self.getData()[index])
        self.removeAt(index)
        
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Remove a specific record by object
    ///
    /// - Parameter object: The object to be removed as an NSManagedObject
    public func delete(_ object: NSManagedObject) {
        let managedContext = self.managedObjectContext
        managedContext.delete(object)
        
        do {
            try managedContext.save()
            self.retrieveData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    /// Remove all records
    public func deleteAll() {
        let managedContext = managedObjectContext
        
        for object in self.getData() {
            managedContext.delete(object)
        }
        
        self.clearData()
        
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
}






