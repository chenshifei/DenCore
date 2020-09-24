//
//  Arithmetic.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-21.
//

import Foundation

public enum CircuitBoardError: Error, Equatable {
    case ArgumentUnparseable(String)
    case ArgumentMissing, DividedByZero
}

public enum NumpadKey: Equatable {
    case digit(underlyingValue: Int)
    case separator
    
    var literalValue: String {
        switch self {
        case .digit(let i):
            return String(i)
        case .separator:
            return "."
        }
    }
}

public struct OperatorKey {
    public typealias OperationHandler = ([Double]) throws -> Double
    
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
    
    public let name: String
    public let arity: Arity
    public let operation: OperationHandler
}

public enum FunctionKey {
    case clear, equal
}

public final class CircuitBoard {
    public typealias CircuitBoardResult = (Double?, Error?)
    
    internal var digitsRegister = [NumpadKey]()
    internal var operatorRegister: OperatorKey?
    internal var answerRegister: Double = 0
    internal var intermediateRegister: Double?

    internal func parseDigits() throws -> Double {
        let newLiteralValue = digitsRegister.reduce("", { $0 + $1.literalValue })
        guard let result = Double(newLiteralValue) else {
            throw CircuitBoardError.ArgumentUnparseable(newLiteralValue)
        }
        return result
    }
    
    internal func prepareArgument() -> [Double] {
        defer {
            digitsRegister.removeAll()
        }
        var result = [Double]()
        
        if let r = intermediateRegister {
            result.append(r)
        }
        if let lastArgument = try? parseDigits() {
            result.append(lastArgument)
        }
        if result.isEmpty {
            result.append(answerRegister)
        }
        return result
    }
    
    internal func doCalculation(_ op: OperatorKey?) -> CircuitBoardResult {
        let args = prepareArgument()
        guard var result = args.first else {
            return (nil, CircuitBoardError.ArgumentMissing)
        }
        guard let op = op else {
            intermediateRegister = result
            return (result, nil)
        }
        
        do {
            if op.arity.numberOfArguments == args.count {
                result = try op.operation(args)
            } else {
                operatorRegister = op
            }
            intermediateRegister = result
            return (result, nil)
        } catch {
            return (nil, error)
        }
    }
    
    internal func clearAll() {
        digitsRegister.removeAll()
        operatorRegister = nil
        answerRegister = 0
        intermediateRegister = nil
    }
    
    public func numpadKeyPressed(key: NumpadKey) -> CircuitBoardResult {
        digitsRegister.append(key)
        if digitsRegister.filter({ $0 == .separator }).count > 1 {
            digitsRegister.removeLast()
        }
        do {
            let result = try parseDigits()
            return (result, nil)
        } catch {
            return (nil, error)
        }
    }
    
    public func operatorKeyPressed(key: OperatorKey) -> CircuitBoardResult {
        var result = doCalculation(operatorRegister)
        guard let _ = result.0, result.1 == nil else {
            return result
        }
        result = doCalculation(key)
        return result
    }
    
    internal func handleEnterKeyPressed() -> CircuitBoardResult {
        defer {
            intermediateRegister = nil
            operatorRegister = nil
        }
        
        let result = doCalculation(operatorRegister)
        if let answer  = result.0 {
            answerRegister = answer
        }
        return result
    }
    
    public func functionKeyPressed(key: FunctionKey) -> CircuitBoardResult {
        switch key {
        case .clear:
            clearAll()
            return (0, nil)
        case .equal:
            return handleEnterKeyPressed()
        }
    }
}
