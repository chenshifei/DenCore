//
//  DenCoreTests.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-27.
//

import XCTest
@testable import DenCore

func DenAssertSuccess(_ lhs: ProcessorResult, _ rhs: Double) {
    switch lhs {
    case .success(let answer):
        XCTAssertEqual(answer, rhs)
    case .failure:
        XCTFail()
    }
}

func DenAssertSuccess(_ lhs: ProcessorResult, _ rhs: Double, accuracy: Double) {
    switch lhs {
    case .success(let answer):
        XCTAssertEqual(answer, rhs, accuracy: accuracy)
    case .failure:
        XCTFail()
    }
}

func DenAssertFailure(_ lhs: ProcessorResult, _ rhs: ProcessorError) {
    switch lhs {
    case .success:
        XCTFail()
    case .failure(let e):
        XCTAssertTrue(e is ProcessorError)
        if rhs == e as! ProcessorError {} else {
            XCTFail()
        }
    }
}
