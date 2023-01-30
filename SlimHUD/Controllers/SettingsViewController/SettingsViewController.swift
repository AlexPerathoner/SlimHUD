//
//  SettingsViewController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 30/01/23.
//

import Cocoa

class SettingsViewController: NSViewController {
    @IBOutlet weak var tabsManager: TabsManager!
    
    func setWindowController(_ windowController: SettingsWindowController) {
        tabsManager.setWindowController(windowController)
    }
}
