

import UIKit
import Big_Neon_UI
import Big_Neon_Core
import CoreData

extension DoorPersonViewController {

    internal func storeEventsOffline(events: Events) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
    
    internal func fetchEventsSaved() {
        
        
    }

}
