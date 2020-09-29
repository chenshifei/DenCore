//
//  DefaultOperators.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-22.
//

import Foundation

/// Pre-defined calculator keys
public struct DefaultKeys {
    /// Pre-defined calculator operators
    public struct Operator {
        /// Add, e.g. `1+1=2`
        public static let add = OperatorKey(name: "+", arity: .binary) { args in
            let lhs = args[0], rhs = args[1]
            return lhs + rhs
        }
        
        /// Substract, e.g. `1-1=0`
        public static let substract = OperatorKey(name: "-", arity: .binary) { args in
            let lhs = args[0], rhs = args[1]
            return lhs - rhs
        }
        
        /// Multiply, e.g. `1*1=1`
        public static let multiply = OperatorKey(name: "*", arity: .binary) { args in
            let lhs = args[0], rhs = args[1]
            return lhs * rhs
        }
        
        /// Divide, e.g. `1/1=1`
        /// - Warning: the second argument, divisor, should not be `0`,
        /// otherwise will case a `CircuitBoardError.DividedByZero` error
        public static let divide = OperatorKey(name: "/", arity: .binary) { args in
            let lhs = args[0], rhs = args[1]
            guard rhs != 0 else { throw CircuitBoardError.DividedByZero }
            return lhs / rhs
        }
        
        /// sin, e.g. `sin(90)=1`
        /// - Note: argument is treated as degrees
        public static let sin = OperatorKey(name: "sin", arity: .unary) { args in
            let lhs = args[0]
            return Darwin.sin(lhs * Double.pi / 180)
        }
        
        /// cos, e.g. `cos(90)=0`
        /// - Note: argument is treated as degrees
        public static let cos = OperatorKey(name: "cos", arity: .unary) { args in
            let lhs = args[0]
            return Darwin.cos(lhs * Double.pi / 180)
        }
    }
}
