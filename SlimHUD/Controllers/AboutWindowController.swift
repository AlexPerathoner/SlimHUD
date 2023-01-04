//
//  AboutWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

class AboutWindowController: NSWindowController, NSWindowDelegate {
    weak var delegate: AppDelegate?
    
    override func windowDidLoad() {
        NSApp.activate(ignoringOtherApps: true)
        NSApplication.shared.setActivationPolicy(.regular)
    }
    
    func windowWillClose(_ notification: Notification) {
        delegate?.setAccessoryActivationPolicyIfAllWindowsClosed()
    }
}
