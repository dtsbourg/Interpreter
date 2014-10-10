//
//  ExpressionTree.swift
//  SwiftInterpreter
//
//  Created by Dylan Bourgeois on 10/10/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

import Foundation
import Darwin

enum Node:Int {
    case Variable
    case Constant
    case Addition
    case Multiplication
    case Exponential
    case Function
}

enum Function:Int {
    case sin
    case cos
    case tan
    
    case asin
    case acos
    case atan
    
    case sqrt
    case exp
    
    case ln
    case log
    case log2
    
    case unknown
}

protocol ExpressionNode {
    func getType()->Node
    func getValue()->Double
}


class ConstantExpressionNode:ExpressionNode {
    private let value:Double
    
    init (_ val:Double)
    {
        self.value = val
    }
    
    //String const ?
    
    func getValue() -> Double {
        return self.value
    }
    
    func getType() -> Node {
            return Node.Constant
    }
}

class VariableExpressionNode:ExpressionNode {
    private let name:String
    private var value:Double
    private var valueSet:Bool

    init (_ name:String)
    {
        self.name = name
        self.valueSet = false
        self.value = 0
    }

    func getType()->Node
    {
        return Node.Variable
    }
    
    func setValue(val:Double)
    {
        self.value = val
        self.valueSet = true
    }
    
    func getValue() -> Double
    {
        if (self.valueSet)
        {
            return self.value
        }
        else
        {
            println("Error: variable \(name) not set")
            return 0
        }
    }
}

class FunctionExpressionNode:ExpressionNode {
    private let function:Function
    private let argument:ExpressionNode
    
    init (_ f:Function,_ arg:ExpressionNode ) {
        self.function = f
        self.argument = arg
    }
    
    func getType() -> Node {
        return Node.Function
    }
    
    func getValue() -> Double {
        switch self.function
        {
        case .sin:
            return sin(self.argument.getValue())
        case .cos:
            return cos(self.argument.getValue())
        case .tan:
            return tan(self.argument.getValue())
        case .asin:
            return asin(self.argument.getValue())
        case .acos:
            return acos(self.argument.getValue())
        case .atan:
            return atan(self.argument.getValue())
        case .exp:
            return exp(self.argument.getValue())
        case .sqrt:
            return sqrt(self.argument.getValue())
        case .ln:
            return log(self.argument.getValue())
        case .log:
            return log(self.argument.getValue()) * 0.43429448190325182765
        case .log2:
            return log(self.argument.getValue()) * 1.442695040888963407360
        case _:
            println("Unknown function !")
            return 0
        }
    }
    
    class func stringToFunc(f:String) -> Function
    {
        switch f {
        case "sin":
            return Function.sin
        case "cos":
            return Function.cos
        case "tan":
            return Function.tan
        case "asin":
            return Function.acos
        case "acos":
            return Function.acos
        case "atan":
            return Function.atan
        case "sqrt":
            return Function.sqrt
        case "exp":
            return Function.exp
        case "ln":
            return Function.ln
        case "log":
            return Function.log
        case "log2":
            return Function.log2
        case _:
            return Function.unknown
        }
    }
    
    func getAllFuncs() -> String
    {
        return "sin|cos|tan|asin|acos|atan|sqrt|exp|ln|log|log2"
    }
}

class Term {
    var isPositive:Bool
    var expression:ExpressionNode
    
    init (_ p:Bool,_ e:ExpressionNode)
    {
        self.isPositive = p
        self.expression = e
    }
    
}


class AdditionExpression : ExpressionNode
{
 
    private var terms:Array<Term>
    
    init() {
        self.terms = Array<Term>()
    }
    
    init(_ a:ExpressionNode, _ p:Bool) {
        self.terms = Array<Term>()
        self.terms.append(Term(p,a))
    }
    
    func add(a : ExpressionNode, _ p:Bool) {
        self.terms.append(Term(p,a))
    }
    
    func getType()->Node {
        return Node.Addition
    }
    
    func getValue()->Double {
        var sum:Double = 0.0
        for t in self.terms
        {
            if (t.isPositive)
            {
                sum += t.expression.getValue()
            }
            else
            {
                sum -= t.expression.getValue()
            }
        }
        
        return sum
    }
}

class MultiplicationExpression : ExpressionNode
{
    private var terms:Array<Term>
    
    init() {
        self.terms = Array<Term>()
    }
    
    init(_ a:ExpressionNode, _ p:Bool) {
        self.terms = Array<Term>()
        self.terms.append(Term(p,a))
    }

    func add(a : ExpressionNode, _ p:Bool) {
        self.terms.append(Term(p,a))
    }
    
    func getType()->Node {
        return Node.Multiplication
    }
    
    func getValue() -> Double {
        var mult = 1.0
        for t in self.terms
        {
            if (t.isPositive)
            {
                mult *= t.expression.getValue()
            }
            else
            {
                mult /= t.expression.getValue()
            }
        }
        
        return mult
    }
}

class ExponentialExpression : ExpressionNode
{
    private let base:ExpressionNode
    private let exponent:ExpressionNode
    
    init(_ b:ExpressionNode, _ e:ExpressionNode)
    {
        self.base = b
        self.exponent = e
    }
    
    func getType() -> Node {
        return Node.Exponential
    }
    
    func getValue() -> Double {
        return pow(self.base.getValue(), self.exponent.getValue())
    }
}

