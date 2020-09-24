import XCTest
@testable import DenCore

final class NumberKeysTest: XCTestCase {
    var circuitBoard = CircuitBoard()
    
    override func setUp() {
        circuitBoard = CircuitBoard()
    }
    
    func testParseNum() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 1)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 11)
        result = circuitBoard.numpadKeyPressed(key: .separator)
        DenAssertSuccess(result, 11)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 0))
        DenAssertSuccess(result, 11)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 11.01)
    }
    
    func testParseNumNotInZeroToNine() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 11))
        DenAssertSuccess(result, 11)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: -21))
        DenAssertFailure(result, CircuitBoardError.ArgumentUnparseable("11-21"))
    }
    
    func testInsertZeroBeforeDirectSpearator() {
        var result = circuitBoard.numpadKeyPressed(key: .separator)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 0.1)
    }
    
    func testMultipleSeparator() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.numpadKeyPressed(key: .separator)
        result = circuitBoard.numpadKeyPressed(key: .separator)
        DenAssertSuccess(result, 1)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = circuitBoard.numpadKeyPressed(key: .separator)
        DenAssertSuccess(result, 1.1)
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 1.11)
    }
    
    func testMultipleZeroBeforeSignificand() {
        var result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 0))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 0))
        result = circuitBoard.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 1)
    }

    static var allTests = [
        ("testParseNum", testParseNum),
        ("testInsertZeroBeforeDirectSpearator", testInsertZeroBeforeDirectSpearator),
        ("testMultipleSeparator", testMultipleSeparator),
        ("testMultipleZeroBeforeSignificand", testMultipleZeroBeforeSignificand)
    ]
}
