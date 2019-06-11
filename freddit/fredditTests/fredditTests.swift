//
//  fredditTests.swift
//  fredditTests
//
//  Created by Francisco Gindre on 11/06/2019.
//  Copyright © 2019 Appscrafter. All rights reserved.
//

import XCTest
@testable import freddit

class fredditTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMockAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let expect = expectation(description: "exp")
        let client = MockClient()
        client.top(limit: 50, count: 50, page: nil) { (listing, error) in
            
            expect.fulfill()
            XCTAssertNil(error)
            
            
            guard let listing = listing, let listingItems = ListingVisitor.listingItems(from: listing, of: "t3")  else {
                XCTFail("listing unavailable")
                return
            }
            
            
            XCTAssertEqual(listingItems.count, 50)
        }
        
        wait(for: [expect], timeout: 6)
        
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
