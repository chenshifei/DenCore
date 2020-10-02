//
//  DefaultOperatorsTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-22.
//

import XCTest
@testable import DenCore

final class DefaultOperatorsTest: XCTestCase {
    var processor = Processor()
    
    override func setUp() {
        processor = Processor()
    }
    
    func testDefaultAddOperator() {
        let key = DefaultKeys.Operator.add
        XCTAssertEqual(key.name, "+")
        XCTAssertEqual(key.arity.numberOfArguments, 2)
        
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: key)
        DenAssertSuccess(result, 11)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.numpadKeyPressed(key: .separator)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 33.33)
    }
    
    func testDefaultSubstractOperator() {
        let key = DefaultKeys.Operator.substract
        XCTAssertEqual(key.name, "-")
        XCTAssertEqual(key.arity.numberOfArguments, 2)
        
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: key)
        DenAssertSuccess(result, 11)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.numpadKeyPressed(key: .separator)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, -11.33, accuracy: 1e-8)
    }
    
    func testDefaultMultiplyOperator() {
        let key = DefaultKeys.Operator.multiply
        XCTAssertEqual(key.name, "*")
        XCTAssertEqual(key.arity.numberOfArguments, 2)
        
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: key)
        DenAssertSuccess(result, 11)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.numpadKeyPressed(key: .separator)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 245.63)
    }
    
    func testDefaultDivideOperator() {
        let key = DefaultKeys.Operator.divide
        XCTAssertEqual(key.name, "/")
        XCTAssertEqual(key.arity.numberOfArguments, 2)
        
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: key)
        DenAssertSuccess(result, 11)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 5.5)
        
        result = processor.functionKeyPressed(key: .clear)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.divide)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 0))
        result = processor.functionKeyPressed(key: .equal)
        DenAssertFailure(result, ProcessorError.DividedByZero)
        
        result = processor.functionKeyPressed(key: .clear)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.multiply)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.divide)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 0))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertFailure(result, ProcessorError.DividedByZero)
    }
    
    func testDefaultSinOperator() {
        let key = DefaultKeys.Operator.sin
        XCTAssertEqual(key.name, "sin")
        XCTAssertEqual(key.arity.numberOfArguments, 1)
        
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: key)
        DenAssertSuccess(result, 0.19080899537, accuracy: 1e-8)
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 0.19080899537, accuracy: 1e-8)
        
        result = processor.functionKeyPressed(key: .clear)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.sin)
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 0.01745240643, accuracy: 1e-8)
    }
    
    func testDefaultCosOperator() {
        let key = DefaultKeys.Operator.cos
        XCTAssertEqual(key.name, "cos")
        XCTAssertEqual(key.arity.numberOfArguments, 1)
        
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: key)
        DenAssertSuccess(result, 0.98162718344, accuracy: 1e-8)
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 0.98162718344, accuracy: 1e-8)
        
        result = processor.functionKeyPressed(key: .clear)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.add)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.operatorKeyPressed(key: DefaultKeys.Operator.cos)
        result = processor.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 0.99939082701, accuracy: 1e-8)
    }
    
    static var allTests = [
        ("testDefaultAddOperator", testDefaultAddOperator),
        ("testDefaultSubstractOperator", testDefaultSubstractOperator),
        ("testDefaultMultiplyOperator", testDefaultMultiplyOperator),
        ("testDefaultDivideOperator", testDefaultDivideOperator),
        ("testDefaultSinOperator", testDefaultSinOperator),
        ("testDefaultCosOperator", testDefaultCosOperator),
    ]
}

