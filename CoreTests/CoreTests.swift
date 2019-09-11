//
//  CoreTests.swift
//  CoreTests
//
//  Created by Gugulethu on 2019/09/11.
//  Copyright © 2019 Big Neon Inc. All rights reserved.
//

import XCTest
import Big_Neon_Core

class CoreTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let email = "gugulethu@tari.com"
        let password = "Block45King"
        BusinessService.shared.database.loginToAccount(withEmail: email, password: password) { (error, tokens) in
            XCTAssertEqual(error, nil, "Authentication Failed. Error Recieved: \(error)")
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
