
import XCTest

class BigNeonStudioTests: XCTestCase {

    func testSuccessfulAuthentication() {
        let email = "gugulethu@tari.com"
        let password = "Block45King"
        let baseURLString = DatabaseService.shared.loginToAccount(withEmail: email, password: password) { (error, tokens) in
            let expectedError = nil
            XCTAssertEqual(error, expectedError, "Authentication Failed. Error Recieved: \(error)")
        }
    }

}
