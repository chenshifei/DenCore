//
//  CircuitBoardTest.swift
//  DenCoreTests
//
//  Created by Shifei Chen on 2020-10-04.
//

import XCTest
@testable import DenCore

final class MockDisplay: DisplayUnit {
    
    var display: String = ""
    
    var enabledOperatorKeys: [OperatorKey] = [DefaultKeys.Operator.add]
    
    var customizedKey: CustomizedKey?
    
    var customizedKeyPressCount = 0
    
    func numericOutputDelivered(_ result: ProcessorResult) {
        onResultsDelivered(result)
    }
    
    func equationEvaluated(result: ProcessorResult) {
        onResultsDelivered(result)
    }
    
    func reset() {
        display = ""
        customizedKeyPressCount = 0
    }
    
    func customizedKeyPressed() {
        customizedKeyPressCount += 1
    }
        
    private func onResultsDelivered(_ result: ProcessorResult) {
        if let error = result.1 {
            display = error.localizedDescription
        } else if let number = result.0 {
            display = String(number)
        }
    }
    
}

final class MockKeyboard: KeyboardUnit {
    
    var operatorKeys = [OperatorKey]()
    var customizedKey: CustomizedKey?
    
    func installCustomizedKey(_ customizedKey: CustomizedKey) {
        self.customizedKey = customizedKey
    }
    
    func customizedKey(enable: Bool) {
        self.customizedKey?.enabled = enable
    }
    
    func installOperatorKeys(_ operatorKeys: [OperatorKey]) {
        self.operatorKeys = operatorKeys
    }
}

final class CircuitBoardTest: XCTestCase {
    var circuitBoard = CircuitBoard()
    
    override func setUp() {
        circuitBoard = CircuitBoard()
    }
    
    func testInstallDisplayUnit() {
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        XCTAssertEqual(circuitBoard.processor.digitsRegister, [.digit(underlyingValue: 1)])
        
        let mockDisplay = MockDisplay()
        let mockKeyboard = MockKeyboard()
        circuitBoard.displayUnit = mockDisplay
        circuitBoard.keyboardUnit = mockKeyboard
        XCTAssertEqual(circuitBoard.processor.digitsRegister, [])
        XCTAssertEqual(mockKeyboard.operatorKeys.first?.name, mockDisplay.enabledOperatorKeys.first?.name)
        
        let customizedKeyName = "stringify"
        mockDisplay.customizedKey = CustomizedKey(name: customizedKeyName)
        circuitBoard.displayUnit = mockDisplay
        XCTAssertEqual(mockKeyboard.customizedKey?.name, customizedKeyName)
    
        mockDisplay.customizedKey = nil
        circuitBoard.displayUnit = mockDisplay
        XCTAssertEqual(mockKeyboard.customizedKey?.name, CircuitBoard.defaultCustomizedKey.name)
    }
    
    func testOnNumpadKeyPressed() {
        let mockDisplay = MockDisplay()
        let mockKeyboard = MockKeyboard()
        circuitBoard.displayUnit = mockDisplay
        circuitBoard.keyboardUnit = mockKeyboard
        
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        XCTAssertEqual(mockDisplay.display, "1.0")
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        XCTAssertEqual(mockDisplay.display, "11.0")
        circuitBoard.onNumpadKeyPressed(.separator)
        XCTAssertEqual(mockDisplay.display, "11.0")
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        XCTAssertEqual(mockDisplay.display, "11.1")
    }
    
    func testOnOperatorKeyPressed() {
        let mockDisplay = MockDisplay()
        let mockKeyboard = MockKeyboard()
        circuitBoard.displayUnit = mockDisplay
        circuitBoard.keyboardUnit = mockKeyboard
        
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        circuitBoard.onNumpadKeyPressed(.separator)
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        circuitBoard.onOperatorKeyPressed(DefaultKeys.Operator.add)
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        circuitBoard.onNumpadKeyPressed(.separator)
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        XCTAssertEqual(mockDisplay.display, "1.1")
        circuitBoard.onOperatorKeyPressed(DefaultKeys.Operator.add)
        XCTAssertEqual(mockDisplay.display, "12.2")
    }
    
    func testOnFunctionKeyPressed() {
        let mockDisplay = MockDisplay()
        let mockKeyboard = MockKeyboard()
        circuitBoard.displayUnit = mockDisplay
        circuitBoard.keyboardUnit = mockKeyboard
        
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        circuitBoard.onNumpadKeyPressed(.separator)
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        circuitBoard.onOperatorKeyPressed(DefaultKeys.Operator.add)
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        circuitBoard.onNumpadKeyPressed(.separator)
        circuitBoard.onNumpadKeyPressed(.digit(underlyingValue: 1))
        XCTAssertEqual(mockDisplay.display, "1.1")
        circuitBoard.onFunctionKeyPressed(.equal)
        XCTAssertEqual(mockDisplay.display, "12.2")
        circuitBoard.onFunctionKeyPressed(.clear)
        XCTAssertEqual(mockDisplay.display, "")
    }
    
    func testOnCustomizedKeyPressed() {
        let mockDisplay = MockDisplay()
        let mockKeyboard = MockKeyboard()
        circuitBoard.displayUnit = mockDisplay
        circuitBoard.keyboardUnit = mockKeyboard
        
        XCTAssertEqual(mockDisplay.customizedKeyPressCount, 0)
        circuitBoard.onCustomizedKeyPressed()
        XCTAssertEqual(mockDisplay.customizedKeyPressCount, 0)
        mockDisplay.customizedKey = CustomizedKey(name: "stringify")
        circuitBoard.displayUnit = mockDisplay
        circuitBoard.onCustomizedKeyPressed()
        XCTAssertEqual(mockDisplay.customizedKeyPressCount, 1)
        mockDisplay.customizedKey?.enabled = false
        circuitBoard.onCustomizedKeyPressed()
        XCTAssertEqual(mockDisplay.customizedKeyPressCount, 1)
        circuitBoard.onFunctionKeyPressed(.clear)
        XCTAssertEqual(mockDisplay.customizedKeyPressCount, 0)
    }
    
    func testEnableCustomizedKey() {
        let mockDisplay = MockDisplay()
        mockDisplay.customizedKey = CustomizedKey(name: "stringify")
        let mockKeyboard = MockKeyboard()
        circuitBoard.displayUnit = mockDisplay
        circuitBoard.keyboardUnit = mockKeyboard
        XCTAssert(mockKeyboard.customizedKey?.enabled ?? false)
        circuitBoard.customizedKey(enable: false)
        XCTAssertFalse(mockKeyboard.customizedKey?.enabled ?? true)
    }
}
