//
//  Parser.swift
//  SwiftInterpreter
//
//  Created by Dylan Bourgeois on 06/10/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

/* Grammar :
** expression = signed_term sum_op
** sum_op = (+,-) term sum_op
** signed_term = (+,-) term
** term = factor term_op
** term_op = (*,/) factor term_op
** signed_factor = (+/-) factor
** factor = argument factor_op
** factor_op = ^ expr
** expr = number
*/

import Foundation

class Parse {
    var tokens:Array<Token>
    var lookahead:Token
    
    init(_ lexTokens:[Token])
    {
        self.tokens = lexTokens
        self.lookahead = self.tokens[0]
        
    }
    
    func parse()->ExpressionNode
    {
     
        switch self.lookahead
        {
        case .End():
            return expression()
        case _:
            return expression()

        }
    }
    
    func expression()->ExpressionNode
    {
        return sumOp(signedTerm())
    }
    
    func signedTerm()->ExpressionNode
    {
        switch self.lookahead
        {
        case .Operator(op: "+"):
            nextToken()
            return term()
        case .Operator(op: "-"):
            nextToken()
            return AdditionExpression(term(), false)
        case _ :
            return term()
        }
    }
    
    func sumOp(expr:ExpressionNode) -> ExpressionNode
    {
        var sum:AdditionExpression = AdditionExpression()
        
        switch self.lookahead
        {
        case .Operator(op: "+"):
            sum = AdditionExpression(expr,true)
            nextToken()
            sum.add(term(), true)
            return sumOp(sum)
        case .Operator(op: "-"):
            sum = AdditionExpression(expr, false)
            nextToken()
            sum.add(term(), false)
            return sumOp(sum)
        case _ :
            return expr
        }
        
    }
    
    func term()->ExpressionNode
    {

        return termOp(factor())
    }
    
    func termOp(expr:ExpressionNode)->ExpressionNode
    {
        var prod:MultiplicationExpression = MultiplicationExpression()

        switch self.lookahead
        {
        case .Operator(op: "*"):
            prod = MultiplicationExpression(expr,true)
            nextToken()
            prod.add(signedFactor(),true)
            return termOp(prod)
            
        case .Operator(op: "/"):
            prod = MultiplicationExpression(expr,true)
            nextToken()
            prod.add(signedFactor(),false)
            return termOp(prod)
        case _ :
            return expr
        }
    }
    
    func signedFactor()->ExpressionNode
    {
        switch self.lookahead
        {
        case .Operator(op: "+"):
            nextToken()
            return factor()
        case .Operator(op: "-"):
            nextToken()
            return AdditionExpression(factor(), false)
        case _ :
            return factor()
        }
    }
    
    func factor ()->ExpressionNode
    {
        return factorOp(argument())
    }
    
    func factorOp(expr:ExpressionNode)->ExpressionNode
    {
        switch self.lookahead
        {
        case .Operator(op: "^"):
            nextToken()
            return ExponentialExpression(expr, signedFactor())
        case _ :
            return expr
        }
    }
    
    func argument()->ExpressionNode
    {
        // Future impl will include functions + vars 
        
        switch self.lookahead
        {
            case .Operator("("),.Operator(")"):
                nextToken()
                let expr:ExpressionNode=expression()
                switch self.lookahead
                {
                case .Operator(")"):
                        nextToken()
                    return expr
                case _:
                    println("Expected closing bracket !")
                    return expr
                }
            case .Identifier:
                let function:Function = FunctionExpressionNode.stringToFunc(lookahead.stringValue())
                nextToken()
                if (function != Function.unknown)
                {
                    return FunctionExpressionNode(function,argument())
                }
                else {
                    return value()
                }
            case _:
                return value()
        }
        
    }
    
    func value()->ExpressionNode
    {
        switch self.lookahead
        {
        case .FloatLit, .IntegerLit:
            let expr = ConstantExpressionNode(self.lookahead.doubleValue())
            nextToken()
            return expr
        case .End() :
            println("Unexpected EOF")
            return ConstantExpressionNode(0)
        case _:
            return ConstantExpressionNode(0)
        }
    }
    
    //Utility
    func nextToken()
    {
        self.tokens.removeAtIndex(0)
        
        self.lookahead = self.tokens.isEmpty ? Token.End() : self.tokens[0]
    }
}
