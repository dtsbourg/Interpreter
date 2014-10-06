// Playground - noun: a place where people can play

import UIKit
import Foundation



let TestInput:String = "46+378.47898-29"

protocol RegularExpressionMatchable {
    func match(pattern: String, options: NSRegularExpressionOptions) -> Bool
}

extension String: RegularExpressionMatchable {
    func match(pattern: String, options: NSRegularExpressionOptions = nil) -> Bool {
        let regex = NSRegularExpression(pattern: pattern, options: options, error: nil)
        return regex?.matchesInString(self, options: nil, range: NSMakeRange(0, self.utf16Count)).count != 0

    }
}

extension Character: RegularExpressionMatchable {
    func match(pattern: String, options: NSRegularExpressionOptions = nil) -> Bool {
        let regex = NSRegularExpression(pattern: pattern, options: options, error: nil)
        return regex?.matchesInString(String(self), options: nil, range: NSMakeRange(0, String(self).utf16Count)).count != 0
        
    }
}

infix operator =~ { associativity left precedence 130 }
func =~<T: RegularExpressionMatchable> (left: T, right: String) -> Bool {
    return left.match(right, options: nil)
}


class Lex {
    let input:String
    var tokens:NSMutableArray
    
    init(input:String)
    {
        self.input = input
        tokens = NSMutableArray()
        
        let inputArray = Array(input)
        var i = 0

        while i < inputArray.count
        {
            var tempc = inputArray[i]
            
            if (isWhitespace(tempc))
            {
                i++
                println("Whitespace")
            }
            else if (isOperator(tempc))
            {
                i++
                self.addToken(String(tempc), value: "")
            }
            else if (isDigit(tempc))
            {
                //See about float
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
                    
                    if (isDigit(tempc))
                    {
                        str += String(tempc)
                    }
                    else if (tempc == ".")
                    {
                        str += String(tempc)
                        
                        tempc = inputArray[++i]
                        
                        while (isDigit(tempc))
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
                            
                            if (isDigit(tempc))
                            {
                                str += String(tempc)
                                tempc = inputArray[i]
                            }
                        }

                    }
                }
                
                self.addToken("number", value:String(str))
            }
            
            else if (isIdentifier(tempc))
            {
                i++
                //We'll see about that ...

            }
            else
            {
                i++
            }
            
            
            
        }
        
        self.addToken("(end)", value:"")
        println(tokens)

    }
    
        
    func addToken(type:String, value:String)
    {
        let dic:Dictionary = Dictionary(dictionaryLiteral:(type,value))
        tokens.addObject(dic)
        
    }
    
    func isOperator (char:Character) -> Bool {
        return char =~ "[+\\-*\\/\\^%=(),]"
    }
    
    func isDigit (char:Character) -> Bool {
        return char =~ "[0-9]"
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

