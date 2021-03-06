//
//  Arithmetic.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-21.
//

import Foundation

// MARK: - Result and Error Types

/// `tuple` type for retrieving the calculation result
/// - Note: Only one of the members will be returned
/// The first member is a `Double` type result, if the calculation is successful.
/// The second member is an `Error` only of the calculation failed. Detailed infomation can also be found in that `Error`.
public typealias ProcessorResult = Result<Double, Error>

/// `enum` type for possible errors that could occur during calculation
/// - Note: Overflow is not inlcuded as Swift will wrap Double overflow into `infinity`.
public enum ProcessorError: Error, Equatable {
    /// Case for unparseable number, e.g.  `"11-21"`, since input digits are parsed as `String`.
    case ArgumentUnparseable(String)
    /// Case for missing arguments when doing calculation.
    case ArgumentMissing
    /// Case for division by zero.
    case DividedByZero
}

// MARK: - Processor

/// The main class of the calculator
/// - Note: It can not be inherited.
public final class Processor {
    
    // MARK: Properties
    
    /// Temp memory of the input digits. Will be cleaned after an operator key or function key.
    internal var digitsRegister = [NumpadKey]()
    /// Temp memory for incompleted operator. Will be cleaned after the function key.
    internal var operatorRegister: OperatorKey?
    /// Temp memory for the last successful answer from pressing the equal key
    /// - Note: Default value is `0`.
    internal var answerRegister: Double = 0
    /// Temp memory for storing the intermediate result during a sequence of operators. e.g. `1+2+3+4`.
    internal var intermediateRegister: Double?
    
    // MARK: Initializers
    
    /// Default no parameter initializer
    public init() {}
    
    // MARK: Internal functions
    
    /// Parse the digits register as a complete number
    /// - Throws: `CircuitBoardError.ArgumentUnparseable(String)` if the parse fails.
    /// The digits failed to parse can be found in the associated `String` value.
    /// - Returns: The number parsed from the digits.
    /// - Note: This function uses `String` to parse the digits which isn't the most ideal. Will be changed in the future.
    internal func parseDigits() throws -> Double {
        let newLiteralValue = digitsRegister.reduce("", { $0 + $1.literalValue })
        /*
         Using `String` isn't the most safe method,
         but it's much easier to work with when dealing with separators.
         Will be changed in the future.
        */
        guard let result = Double(newLiteralValue) else {
            throw ProcessorError.ArgumentUnparseable(newLiteralValue)
        }
        return result
    }
    
    /// Prepares the arguments for the operator.
    /// - Returns: An array of `Double` arguments, either from last intermediate results, or input digits, or last successful equation.
    /// Earliest arguments appears in the first position.
    internal func prepareArgument() -> [Double] {
        defer {
            // Clean the digits register after preparing the arguments
            digitsRegister.removeAll()
        }
        
        var result = [Double]()
        
        // Read from intermediate results
        if let r = intermediateRegister {
            result.append(r)
        }
        // Read from input digits. If fails (e.g. direct "Add" after start) simply ignores it.
        if let lastArgument = try? parseDigits() {
            result.append(lastArgument)
        }
        // Read from the last success equation result
        if result.isEmpty {
            result.append(answerRegister)
        }
        return result
    }
    
    /// Run the actual calculation defined by the operator.
    /// - Parameter op: The operator to run
    /// - Returns: A tuple whose first member is the result if successes, second member is the error if fails.
    internal func doCalculation(_ op: OperatorKey?) -> ProcessorResult {
        let args = prepareArgument()
        guard var result = args.first else {
            // guard the argsments isn't empty
            return .failure(ProcessorError.ArgumentMissing)
        }
        guard let op = op else {
            // Check if the operator exits.
            // When no operator stores the parsed digits to the intermediate register
            // so that the digits register is ready for the next number
            intermediateRegister = result
            return .success(result)
        }
        
        do {
            if op.arity.numberOfArguments == args.count {
                // if the operator argument requirements fulfils.
                result = try op.operation(args)
            } else {
                // otherwise stores it and wait for the next argument
                operatorRegister = op
            }
            intermediateRegister = result
            return .success(result)
        } catch {
            // catches any error during operator calculation and returns it
            return .failure(error)
        }
    }
    
    /// Clean all of the memories. Return to the initial state.
    internal func clearAll() {
        digitsRegister.removeAll()
        operatorRegister = nil
        answerRegister = 0
        intermediateRegister = nil
    }
    
    // MARK: Key events
    
    /// Press a numpad key
    /// - Parameter key: The pressed key
    /// - Returns: A `tuple` which may contains the pressed digit (or a calculation result), or an error if anything wrong happens.
    public func numpadKeyPressed(key: NumpadKey) -> ProcessorResult {
        digitsRegister.append(key)
        if digitsRegister.filter({ $0 == .separator }).count > 1 {
            // Prevent input multiple separators
            digitsRegister.removeLast()
        }
        do {
            let result = try parseDigits()
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
    
    /// Press an operator key
    /// - Parameter key: The pressed key
    /// - Returns: A `tuple` which may contains a calculation result, or an error if anything wrong happens.
    public func operatorKeyPressed(key: OperatorKey) -> ProcessorResult {
        var result = doCalculation(operatorRegister)
        if case .failure = result {
            // guard nothing unexpected happened when executing the stored operator calculation
            return result
        }
        result = doCalculation(key)
        return result
    }
    
    /// Press the Equal key
    /// - Returns: A `tuple` which may contains a calculation result (or the number just entered), or an error if anything wrong happens.
    internal func handleEqualKeyPressed() -> ProcessorResult {
        defer {
            intermediateRegister = nil
            operatorRegister = nil
        }
        
        let result = doCalculation(operatorRegister)
        if case .success(let answer) = result {
            answerRegister = answer
        }
        return result
    }
    
    /// Press a function key
    /// - Parameter key: The pressed key
    /// - Returns: A `tuple` which may contains a calculation result (or the number just entered), or an error if anything wrong happens.
    public func functionKeyPressed(key: FunctionKey) -> ProcessorResult {
        switch key {
        case .clear:
            clearAll()
            return .success(0)
        case .equal:
            return handleEqualKeyPressed()
        }
    }
}
