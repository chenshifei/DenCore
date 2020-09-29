//
//  DenCoreTests.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-27.
//

import XCTest
@testable import DenCore

func DenAssertSuccess(_ lhs: CircuitBoardResult, _ rhs: Double) {
    XCTAssertEqual(lhs.0, rhs)
    XCTAssertNil(lhs.1)
}

func DenAssertSuccess(_ lhs: CircuitBoardResult, _ rhs: Double, accuracy: Double) {
    do {
        let lhsResult = try XCTUnwrap(lhs.0)
        XCTAssertEqual(lhsResult, rhs, accuracy: accuracy)
    } catch {
        XCTFail(error.localizedDescription)
    }
    XCTAssertNil(lhs.1)
}

func DenAssertFailure(_ lhs: CircuitBoardResult, _ rhs: CircuitBoardError) {
    XCTAssertNil(lhs.0)
    do {
        let lhsError = try XCTUnwrap(lhs.1)
        XCTAssertTrue(lhsError is CircuitBoardError)
        if rhs == lhsError as! CircuitBoardError {} else {
            XCTFail()
        }
    } catch {
        XCTFail(error.localizedDescription)
    }
    
}
