//
//  Utilities.swift
//  SwiftInterpreter
//
//  Created by Dylan Bourgeois on 10/10/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

import Foundation

extension String: RegularExpressionMatchable {
    func match(pattern: String, options: NSRegularExpressionOptions = nil) -> Bool {
        let regex = NSRegularExpression(pattern: pattern, options: options, error: nil)
        return regex?.matchesInString(self, options: nil, range: NSMakeRange(0, self.utf16Count)).count != 0
        
    }
}
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension Character: RegularExpressionMatchable {
    func match(pattern: String, options: NSRegularExpressionOptions = nil) -> Bool {
        let regex = NSRegularExpression(pattern: pattern, options: options, error: nil)
        return regex?.matchesInString(String(self), options: nil, range: NSMakeRange(0, String(self).utf16Count)).count != 0
        
    }
}

protocol RegularExpressionMatchable {
    func match(pattern: String, options: NSRegularExpressionOptions) -> Bool
}


infix operator =~ { associativity left precedence 130 }
func =~<T: RegularExpressionMatchable> (left: T, right: String) -> Bool {
    return left.match(right, options: nil)
}
