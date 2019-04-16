
import Foundation
import Big_Neon_Core
import SwiftKeychainWrapper
import CoreData

final class DoorPersonViewModel {
    
    internal var events: Events?
    internal var event: Event?
    internal var user: User?
    private let coreData = CoreDataBC("EventsCoreData", "Big Neon")
    
    internal func fetchEvents(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.fetchEvents { [weak self](error, eventsFetched) in
            if error != nil {
                completion(false)
                return
            }

            guard let events = eventsFetched else {
                completion(false)
                return
            }
            
            self?.events = events
            completion(true)
            return
        }
    }
    
    internal func configureAccessToken(completion: @escaping(Bool) -> Void) {
        
        BusinessService.shared.database.tokenIsExpired { [weak self] (expired) in
            if expired == true {
                //  Fetch New Token
                self?.fetchNewAccessToken(completion: { (completed) in
                    completion(completed)
                    return
                })
            } else {
                self?.fetchCheckins(completion: { (completed) in
                    completion(completed)
                    return
                })
            }
        }
    }
    
    internal func fetchNewAccessToken(completion: @escaping(Bool) -> Void) {
        BusinessService.shared.database.fetchNewAccessToken { [weak self] (error, tokens) in
            guard let tokens = tokens else {
                completion(false)
                return
            }
            
            self?.saveTokensInKeychain(token: tokens)
            self?.fetchCheckins(completion: { (completed) in
                completion(completed)
                return
            })
        }
    }
    
    internal func fetchCheckins(completion: @escaping(Bool) -> Void) {
        self.events = nil
        BusinessService.shared.database.fetchCheckins { [weak self] (error, events) in
            if error != nil {
                completion(false)
                return
            }
            
            guard var events = events else {
                completion(false)
                return
            }
            self?.events = events
            
            self?.fetchUser(completion: { (_) in
                completion(true)
                return
            })
        }
        
    }
    
    private func fetchUser(completion: @escaping(Bool) -> Void) {
        
        guard let accessToken = BusinessService.shared.database.fetchAcessToken() else {
            completion(false)
            return
        }
        
        BusinessService.shared.database.fetchUser(withAccessToken: accessToken) { [weak self] (error, userFound) in
            guard let user = userFound else {
                completion(false)
                return
            }
            
            self?.user = user
            completion(true)
            return
        }
        
    }
    
    internal func handleLogout(completion: @escaping (Bool) -> Void) {
        BusinessService.shared.database.logout { (completed) in
            completion(completed)
        }
    }
    
    private func saveTokensInKeychain(token: Tokens) {
        KeychainWrapper.standard.set(token.accessToken, forKey: "accessToken")
        KeychainWrapper.standard.set(token.refreshToken, forKey: "refreshToken")
        return
    }
    
    //  Saving Events Offline
    internal func saveEventsOffline(events: Events) {
        let eventsToSave = events.data
        for event in eventsToSave {
            let eventValue = self.getEventValue(fromEvent: event)
            self.coreData.pushSingleValue(eventValue)
        }
    }
    
    
    // Fetch events From Offline
    internal func fetchOfflineEvents(completion: @escaping(Bool) -> Void) {
        self.coreData.retrieveData()
        let object = self.coreData.getData()
        let convertedObject = self.convertToJSONArray(managedObjectArray: object)
        //  Convert Object to Event
        
        print(convertedObject)
        completion(true)
    }
    
