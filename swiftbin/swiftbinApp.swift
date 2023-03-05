//
//  swiftbinApp.swift
//  swiftbin
//
//  Created by Jeffery You on 2/25/23.
//

import SwiftUI

@main
struct swiftbinApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
