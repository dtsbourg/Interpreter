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

protocol ExpressionNode {
    func getType()->Node
    func getValue()->Float
}


class ConstantExpressionNode:ExpressionNode {
    private let value:Double
    
    init (_ val:Double)
    {
        self.value = val
    }
    
    //String const ?
    
    func getValue() -> Float {
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
    }

    func getType()-> ExpressionNode
    {
        
    }
    
    func setValue(val:Double)
    {
        self.value = val
        self.valueSet = true
    }
    
    func getValue() -> Float
    {
        if (self.valueSet)
        {
            return self.value
        }
        else
        {
            println("Error: variable \(name) not set")
        }
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

class SequenceExpressionNode : ExpressionNode
{
    private let terms:Array<Term>
    
    init(_ ) {
        self.terms = Array<Term>()
    }
    
    init(_ a:ExpressionNode, _ p:Bool) {
        self.terms = Array<Term>
        self.terms.append(Term(p,a))
    }
    
    func add(a : ExpressionNode, _ p:Bool) {
        self.terms.append(Term(p,a))
    }
}

class AdditionExpression : SequenceExpressionNode
{
    init(_){}
    
    init(_ a:ExpressionNode, _ p:Bool)
    {
        self = SequenceExpressionNode(a,p)
    }
    
    func getType()->Node {
        return Node.Addition
    }
    
    func getValue()->Double {
        var sum = 0.0
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

class MultiplicationExpression : SequenceExpressionNode
{
    init(_) {}
    
    init(_ a:ExpressionNode, _ p:Bool)
    {
        self = SequenceExpressionNode(a,p)
    }
    
    func getType()->Node {
        return Node.Multiplication
    }
    
    func getValue() -> Double {
        var mult = 1.0
        for t in self.terms
        {
            if (t.positive)
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

class ExponentialExpression :SequenceExpressionNode
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

