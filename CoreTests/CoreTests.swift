

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
    
    func testFetchingGuestList() {
        let eventID = ""
        let limit = 100
        let page = 1
        let query = ""
        
        BusinessService.shared.database.fetchGuests(forEventID: eventID, limit: limit, page: page, guestQuery: query) { [weak self] (error, _, _, _) in
            DispatchQueue.main.async {
                XCTAssertEqual(error?.localizedDescription, nil, "Guest list Fetching failed with Error: \(error)")
            }
        }
    }

}
