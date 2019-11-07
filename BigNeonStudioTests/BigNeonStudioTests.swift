
import XCTest
import CoreData
import Sync
import Big_Neon_Studio
import Big_Neon_Core
import Big_Neon_Studio

let GUEST_ENTITY_NAME = "GuestData"
let SCANNED_TICKET_ENTITY_NAME = "ScannedTicketData"


class BigNeonStudioTests: XCTestCase {
    
    private let repository = EventsApiRepository.shared
    let dataStack = DataStack(modelName: "Big Neon")

    func testAuthentication() {
        let email = "superuser@test.com" // Environment().configuration(PlistKey.testAuthEmail)
        let password = "password"   // Environment().configuration(PlistKey.testAuthenticationPassword)
        BusinessService.shared.database.loginToAccount(withEmail: email, password: password) { (error, tokens) in
            XCTAssertEqual(error, nil, "Authentication Failed. Error Recieved: \(error)")
        }
    }
    
    func testFetchEvents() {
        BusinessService.shared.database.fetchEvents { (error, events) in
            DispatchQueue.main.async {
                XCTAssertEqual(error?.localizedDescription, nil, "Events Fetching failed with Error: \(error)")
            }
        }
    }
    
    func testFetchingGuestList() {
        
        let eventID = "39fb32a6-82f5-4d59-a901-0c8ac09734ad"    // Environment().configuration(PlistKey.testEventID)
        let limit = 50
        let page = 1
        let query = ""
    
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: query) { [weak self] (error, _, _, _) in
            DispatchQueue.main.async {
                XCTAssertEqual(error?.localizedDescription, nil, "Guest list Fetching failed with Error: \(error). Potentially guests might have been deleted or the access token has expired.")
            }
        }
    }
    
    
    func testTicketCheckin() {
        
        let eventID = "39fb32a6-82f5-4d59-a901-0c8ac09734ad"    // Environment().configuration(PlistKey.testEventID)
        let limit = 50
        let page = 1
        let query = ""
    
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: query) { [weak self] (error, _, guests, _) in
            DispatchQueue.main.async {
                
                if let err = error {
                    XCTFail("Failed to fetch guests with Error: \(err)")
                    return
                }
                
                guard let guestsFetched = guests?.data else {
                    XCTFail("Failed to fetch guests: Guests might have been deleted or the access token has expired.")
                    return
                }
                
                //  Find a ticket to redeem and redeem it.
                
                for guest in guestsFetched {
                    if guest.status == TicketStatus.purchased.rawValue {
                        BusinessService.shared.database.getRedeemTicket(forTicketID: guest.id) { (scanFeedback, errorString, redeemTicket) in
                            DispatchQueue.main.async {
                                if scanFeedback == .validTicketID {
                                    if let ticket = redeemTicket {
                                        self?.completeAutoCheckin(eventID: eventID, ticket: ticket, completion: { (scanFeedback) in
                                            //  Return after attempting to checkin the valid ticket found.
                                            return
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
                
                //  Looped through all the guests and none found with a purchased status
                XCTFail("No ticket found with a purchased status. You have probably run out of valid tickets to test with. \n Solution: Increase the limit to check with more tickets")
            }
        }
        
    }
    
    func completeAutoCheckin(eventID: String, ticket: RedeemableTicket, completion: @escaping(ScanFeedback) -> Void) {
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                XCTFail("Issue found with the access token for checkin. Might have expired.")
                completion(.issueFound)
                return
            }
            
            self.completeCheckin(eventID: eventID, ticket: ticket) { (scanFeedback) in
                completion(scanFeedback)
                if scanFeedback == ScanFeedback.valid {
                    XCTAssertEqual(scanFeedback, ScanFeedback.valid, "Ticket not successfully scanned in test case. Scan Feedback: \(scanFeedback). Ticket: \(ticket)")
                    return
                }
                
                XCTFail("Test Failed with checkin feedback received: \(scanFeedback).")
            }
        }
    }

    func completeCheckin(eventID: String, ticket: RedeemableTicket, completion: @escaping(ScanFeedback) -> Void) {
        
        TokenService.shared.checkToken { (completed) in
            guard completed else {
                completion(.issueFound)
                return
            }

            BusinessService.shared.database.redeemTicket(forTicketID: ticket.id, eventID: eventID, redeemKey: ticket.redeemKey) { (scanFeedback, ticket) in
                DispatchQueue.main.async {
                    completion(scanFeedback)
                }
            }
        }
    }
    
    /*
     Unit Test for Offline Checkin
     */
    func testOfflineCheckin() {
        
        let eventID = "39fb32a6-82f5-4d59-a901-0c8ac09734ad"
        let limit = 50
        let page = 1
        let query = ""
    
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: query) { [weak self] (error, _, guests, _) in
            DispatchQueue.main.async {
                
                if let err = error {
                    XCTFail("Failed to fetch guests with Error: \(err)")
                    return
                }
                
                guard let guestsFetched = guests?.data else {
                    XCTFail("Failed to fetch guests: Guests might have been deleted or the access token has expired.")
                    return
                }
                
                //  Find a ticket to redeem and redeem it.
                
                for guest in guestsFetched {
                    if guest.status == TicketStatus.purchased.rawValue {
                        BusinessService.shared.database.getRedeemTicket(forTicketID: guest.id) { (scanFeedback, errorString, redeemTicket) in
                            DispatchQueue.main.async {
                                if scanFeedback == .validTicketID {
                                    if let ticket = redeemTicket {
                                        self?.completeAutoCheckin(eventID: eventID, ticket: ticket, completion: { (scanFeedback) in
                                            //  Return after attempting to checkin the valid ticket found.
                                            return
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
                
                //  Looped through all the guests and none found with a purchased status
                XCTFail("No ticket found with a purchased status. You have probably run out of valid tickets to test with. \n Solution: Increase the limit to check with more tickets")
            }
        }
    }
    
    /*
     Complete Offline Checking
     */
    func completeOfflineCheckin(forTicketID ticketID: String, eventID: String, completion: @escaping(ScanFeedback) -> Void) {
        
        do {
            let ticket = try self.dataStack.fetch(ticketID, inEntityNamed: GUEST_ENTITY_NAME) as! GuestData
            ticket.status = TicketStatus.Redeemed.rawValue
            let ticketDict = convertManagedObjectToDictionary(managedObject: ticket)
            try self.dataStack.insertOrUpdate(ticketDict, inEntityNamed: GUEST_ENTITY_NAME)
        } catch let err {
            print(err)
        }
        
        let scannedTicketDict = ["event_id": eventID,
                                 "id": ticketID] as [String : AnyObject]
        self.saveScannedTicketInCoreDataWith(array: [scannedTicketDict])
    }
    
    
    /*
     Offline Scanning Helper Functions
     */
    func convertManagedObjectToDictionary(managedObject: NSManagedObject) -> [String : Any] {
        var dict: [String: Any] = [:]
        for attribute in managedObject.entity.attributesByName {
            if let value = managedObject.value(forKey: attribute.key) {
                dict[attribute.key] = value
            }
        }
        return dict
    }
    
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

}
