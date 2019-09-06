

import XCTest
@testable import Big_Neon_Core

class AuthenticationURLTests: XCTestCase {
    
    //  API URL Test
    func test_API_BaseURLString_IsCorrect() {
        let baseURLString = API.baseURL()
        let expectedBaseURLString = "https://api.production.bigneon.com"
        XCTAssertEqual(baseURLString, expectedBaseURLString, "Base URL does not match expected base URL. Expected base URLs to match.")
    }
    
    //  Test Authentication
    func test_Successful_Authentication() {
        let email = "gugulethu@tari.com"
        let password = "Block45King"
        let baseURLString = DatabaseService.shared.loginToAccount(withEmail: email, password: password) { (error, tokens) in
            let expectedError = nil
            XCTAssertEqual(error, expectedError, "Authentication Failed. Error Recieved: \(error)")
        }
    }
    
    override func setUp() {
        
        //
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        
        
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
