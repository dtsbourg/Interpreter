//
//  AppDelegate.swift
//  SwiftInterpreter
//
//  Created by Dylan Bourgeois on 05/10/14.
//  Copyright (c) 2014 Dylan Bourgeois. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        println(Parse(Lex("sqrt(2)").tokens).parse().getValue())
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