    func convertToJSONArray(managedObjectArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in managedObjectArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
        
        /*
        for item in managedObjectArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                
                print(attribute.value)
                print(attribute.key)
                
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                    /*
                    let event: Event = Event(id: dict[Event.CodingKeys.id],
                                             name: dict[Event.CodingKeys.name],
                                             organizationID: dict[Event.CodingKeys.organizationID],
                                             organizationID: dict[Event.CodingKeys.organizationID],
                                             venueID: dict[Event.CodingKeys.venueID],
                                             createdAt: dict[Event.CodingKeys.createdAt],
                                             eventStart: dict[Event.CodingKeys.eventStart],
                                             doorTime: dict[Event.CodingKeys.doorTime],
                                             status: dict[Event.CodingKeys.status],
                                             publishDate: dict[Event.CodingKeys.publishDate],
                                             promoImageURL: dict[Event.CodingKeys.promoImageURL],
                                             additionalInfo: dict[Event.CodingKeys.additionalInfo],
                                             topLineInfo: dict[Event.CodingKeys.topLineInfo],
                                             ageLimit: dict[Event.CodingKeys.ageLimit],
                                             cancelledAt: dict[Event.CodingKeys.cancelledAt],
                                             minTicketPrice: dict[Event.CodingKeys.minTicketPrice],
                                             maxTicketPrice: dict[Event.CodingKeys.maxTicketPrice],
                                             externalURL: dict[Event.CodingKeys.externalURL],
                                             userIsInterested: dict[Event.CodingKeys.userIsInterested],
                                             redeemDate: dict[Event.CodingKeys.redeemDate],
                                             feeInCents: dict[Event.CodingKeys.feeInCents],
                                             updatedAt: dict[Event.CodingKeys.updatedAt],
                                             videoURL: dict[Event.CodingKeys.videoURL],
                                             overrideStatus: dict[Event.CodingKeys.overrideStatus],
                                             clientFeeInCents: dict[Event.CodingKeys.clientFeeInCents],
                                             companyFeeInCents: dict[Event.CodingKeys.companyFeeInCents],
                                             settlementAmountInCents: dict[Event.CodingKeys.settlementAmountInCents],
                                             eventEnd: dict[Event.CodingKeys.eventEnd],
                                             sendgridListID: dict[Event.CodingKeys.sendgridListID],
                                             coverImageURL: dict[Event.CodingKeys.coverImageURL],
                                             privateAccessCode: dict[Event.CodingKeys.privateAccessCode])
                    */
                }
                jsonArray.append(event)
            }
        }
        return jsonArray
        */
    }
    
    private func fetchEventValue(fromEvent event: Event) -> [String: Any] {
        return [Event.CodingKeys.id.rawValue: event.id ?? "",
                Event.CodingKeys.name.rawValue: event.name ?? "",
                Event.CodingKeys.organizationID.rawValue: event.organizationID ?? "",
                Event.CodingKeys.venueID.rawValue: event.venueID ?? "",
                Event.CodingKeys.createdAt.rawValue: event.createdAt ?? "",
                Event.CodingKeys.eventStart.rawValue: event.eventStart ?? "",
                Event.CodingKeys.doorTime.rawValue: event.doorTime ?? "",
                Event.CodingKeys.status.rawValue: event.status ?? "",
                Event.CodingKeys.publishDate.rawValue: event.publishDate ?? "",
                Event.CodingKeys.promoImageURL.rawValue: event.promoImageURL ?? "",
                Event.CodingKeys.additionalInfo.rawValue: event.additionalInfo ?? "",
                Event.CodingKeys.topLineInfo.rawValue: event.topLineInfo ?? "",
                Event.CodingKeys.ageLimit.rawValue: event.ageLimit ?? "",
                Event.CodingKeys.cancelledAt.rawValue: event.cancelledAt ?? "",
                Event.CodingKeys.minTicketPrice.rawValue: event.minTicketPrice ?? 0,
                Event.CodingKeys.maxTicketPrice.rawValue: event.maxTicketPrice ?? 0,
                Event.CodingKeys.isExternal.rawValue: event.isExternal ?? false,
                Event.CodingKeys.externalURL.rawValue: event.externalURL ?? "",
                Event.CodingKeys.userIsInterested.rawValue: event.userIsInterested ?? false,
                Event.CodingKeys.redeemDate.rawValue: event.redeemDate ?? "",
                Event.CodingKeys.feeInCents.rawValue: event.feeInCents ?? 0,
                Event.CodingKeys.updatedAt.rawValue: event.updatedAt ?? "",
                Event.CodingKeys.videoURL.rawValue: event.videoURL ?? "",
                Event.CodingKeys.overrideStatus.rawValue: event.overrideStatus ?? "",
                Event.CodingKeys.clientFeeInCents.rawValue: event.clientFeeInCents ?? 0,
                Event.CodingKeys.companyFeeInCents.rawValue: event.companyFeeInCents ?? 0,
                Event.CodingKeys.settlementAmountInCents.rawValue: event.settlementAmountInCents ?? 0,
                Event.CodingKeys.eventEnd.rawValue: event.eventEnd ?? "",
                Event.CodingKeys.sendgridListID.rawValue: event.sendgridListID ?? "",
                Event.CodingKeys.coverImageURL.rawValue: event.coverImageURL ?? "",
                Event.CodingKeys.privateAccessCode.rawValue: event.privateAccessCode ?? ""]
        
        //  Localised Time, Venue
        //  Unable to load class named 'EventsManagedObject' for entity 'EventsCoreData'.  Class not found, using default NSManagedObject instead.
    }
    
    private func getEventValue(fromEvent event: Event) -> [String: Any] {
        return [Event.CodingKeys.id.rawValue: event.id ?? "",
        Event.CodingKeys.name.rawValue: event.name ?? "",
        Event.CodingKeys.organizationID.rawValue: event.organizationID ?? "",
        Event.CodingKeys.venueID.rawValue: event.venueID ?? "",
        Event.CodingKeys.createdAt.rawValue: event.createdAt ?? "",
        Event.CodingKeys.eventStart.rawValue: event.eventStart ?? "",
        Event.CodingKeys.doorTime.rawValue: event.doorTime ?? "",
        Event.CodingKeys.status.rawValue: event.status ?? "",
        Event.CodingKeys.publishDate.rawValue: event.publishDate ?? "",
        Event.CodingKeys.promoImageURL.rawValue: event.promoImageURL ?? "",
        Event.CodingKeys.additionalInfo.rawValue: event.additionalInfo ?? "",
        Event.CodingKeys.topLineInfo.rawValue: event.topLineInfo ?? "",
        Event.CodingKeys.ageLimit.rawValue: event.ageLimit ?? "",
        Event.CodingKeys.cancelledAt.rawValue: event.cancelledAt ?? "",
        Event.CodingKeys.minTicketPrice.rawValue: event.minTicketPrice ?? 0,
        Event.CodingKeys.maxTicketPrice.rawValue: event.maxTicketPrice ?? 0,
        Event.CodingKeys.isExternal.rawValue: event.isExternal ?? false,
        Event.CodingKeys.externalURL.rawValue: event.externalURL ?? "",
        Event.CodingKeys.userIsInterested.rawValue: event.userIsInterested ?? false,
        Event.CodingKeys.redeemDate.rawValue: event.redeemDate ?? "",
        Event.CodingKeys.feeInCents.rawValue: event.feeInCents ?? 0,
        Event.CodingKeys.updatedAt.rawValue: event.updatedAt ?? "",
        Event.CodingKeys.videoURL.rawValue: event.videoURL ?? "",
        Event.CodingKeys.overrideStatus.rawValue: event.overrideStatus ?? "",
        Event.CodingKeys.clientFeeInCents.rawValue: event.clientFeeInCents ?? 0,
        Event.CodingKeys.companyFeeInCents.rawValue: event.companyFeeInCents ?? 0,
        Event.CodingKeys.settlementAmountInCents.rawValue: event.settlementAmountInCents ?? 0,
        Event.CodingKeys.eventEnd.rawValue: event.eventEnd ?? "",
        Event.CodingKeys.sendgridListID.rawValue: event.sendgridListID ?? "",
        Event.CodingKeys.coverImageURL.rawValue: event.coverImageURL ?? "",
        Event.CodingKeys.privateAccessCode.rawValue: event.privateAccessCode ?? ""]
        
        //  Localised Time, Venue
        //  Unable to load class named 'EventsManagedObject' for entity 'EventsCoreData'.  Class not found, using default NSManagedObject instead.
    }
    
}
