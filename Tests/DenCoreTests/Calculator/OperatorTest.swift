//
//  OperatorTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-29.
//

import XCTest
@testable import DenCore

final class OperatorsTest: XCTestCase {
    var circuitBoard = CircuitBoard()
    
    override func setUp() {
        circuitBoard = CircuitBoard()
    }
    
    func testInsertZeroBeforeDirectOperator() {
        var result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertSuccess(result, 0)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 1)
    }
    
    func testContinousOperator() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertSuccess(result, 1)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.substract)
        DenAssertSuccess(result, 3)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 4))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.multiply)
        DenAssertSuccess(result, -1)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 4))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, -4)
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertSuccess(result, -4)
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.multiply)
        DenAssertSuccess(result, -4)
    }
    
    func testDirectEqualAfterOperator() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertSuccess(result, 11)
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 11)
    }

    static var allTests = [
        ("testInsertZeroBeforeDirectOperator", testInsertZeroBeforeDirectOperator),
        ("testContinousOperator", testContinousOperator),
        ("testDirectEqualAfterOperator", testDirectEqualAfterOperator)
    ]
}
