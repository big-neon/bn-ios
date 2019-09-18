
import XCTest
import Big_Neon_Core
import Big_Neon_Studio

class BigNeonStudioTests: XCTestCase {
    
    private let repository = EventsApiRepository.shared

    //  Environment().configuration(PlistKey.testAuthEmail)
    func testAuthentication() {
        let email = "superuser@test.com"
        let password = "password"
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
        
        let eventID = "39fb32a6-82f5-4d59-a901-0c8ac09734ad"
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
        
        
        
    }

}
