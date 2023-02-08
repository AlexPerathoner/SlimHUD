//
//  WelcomeWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 08/02/23.
//

import Cocoa

class WelcomeWindowController: NSWindowController, NSWindowDelegate {
    
    override func windowDidLoad() {
        NSApp.activate(ignoringOtherApps: true)
        NSApplication.shared.setActivationPolicy(.regular)
        
        window?.identifier = .init(rawValue: "Welcome")
        super.windowDidLoad()
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
}
