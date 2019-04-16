

import UIKit
import Big_Neon_UI
import Big_Neon_Core
import CoreData

extension DoorPersonViewController {

    internal func storeEventsOffline(events: Events) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "EventsCoreData", in: context)
        let newEvent = NSManagedObject(entity: entity!, insertInto: context)
        for event in events.data {

            newEvent.setValue(event.id, forKey: Event.CodingKeys.id.rawValue)
            newEvent.setValue(event.name, forKey: Event.CodingKeys.name.rawValue)
            newEvent.setValue(event.organizationID, forKey: Event.CodingKeys.organizationID.rawValue)
            newEvent.setValue(event.venueID, forKey: Event.CodingKeys.venueID.rawValue)
            newEvent.setValue(event.createdAt, forKey: Event.CodingKeys.createdAt.rawValue)
            newEvent.setValue(event.eventStart, forKey: Event.CodingKeys.eventStart.rawValue)
            newEvent.setValue(event.doorTime, forKey: Event.CodingKeys.doorTime.rawValue)
            newEvent.setValue(event.status, forKey: Event.CodingKeys.status.rawValue)
            newEvent.setValue(event.publishDate, forKey: Event.CodingKeys.publishDate.rawValue)
            newEvent.setValue(event.promoImageURL, forKey: Event.CodingKeys.promoImageURL.rawValue)
            newEvent.setValue(event.additionalInfo, forKey: Event.CodingKeys.additionalInfo.rawValue)
            newEvent.setValue(event.topLineInfo, forKey: Event.CodingKeys.topLineInfo.rawValue)
            newEvent.setValue(event.ageLimit, forKey: Event.CodingKeys.ageLimit.rawValue)
            newEvent.setValue(event.cancelledAt, forKey: Event.CodingKeys.cancelledAt.rawValue)
            newEvent.setValue(event.minTicketPrice, forKey: Event.CodingKeys.minTicketPrice.rawValue)
            newEvent.setValue(event.maxTicketPrice, forKey: Event.CodingKeys.maxTicketPrice.rawValue)
            newEvent.setValue(event.isExternal, forKey: Event.CodingKeys.isExternal.rawValue)
            newEvent.setValue(event.userIsInterested, forKey: Event.CodingKeys.userIsInterested.rawValue)
            newEvent.setValue(event.redeemDate, forKey: Event.CodingKeys.redeemDate.rawValue)
            newEvent.setValue(event.feeInCents, forKey: Event.CodingKeys.feeInCents.rawValue)
            newEvent.setValue(event.updatedAt, forKey: Event.CodingKeys.updatedAt.rawValue)
            newEvent.setValue(event.videoURL, forKey: Event.CodingKeys.videoURL.rawValue)
            newEvent.setValue(event.clientFeeInCents, forKey: Event.CodingKeys.clientFeeInCents.rawValue)
            newEvent.setValue(event.companyFeeInCents, forKey: Event.CodingKeys.companyFeeInCents.rawValue)
            newEvent.setValue(event.settlementAmountInCents, forKey: Event.CodingKeys.settlementAmountInCents.rawValue)
            newEvent.setValue(event.eventEnd, forKey: Event.CodingKeys.eventEnd.rawValue)
            newEvent.setValue(event.sendgridListID, forKey: Event.CodingKeys.sendgridListID.rawValue)
            newEvent.setValue(event.coverImageURL, forKey: Event.CodingKeys.coverImageURL.rawValue)
            newEvent.setValue(event.privateAccessCode, forKey: Event.CodingKeys.privateAccessCode.rawValue)

            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        }
        
    }
    
    internal func fetchOfflineEventsSaved(completion: @escaping(Events?) -> Void) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            completion(nil)
