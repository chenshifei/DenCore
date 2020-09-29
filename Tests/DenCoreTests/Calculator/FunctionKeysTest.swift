//
//  ArithmeticTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-23.
//

import XCTest
@testable import DenCore

final class FunctionKeysTest: XCTestCase {
    var circuitBoard = CircuitBoard()
    
    override func setUp() {
        circuitBoard = CircuitBoard()
    }
    
    func testClearKey() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.functionKeyPressed(key: .equal)
        result = circuitBoard.functionKeyPressed(key: .clear)
        DenAssertSuccess(result, 0)
        XCTAssert(circuitBoard.digitsRegister.isEmpty)
        XCTAssertNil(circuitBoard.operatorRegister)
        XCTAssertNil(circuitBoard.intermediateRegister)
        XCTAssertEqual(circuitBoard.answerRegister, 0)
    }
    
    func testEqualKey() {
        var result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 0)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 1)
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 3)
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 3)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 2)
    }
    
    static var allTests = [
        ("testClearKey", testClearKey),
        ("testEqualKey", testEqualKey)
    ]
}
