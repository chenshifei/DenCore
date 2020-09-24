//
//  DefaultOperators.swift
//  DenCore
//
//  Created by Shifei Chen on 2020-09-22.
//

import Foundation

public struct DefaultOperatorKeys {
    public let add = OperatorKey(arity: .binary) { args in
        guard args.count == 2 else { throw CircuitBoardError.ArgumentMissing }
        return args.reduce(0, +)
    }
    
    public let substract = OperatorKey(arity: .binary) { args in
        guard args.count == 2 else { return 0 }
        return args.reduce(0, -)
    }
    
    public let multiply = OperatorKey(arity: .binary) { args in
        guard args.count == 2 else { return 0 }
        return args.reduce(0, *)
    }
    
    public let divide = OperatorKey(arity: .binary) { args in
        guard args.count == 2 else { return 0 }
        guard args.last != 0 else { return 0 }
        return args.reduce(0, /)
    }
    
    public let sin = OperatorKey(arity: .unary) { args in
        guard args.count == 1, let arg = args.first else { return 0 }
        return Darwin.sin(arg)
    }
    
    public let cos = OperatorKey(arity: .unary) { args in
        guard args.count == 1, let arg = args.first else { return 0 }
        return Darwin.cos(arg)
    }
}
