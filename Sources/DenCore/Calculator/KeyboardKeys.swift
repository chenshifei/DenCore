//
//  CalculatorKeys.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-10-02.
//

import Foundation

// MARK: - Keyboard key

/// Protocol to define a calculator key.
internal protocol KeyboardKey {
    
    /// The name of the key
    var name: String { get }
}

// MARK: - Numpad key

/// `enum` type for keys on the calculator numpad. Possible values are numbers and separators.
/// - Warning: When initializing instances with numbers, it is possible to provide a value other than digits `0` to `9`,
/// e.g. `11`, as a shortcut to input large numbers, but this could result in an unparseable argument. Use at your own risk
public enum NumpadKey: Equatable, KeyboardKey {
    
    /// Case for digits.
    case digit(underlyingValue: Int)
    /// Case for separators.
    case separator
    
    /// The `String` value used when parsing numbers
    internal var literalValue: String {
        switch self {
        case .digit(let i):
            return String(i)
        case .separator:
            return "."
        }
    }
    
    public var name: String {
        literalValue
    }
}

// MARK: - Operator key

/// `struct` type for operator keys, e.g. + (add).
/// - Note: You are not intended to create your own operators. If so, pelase use `CustomizedKey` instead.
public struct OperatorKey: KeyboardKey {
    
    /// A block called to execute the actual calculation.
    /// - Parameters: An array of `Double` as the calulation arguments.
    /// - Returns: A `Double` number indicating the calculation result.
    /// - Throws: `error` when calculation fails, e.g. division by zero.
    internal typealias OperatorKeyHandler = ([Double]) throws -> Double
    
    /// `enum` type to define if the operator is an unary or  binary one.
    internal enum Arity {
        case unary, binary
        internal var numberOfArguments: Int {
            switch self {
            case .unary:
                return 1
            case .binary:
                return 2
            }
        }
    }
    
    /// The name of the operator
    public let name: String
    /// Number of arguments the operator needs
    internal let arity: Arity
    /// The actual calculation process.
    internal let operation: OperatorKeyHandler
    
    /// Default initializer.
    /// - Note: It is not intended to create your own operators. If so, please use `CustomizedKey` instead.
    /// - Parameters:
    ///   - name: The name of the operator.
    ///   - arity: Either a `.binary` operator or an `.unary` one.
    ///   - operation: A block to define the actual operator calculation
    internal init(name: String, arity: Arity, operation: @escaping OperatorKeyHandler) {
        self.name = name
        self.arity = arity
        self.operation = operation
    }
}

// MARK: - Function key

/// `enum` type for the function keys on the calculator. Currently only two types are defined: "clear" and "equal"
public enum FunctionKey: KeyboardKey {
    
    case clear, equal
    
    /// The name of the function key
    public var name: String {
        switch self {
        case .clear:
            return "AC"
        case .equal:
            return "="
        }
    }
}

// MARK: - Customized key

/// A customized key can be used to extend the calculator's function, even beyond numeric calculations
public struct CustomizedKey: KeyboardKey {
    
    /// The name of the customized key.
    public var name: String
    
    /// Tells if the key is enabled or not. Default = `true`
    public var enabled: Bool
    
    /// The default initializer
    /// - Parameters:
    ///   - name: The name of the customized key.
    public init(name: String, enabled: Bool = true) {
        self.name = name
        self.enabled = enabled
    }
}
