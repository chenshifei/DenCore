//
//  CircuitBoardComponents.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-10-04.
//

import Foundation

// MARK: - CircuitBoard provider & consumers

/// Protocol for the owner of the `CircuitBoard`.
public protocol CircuitBoardSocket {
    
    /// The `CircuitBoard` provided by its owner, may not be `nil`.
    var circuitBoard: CircuitBoard! { get }
}

/// Protocol for the components.
/// They don't own the `Circuitboard`, instead other `CircuitBoardSocket` objects should inject it into them.
/// - Note: Instances implementing this protocol should keep a weak references to the `CircuitBoard` object.
public protocol CircuitBoardPin {
    
    /// Injects a `CircuitBoard` object into it.
    /// - Parameter circuitBoard: The `CircuitBoard` object to inject.
    func installOnCircuitBoard(_ circuitBoard: CircuitBoard)
}

// MARK: - DisplayUnit

/// A `DisplayUnit` is an object responsible for displying the calculation output.
/// They could also have an optional `CustomizedKey` object to extend the calcualtor's functionality.
public protocol DisplayUnit {
    
    /// Allowed `OperatorKeys`. For example some displayunit may disable the default `sin` operator.
    var enabledOperatorKeys: [OperatorKey] { get }
    
    /// A customizable key to extend the calcualtor's functionality.
    var customizedKey: CustomizedKey? { get }
    
    /// Handles when a number result is delivered.
    /// - Parameter result: The delivered result, may contains an error.
    func numericOutputDelivered(_ result: ProcessorResult)
    
    /// Handles when the `Equal` function key is pressed. Indicates an euqation has been evaluated.
    /// - Parameter result: The  result from the equation, may contains an error.
    func equationEvaluated(result: ProcessorResult)
    
    /// Resets the display unit to its initial state. Called when the clear key is pressed.
    func reset()
    
    /// Handels when the customized key is pressed.
    /// - Note: The display unit itself should be responsible for any errors that might happen.
    func customizedKeyPressed()
}

// MARK: - KeyboardUnit

/// A `KeyboardUnit` is an object that handels all the inputs of the calculator.
public protocol KeyboardUnit {
    
    /// Install a customized key on the keyboard.
    /// - Parameter customizedKey: The customized key to install
    func installCustomizedKey(_ customizedKey: CustomizedKey)
    
    /// Enable / Disable the customized key. Once it is disabled, it will not longer listen to keyboard events.
    /// - Parameter enable: `true` to enable it, otherwise `false` to disable it.
    func customizedKey(enable: Bool)
    
    /// Install the default operator keys onto the keyboard.
    /// - Parameter operatorKeys: The default operators to be installed.
    func installOperatorKeys(_ operatorKeys: [OperatorKey])
}

// MARK: - CircuitBoard

/// A `Circuitboard` object is responsible for handeling the communication between the input `KeyboardUnit` and the output `DisplayUnit`.
public class CircuitBoard {
    
    public static let defaultCustomizedKey = CustomizedKey(name: "func", enabled: false)
    
    // MARK: Properties
    
    /// The internal processor
    internal var processor = Processor()
    
    /// The display unit.
    /// After setting it, the default operator keys and the customized key will be installed on the keyboard unit.
    /// - Note: The display unit is not required. If it is not set, circuit board will discard all the output results.
    public var displayUnit: DisplayUnit? {
        didSet {
            if let displayUnit = displayUnit {
                installDisplayUnit(displayUnit)
            }
        }
    }
    
    /// The keyboard unit.
    /// After setting it, the default operator keys and the customized key from the current display unit will be installed on the keyboard unit.
    public var keyboardUnit: KeyboardUnit? {
        didSet {
            if let displayUnit = displayUnit {
                installDisplayUnit(displayUnit)
            }
        }
    }
    
    // MARK: Initializers()
    
    public init() {}
    
    // MARK: Functions
    
    /// Installs the default operator keys and the customized key (if exists) from the display unit to the keyboard unit.
    /// - Parameter newDisplayUnit: The display unit to be installed.
    internal func installDisplayUnit(_ newDisplayUnit: DisplayUnit) {
        // Clear the processor states first.
        onFunctionKeyPressed(.clear)
        if let keyboard = keyboardUnit {
            keyboard.installOperatorKeys(newDisplayUnit.enabledOperatorKeys)
            let customizedKey = newDisplayUnit.customizedKey ?? CircuitBoard.defaultCustomizedKey
            keyboard.installCustomizedKey(customizedKey)
            keyboard.customizedKey(enable: customizedKey.enabled)
        }
    }
    
    /// Enable / Disable the customized key on the keyboard.
    /// - Parameter enable: `Bool` value indicating enable or not
    public func customizedKey(enable: Bool) {
        if let keyboard = keyboardUnit {
            keyboard.customizedKey(enable: enable)
        }
    }
    
    /// Handels when a numpad key is pressed on the keyboard.
    /// - Parameter key: The  pressed`NumpadKey`.
    public func onNumpadKeyPressed(_ key: NumpadKey) {
        let result = processor.numpadKeyPressed(key: key)
        displayUnit?.numericOutputDelivered(result)
    }
    
    /// Handels when a opeartor key is pressed on the keyboard.
    /// - Parameter key: The  pressed`OperatorKey`.
    public func onOperatorKeyPressed(_ key: OperatorKey) {
        let result = processor.operatorKeyPressed(key: key)
        displayUnit?.numericOutputDelivered(result)
    }
    
    /// Handels when the customized key is pressed on the keyboard.
    public func onCustomizedKeyPressed() {
        if displayUnit?.customizedKey?.enabled ?? false {
            displayUnit?.customizedKeyPressed()
        }
    }
    
    /// Handels when a function key is pressed on the keyboard.
    /// - Parameter key: The  pressed`FunctionKey`.
    public func onFunctionKeyPressed(_ key: FunctionKey) {
        let result = processor.functionKeyPressed(key: key)
        switch key {
        case .equal:
            displayUnit?.equationEvaluated(result: result)
        case .clear:
            displayUnit?.reset()
        }
    }
}
