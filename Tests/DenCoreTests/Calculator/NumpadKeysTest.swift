import XCTest
@testable import DenCore

final class NumpadKeysTest: XCTestCase {
    var processor = Processor()
    
    override func setUp() {
        processor = Processor()
    }
    
    func testNumpadKeyName() {
        var value = 1
        var key = NumpadKey.digit(underlyingValue: value)
        XCTAssertEqual(key.name, String(value))
        value = -21
        key = NumpadKey.digit(underlyingValue: value)
        XCTAssertEqual(key.name, String(value))
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
        DenAssertFailure(result, ProcessorError.ArgumentUnparseable("11-21"))
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
        ("testNumberKeyName", testNumpadKeyName),
        ("testParseNum", testParseNum),
        ("testInsertZeroBeforeDirectSpearator", testInsertZeroBeforeDirectSpearator),
        ("testMultipleSeparator", testMultipleSeparator),
        ("testMultipleZeroBeforeSignificand", testMultipleZeroBeforeSignificand)
    ]
}
