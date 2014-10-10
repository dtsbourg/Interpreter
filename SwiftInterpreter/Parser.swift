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

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}


class Parse {
    var tokens:Array<Token>
    var lookahead:Token
    
    init(_ lexTokens:[Token])
    {
        self.tokens = lexTokens
        self.lookahead = self.tokens[0]
        
    }
    
    func parse()
    {
        expression()
        
        switch self.lookahead
        {
        case .End():
            println("We're cool")
        case _:
            println("There's a pb \(self.lookahead.description())")
        }
    }
    
    func expression()
    {
        signedTerm()
        sumOp()
    }
    
    func signedTerm()
    {
        switch self.lookahead
        {
        case .Operator(op: "+"),.Operator(op: "-"):
            nextToken()
            term()
        case _ :
            term()
        }
    }
    
    func sumOp()
    {
        switch self.lookahead
        {
        case .Operator(op: "+"),.Operator(op: "-"):
            nextToken()
            term()
            sumOp()
        case _ :
            println("End 0")
        }
        
    }
    
    func term()
    {
        factor()
        termOp()
    }
    
    func termOp()
    {
        switch self.lookahead
        {
        case .Operator(op: "*"),.Operator(op: "/"):
            nextToken()
            signedFactor()
            termOp()
        case _ :
            println("End 1")
        }
    }
    
    func signedFactor()
    {
        switch self.lookahead
        {
        case .Operator(op: "+"),.Operator(op: "-"):
            nextToken()
            factor()
        case _ :
            factor()
        }
    }
    
    func factor ()
    {
        argument()
        factorOp()
    }
    
    func factorOp()
    {
        switch self.lookahead
        {
        case .Operator(op: "^"):
            nextToken()
            signedFactor()
        case _ :
            println("End 2")
        }
    }
    
    func argument()
    {
        value()
    }
    
    func value()
    {
        switch self.lookahead
        {
        case .FloatLit(value: _), .IntegerLit(value: _):
            nextToken()
        case _ :
            println("Pb")
        }
    }
    
    //Utility
    func nextToken()
    {
        self.tokens.removeAtIndex(0)
        
        self.lookahead = self.tokens.isEmpty ? Token.End() : self.tokens[0]
    }
}
