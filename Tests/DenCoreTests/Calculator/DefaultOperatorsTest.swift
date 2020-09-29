//
//  DefaultOperatorsTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-09-22.
//

import XCTest
@testable import DenCore

final class DefaultOperatorsTest: XCTestCase {
    var circuitBoard = CircuitBoard()
    
    override func setUp() {
        circuitBoard = CircuitBoard()
    }
    
    func testDefaultAddOperator() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertSuccess(result, 11)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.numpadKeyPressed(key: .separator)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 33.33)
    }
    
    func testDefaultSubstractOperator() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.substract)
        DenAssertSuccess(result, 11)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.numpadKeyPressed(key: .separator)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, -11.33, accuracy: 1e-8)
    }
    
    func testDefaultMultiplyOperator() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.multiply)
        DenAssertSuccess(result, 11)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.numpadKeyPressed(key: .separator)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 3))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 245.63)
    }
    
    func testDefaultDivideOperator() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.divide)
        DenAssertSuccess(result, 11)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 2))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 5.5)
        
        result = circuitBoard.functionKeyPressed(key: .clear)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.divide)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 0))
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertFailure(result, CircuitBoardError.DividedByZero)
        
        result = circuitBoard.functionKeyPressed(key: .clear)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.multiply)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.divide)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 0))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        DenAssertFailure(result, CircuitBoardError.DividedByZero)
    }
    
    func testDefaultSinOperator() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.sin)
        DenAssertSuccess(result, 0.19080899537, accuracy: 1e-8)
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 0.19080899537, accuracy: 1e-8)
        
        result = circuitBoard.functionKeyPressed(key: .clear)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.sin)
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 0.01745240643, accuracy: 1e-8)
    }
    
    func testDefaultCosOperator() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.cos)
        DenAssertSuccess(result, 0.98162718344, accuracy: 1e-8)
        result = circuitBoard.functionKeyPressed(key: .equal)
        DenAssertSuccess(result, 0.98162718344, accuracy: 1e-8)
        
        result = circuitBoard.functionKeyPressed(key: .clear)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.add)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.operatorKeyPressed(key: DefaultKeys.Operator.cos)
        result = circuitBoard.functionKeyPressed(key: .equal)
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

