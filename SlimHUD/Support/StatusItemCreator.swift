//
//  StatusItemCreator.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 04/03/23.
//

import Cocoa

extension AppDelegate {
    func addStatusItem() {
        if statusItem == nil {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
            if let statusItem = statusItem {
                // menu bar
                statusItem.menu = statusMenu
                
                if let button = statusItem.button {
                    button.image = IconManager.getStatusIcon()
                    button.image?.isTemplate = true
                }
            }
        }
    }
    
    func removeStatusItem() {
        if statusItem != nil {
            NSStatusBar.system.removeStatusItem(statusItem!)
            statusItem = nil
        }
    }
}
