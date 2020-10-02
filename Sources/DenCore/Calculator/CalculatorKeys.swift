//
//  CalculatorKeys.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-10-02.
//

import Foundation

// MARK: - Calculator Keys

/// Protocol to define a calculator key.
public protocol CalculatorKey {
    /// The name of the key
    var name: String { get }
}

/// `enum` type for keys on the calculator numpad. Possible values are numbers and separators.
/// - Warning: When initializing instances with numbers, it is possible to provide a value other than digits `0` to `9`,
/// e.g. `11`, as a shortcut to input large numbers, but this could result in an unparseable argument. Use at your own risk
public enum NumpadKey: Equatable, CalculatorKey {
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

/// `struct` type for operator keys, e.g. + (add).
public struct OperatorKey: CalculatorKey {
    /// A block called to execute the actual calculation.
    /// - Parameters: An array of `Double` as the calulation arguments.
    /// - Returns: A `Double` number indicating the calculation result.
    /// - Throws: `error` when calculation fails, e.g. division by zero.
    public typealias OperatorKeyHandler = ([Double]) throws -> Double
    
    /// `enum` type to define if the operator is an unary or  binary one.
    public enum Arity {
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
    public let arity: Arity
    /// The actual calculation process.
    public let operation: OperatorKeyHandler
    
    /// Default initializer.
    /// - Parameters:
    ///   - name: The name of the operator.
    ///   - arity: Either a `.binary` operator or an `.unary` one.
    ///   - operation: A block to define the actual operator calculation
    public init(name: String, arity: Arity, operation: @escaping OperatorKeyHandler) {
        self.name = name
        self.arity = arity
        self.operation = operation
    }
}

/// `enum` type for the function keys on the calculator. Currently only two types are defined: "clear" and "equal"
public enum FunctionKey: CalculatorKey {
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

/// A customized key can be used to extend the calculator's function, even beyond numeric calculations
public struct CustomizedKey: CalculatorKey {
    
    /// The name of the customized key.
    public let name: String
    
    /// The default initializer
    /// - Parameters:
    ///   - name: The name of the customized key.
    public init(name: String) {
        self.name = name
    }
}
