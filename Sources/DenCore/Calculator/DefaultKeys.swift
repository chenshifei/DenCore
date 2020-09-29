//
//  DefaultOperators.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-22.
//

import Foundation

public struct DefaultKeys {
    public struct Operator {
        public static let add = OperatorKey(name: "+", arity: .binary) { args in
            let lhs = args[0], rhs = args[1]
            return lhs + rhs
        }
        
        public static let substract = OperatorKey(name: "-", arity: .binary) { args in
            let lhs = args[0], rhs = args[1]
            return lhs - rhs
        }
        
        public static let multiply = OperatorKey(name: "*", arity: .binary) { args in
            let lhs = args[0], rhs = args[1]
            return lhs * rhs
        }
        
        public static let divide = OperatorKey(name: "/", arity: .binary) { args in
            let lhs = args[0], rhs = args[1]
            guard rhs != 0 else { throw CircuitBoardError.DividedByZero }
            return lhs / rhs
        }
        
        public static let sin = OperatorKey(name: "sin", arity: .unary) { args in
            let lhs = args[0]
            return Darwin.sin(lhs * Double.pi / 180)
        }
        
        public static let cos = OperatorKey(name: "cos", arity: .unary) { args in
            let lhs = args[0]
            return Darwin.cos(lhs * Double.pi / 180)
        }
    }
}
