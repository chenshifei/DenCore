//
//  OperatorTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-29.
//

import XCTest
@testable import DenCore

final class OperatorsKeysTest: XCTestCase {
    var processor = Processor()
    
    override func setUp() {
        processor = Processor()
    }
    
    func testInsertZeroBeforeDirectOperator() {
        var result = processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertSuccess(result, 0)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 1)
    }
    
    func testContinousOperator() {
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertSuccess(result, 1)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.substract)
        DenAssertSuccess(result, 3)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 4))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.multiply)
        DenAssertSuccess(result, -1)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 4))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, -4)
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertSuccess(result, -4)
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.multiply)
        DenAssertSuccess(result, -4)
    }
    
    func testDirectEqualAfterOperator() {
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertSuccess(result, 11)
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 11)
    }

    static var allTests = [
        ("testInsertZeroBeforeDirectOperator", testInsertZeroBeforeDirectOperator),
        ("testContinousOperator", testContinousOperator),
        ("testDirectEqualAfterOperator", testDirectEqualAfterOperator)
    ]
}
