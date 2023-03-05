//
//  main.swift
//  swiftbin
//
//  Created by Jeffery You on 3/5/23.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
