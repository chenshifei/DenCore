//
//  NetworkTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-29.
//

import XCTest
@testable import DenCore

final class NetworkTest: XCTestCase {
    func testFetchFromRealServer() {
        let expection = expectation(description: "Fetch from real server")
        let networkService = NetworkCable()
        networkService.fetchData { (data, error) in
            expection.fulfill()
            XCTAssertNotNil(data)
            XCTAssertNil(error)
        }
        waitForExpectations(timeout: 3)
    }
    
    static var allTests = [
        ("testFetchFromRealServer", testFetchFromRealServer)
    ]
}
