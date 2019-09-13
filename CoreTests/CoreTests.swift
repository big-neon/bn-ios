

import XCTest
import Big_Neon_Core

class CoreTests: XCTestCase {

    func testAuthentication() {
        let email = "gugulethu@tari.com"
        let password = "Block45King"
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
        
        //  Event ID belongs to Huge Ticket Sales
        let eventID = "39fb32a6-82f5-4d59-a901-0c8ac09734ad"
        let limit = 100
        let page = 1
        let query = ""
        
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: query) { [weak self] (error, _, _, _) in
            DispatchQueue.main.async {
                XCTAssertEqual(error?.localizedDescription, nil, "Guest list Fetching failed with Error: \(error). Potentially guests might have been deleted.")
            }
        }
    }
    
    
    func testTicketCheckin() {
        
        
        
    }

}
