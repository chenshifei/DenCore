//
//  ArithmeticTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-23.
//

import XCTest
@testable import DenCore

final class FunctionKeysTest: XCTestCase {
    var processor = Processor()
    
    override func setUp() {
        processor = Processor()
    }
    
    func testClearKey() {
        let clearKey = FunctionKey.clear
        XCTAssertEqual(clearKey.name, "AC")
        
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.functionKeyPressed(key: .equal)
        result = processor.functionKeyPressed(key: .clear)
        DenAssertSuccess(result, 0)
        XCTAssert(processor.digitsRegister.isEmpty)
        XCTAssertNil(processor.operatorRegister)
        XCTAssertNil(processor.intermediateRegister)
        XCTAssertEqual(processor.answerRegister, 0)
    }
    
    func testEqualKey() {
        let equalKey = FunctionKey.equal
        XCTAssertEqual(equalKey.name, "=")
        
        var result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 0)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 1)
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 3)
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 3)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 2)
    }
    
    static var allTests = [
        ("testClearKey", testClearKey),
        ("testEqualKey", testEqualKey)
    ]
}
