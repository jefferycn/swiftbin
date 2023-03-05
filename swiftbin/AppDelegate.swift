//
//  AppDelegate.swift
//  swiftbin
//
//  Created by Jeffery You on 2/25/23.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate, NSWindowDelegate {
    var statusItem: NSStatusItem!
    var menu: NSMenu!
    var serverUrl: String = ""
    var token: String = ""
    var window: NSWindow!
    
    private func initSettingsWindow() {
        let contentView = ContentView()
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 250),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.contentView = NSHostingView(rootView: contentView)
        window.delegate = self
        window.center()
        window.makeKeyAndOrderFront(nil)
        window.setIsVisible(!configExist())
    }
    
    private func initStatusMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "arrow.up.doc.on.clipboard", accessibilityDescription: nil)
            button.action = #selector(showMenu(_:))
        }
        menu = NSMenu()
        let copyMenuItem = NSMenuItem(title: "Copy", action: #selector(copy(_:)), keyEquivalent: "c")
        let pasteMenuItem = NSMenuItem(title: "Paste", action: #selector(paste(_:)), keyEquivalent: "v")
        let settingsMenuItem = NSMenuItem(title: "Settings", action: #selector(settings(_:)), keyEquivalent: ",")
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(quit(_:)), keyEquivalent: "q")
        menu.addItem(copyMenuItem)
        menu.addItem(pasteMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(settingsMenuItem)
        menu.addItem(quitMenuItem)
        statusItem.menu = menu
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        initSettingsWindow()
        initStatusMenu()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.setIsVisible(false)
        return false
    }
    
    private func configExist() -> Bool {
        serverUrl = UserDefaults.standard.string(forKey: "serverUrl") ?? ""
        token =  UserDefaults.standard.string(forKey: "token") ?? ""
        if !serverUrl.isEmpty, !token.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    @objc func showMenu(_ sender: AnyObject?) {
        guard let button = statusItem.button else { return }
        menu.popUp(positioning: nil, at: NSPoint(x: button.frame.minX, y: button.frame.minY - button.frame.height), in: button)
    }
    
    @objc func copy(_ sender: AnyObject?) {
        if(!configExist()) {
            settings(sender)
            return
        }
        Utils.copy(serverUrl: serverUrl)
    }
    
    @objc func paste(_ sender: AnyObject?) {
        if(!configExist()) {
            settings(sender)
            return
        }
        Utils.paste(serverUrl: serverUrl, token: token)
    }
    
    @objc func settings(_ sender: AnyObject?) {
        window.setIsVisible(true)
        window.makeKeyAndOrderFront(nil)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    @objc func quit(_ sender: AnyObject?) {
        NSApplication.shared.terminate(self)
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        statusItem.button?.highlight(true)
    }
    
    func menuDidClose(_ menu: NSMenu) {
        statusItem.button?.highlight(false)
    }
}