//            return
//        }
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EventsCoreData")
//
//        let employeesFetch = NSFetchRequest(entityName: "Employee")
//
//        do {
//            let fetchedEmployees = try moc.executeFetchRequest(employeesFetch) as! [EmployeeMO]
//        } catch {
//            fatalError("Failed to fetch employees: \(error)")
//        }
//
//        do {
//            let eventsFetched = try context.fetch(fetchRequest)
//            print(eventsFetched as! [NSManagedObject])
//
////            guard let events = eventsFetched as? Events else {
////                completion(nil)
////                return
////            }
//            for data in eventsFetched as! [NSManagedObject] {
//
//
//                let event: Event = Event(id: data.value(forKey: Event.CodingKeys.id) as? String,
//                                         name: data.value(forKey: Event.CodingKeys.name) as? String ?? nil,
//                                         organizationID: data.value(forKey: Event.CodingKeys.organizationID) as? String ?? nil,
//                                         organizationID: data.value(forKey: Event.CodingKeys.organizationID) as? String ?? nil,
//                                         venueID: data.value(forKey: Event.CodingKeys.venueID) as? String ?? nil,
//                                         createdAt: data.value(forKey: Event.CodingKeys.createdAt) as? String ?? nil,
//                                         eventStart: data.value(forKey: Event.CodingKeys.eventStart) as? String ?? nil,
//                                         doorTime: data.value(forKey: Event.CodingKeys.doorTime) as? String ?? nil,
//                                         status: data.value(forKey: Event.CodingKeys.status) as? String ?? nil,
//                                         publishDate: data.value(forKey: Event.CodingKeys.publishDate) as? String ?? nil,
//                                         promoImageURL: data.value(forKey: Event.CodingKeys.promoImageURL) as? String ?? nil,
//                                         additionalInfo: data.value(forKey: Event.CodingKeys.additionalInfo) as? String ?? nil,
//                                         topLineInfo: data.value(forKey: Event.CodingKeys.topLineInfo) as? String ?? nil,
//                                         ageLimit: data.value(forKey: Event.CodingKeys.ageLimit) as? String ?? nil,
//                                         cancelledAt: data.value(forKey: Event.CodingKeys.cancelledAt) as? String ?? nil,
//                                         minTicketPrice: data.value(forKey: Event.CodingKeys.minTicketPrice) as? Int ?? nil,
//                                         maxTicketPrice: data.value(forKey: Event.CodingKeys.maxTicketPrice) as? Int ?? nil,
//                                         externalURL: data.value(forKey: Event.CodingKeys.externalURL) as? String ?? nil,
//                                         userIsInterested: data.value(forKey: Event.CodingKeys.userIsInterested) as? Bool ?? nil,
//                                         redeemDate: data.value(forKey: Event.CodingKeys.redeemDate) as? String ?? nil,
//                                         feeInCents: data.value(forKey: Event.CodingKeys.feeInCents) as? Int ?? nil,
//                                         updatedAt: data.value(forKey: Event.CodingKeys.updatedAt) as? String ?? nil,
//                                         videoURL: data.value(forKey: Event.CodingKeys.videoURL) as? String ?? nil,
//                                         overrideStatus: data.value(forKey: Event.CodingKeys.overrideStatus) as? String ?? nil,
//                                         clientFeeInCents: data.value(forKey: Event.CodingKeys.clientFeeInCents) as? Int ?? nil,
//                                         companyFeeInCents: data.value(forKey: Event.CodingKeys.companyFeeInCents) as? Int ?? nil,
//                                         settlementAmountInCents: data.value(forKey: Event.CodingKeys.settlementAmountInCents) as? Int ?? nil,
//                                         eventEnd: data.value(forKey: Event.CodingKeys.eventEnd) as? String ?? nil,
//                                         sendgridListID: data.value(forKey: Event.CodingKeys.sendgridListID) as? String ?? nil,
//                                         coverImageURL: data.value(forKey: Event.CodingKeys.coverImageURL) as? String ?? nil,
//                                         privateAccessCode: data.value(forKey: Event.CodingKeys.privateAccessCode) as? String ?? nil)
//
//                print(event)
//            }
//            completion(nil)
//        } catch {
//            print("Failed to fetch Events")
//            completion(nil)
//        }
        
    }
}
