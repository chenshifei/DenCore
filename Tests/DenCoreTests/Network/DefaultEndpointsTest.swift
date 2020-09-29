//
//  DefaultEndpointsTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-29.
//

import XCTest
@testable import DenCore

final class DefaultEndpointsTest: XCTestCase {
    func testFetchExchangeRates() {
        let expection = expectation(description: "Fetch from coinbase API - Exchange Rates")
        DefaultEndpoints.Currency.fetchExchangeRates { (result, error) in
            expection.fulfill()
            XCTAssertNotNil(result)
            XCTAssertNil(error)
            XCTAssertNotNil(result?.data.rates["USD"])
        }
        waitForExpectations(timeout: 3)
    }
    
    static var allTests = [
        ("testFetchExchangeRates", testFetchExchangeRates)
    ]
}
