import XCTest
@testable import DenCore

final class NumpadKeysTest: XCTestCase {
    var processor = Processor()
    
    override func setUp() {
        processor = Processor()
    }
    
    func testNumpadKeyName() {
        var key = NumpadKey.digit(underlyingValue: 1)
        XCTAssertEqual(key.name, "1")
        key = NumpadKey.digit(underlyingValue: -21)
        XCTAssertEqual(key.name, "-21")
    }
    
    func testParseNum() {
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 1)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 11)
        result = processor.numpadKeyPressed(key: .separator)
        DenAssertSuccess(result, 11)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 0))
        DenAssertSuccess(result, 11)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 11.01)
    }
    
    func testParseNumNotInZeroToNine() {
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 11))
        DenAssertSuccess(result, 11)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: -21))
        DenAssertFailure(result, CircuitBoardError.ArgumentUnparseable("11-21"))
    }
    
    func testInsertZeroBeforeDirectSpearator() {
        var result = processor.numpadKeyPressed(key: .separator)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 0.1)
    }
    
    func testMultipleSeparator() {
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.numpadKeyPressed(key: .separator)
        result = processor.numpadKeyPressed(key: .separator)
        DenAssertSuccess(result, 1)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        result = processor.numpadKeyPressed(key: .separator)
        DenAssertSuccess(result, 1.1)
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 1.11)
    }
    
    func testMultipleZeroBeforeSignificand() {
        var result = processor.numpadKeyPressed(key: .digit(underlyingValue: 0))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 0))
        result = processor.numpadKeyPressed(key: .digit(underlyingValue: 1))
        DenAssertSuccess(result, 1)
    }

    static var allTests = [
        ("testNumberKeyName", testNumberKeyName),
        ("testParseNum", testParseNum),
        ("testInsertZeroBeforeDirectSpearator", testInsertZeroBeforeDirectSpearator),
        ("testMultipleSeparator", testMultipleSeparator),
        ("testMultipleZeroBeforeSignificand", testMultipleZeroBeforeSignificand)
    ]
}
