//
//  Lex.swift
//  SwiftInterpreter
//
//  Created by Dylan Bourgeois on 05/10/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

import Foundation

enum Token {
    case Identifier(name: String)
    case IntegerLit(value:Int)
    case FloatLit(value:Float)
    case Operator(op:String)
    case End()
    
    func description () -> String {
        switch self {
        case let Identifier(name):
                return "Identifier(" + name + ")"
            case let IntegerLit(value):
                return "IntegerLit(\(value))"
            case let FloatLit(value):
                return "FloatLit(\(value))"
            case let Operator(op):
                return "Operator(" + op + ")"
            case let End():
                return "End Token"
        }
    }
    
    func doubleValue () -> Double {
        switch self {
            case let FloatLit(value):
                return Double(value)
            case let IntegerLit(value):
                return Double(value)
            case _ :
                return 0
        }
    }
}



class Lex {
    let input:String
    var tokens:Array<Token>
    
    init(_ input:String)
    {
        self.input = input
        tokens = Array()
        
        let inputArray = Array(input)

        var i = 0
        
        while i < inputArray.count
        {
            var tempc = inputArray[i]
            
            if (isWhitespace(tempc))
            {
                i++
            }
            else if (isOperator(tempc))
            {
                i++
                tokens.append(Token.Operator(op: String(tempc)))
            }
            else if (isDigit(tempc))
            {                
                var str = String(tempc)
                
                while (isDigit(tempc))
                {
                    if (i<inputArray.count-1)
                    {
                        tempc = inputArray[++i]
                    }
                    else
                    {
                        tempc = " "
                        i++
                    }
                    
                    str += String(tempc)
                }
                
                if ((str as NSString).containsString("."))
                {
                    tokens.append(Token.FloatLit(value: str.floatValue))
                }
                else
                {
                    tokens.append(Token.IntegerLit(value: (str as NSString).integerValue))
                }
            }
                
            else if (isIdentifier(tempc))
            {
                var idn = String(tempc)
                
                tempc = inputArray[++i]
                
                while (isIdentifier(tempc))
                {
                    if (i<inputArray.count-1)
                    {
                        tempc = inputArray[i]
                        i++
                    }
                    else
                    {
                        tempc = " "
                        i++
                    }
                    
                    if (isIdentifier(tempc))
                    {
                        idn += String(tempc)
                        tempc = inputArray[i]
                    }
                }
                tokens.append(Token.Identifier(name: idn))
            }
            else
            {
                i++
            }
        }
        
        for t in tokens
        {
            println(t.description())
        }
    }
    
    func isOperator (char:Character) -> Bool {
        return char =~ "[+\\-*\\/\\^%=(),]"
    }
    
    func isDigit (char:Character) -> Bool {
        return char =~ "[0-9\\.]"
    }
    
    func isWhitespace (char:Character) -> Bool {
        return char =~ "\\s"
    }
    
    func isIdentifier (char:Character) -> Bool {
        var isChar:Bool = false
        let letters = NSCharacterSet.letterCharacterSet()
        
        
        for tmp in String(char).unicodeScalars
        {
            if (letters.longCharacterIsMember(tmp.value))
            {
                isChar = true
            }
        }
        
        return (isChar && !isDigit(char) && !isDigit(char) && !isWhitespace(char))
    }
}