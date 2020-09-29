//
//  GeoCodingTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-28.
//

import XCTest
import CoreLocation
@testable import DenCore

final class MockGeocoder: Geocoder {
    enum GeocodeTask {
        case pending, ongoing, finished
    }
    
    var task: GeocodeTask = .pending
    var hasOngoingGeocode: Bool {
        switch task {
        case .ongoing:
            return true
        default:
            return false
        }
    }
    var resultToReturn: [CLPlacemark]?
    var errorToReturn: Error?
    var doGeocodeTask = true
    
    func parseLocation(_ location: CLLocation, completion: @escaping CLGeocodeCompletionHandler) {
        guard doGeocodeTask else {
            return
        }
        task = .ongoing
        completion(resultToReturn, errorToReturn)
        task = .finished
    }
    
    func cancalOngoingGeocode() {
        task = .pending
    }
}

final class GeoCodingTest: XCTestCase {
    var antennaDish = AntennaDish()
    
    override func setUp() {
        antennaDish = AntennaDish()
    }
    
    func testResolveRealAddress() {
        let expection = expectation(description: "Parsing location with real server")
        let location = CLLocation(latitude: 59.31, longitude: 18.06)
        let _ = antennaDish.parseLocation(location) { (result, error) in
            expection.fulfill()
            
            let placemark = try! XCTUnwrap(result?.first)
            XCTAssertEqual(placemark.administrativeArea, "Stockholm")
            XCTAssertNil(error)
        }
        waitForExpectations(timeout: 5)
    }
    
    func testCancelOngoingTaskBeforeResolveAddress() {
        let mock = MockGeocoder()
        mock.doGeocodeTask = false
        mock.task = .ongoing
        antennaDish = AntennaDish(geocoder: mock)
        let location = CLLocation(latitude: 59.31, longitude: 18.06)
        let _ = antennaDish.parseLocation(location) { (result, error) in
            switch mock.task {
            case .pending:
                XCTAssert(true)
            default: XCTFail()
            }
        }
    }
    
    static var allTests = [
        ("testResolveRealAddress", testResolveRealAddress),
        ("testCancelOngoingTaskBeforeResolveAddress", testCancelOngoingTaskBeforeResolveAddress)
    ]
}
