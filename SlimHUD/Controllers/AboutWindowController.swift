//
//  AboutWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

class AboutWindowController: NSWindowController {

    override func windowDidLoad() {
        NSApp.activate(ignoringOtherApps: true)
        NSApplication.shared.setActivationPolicy(.regular)
    }

    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)
    }
}
