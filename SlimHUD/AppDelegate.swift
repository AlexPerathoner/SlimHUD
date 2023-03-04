//
//  AppDelegate.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import QuartzCore
import AppKit
import Sparkle

@NSApplicationMain
class AppDelegate: NSWindowController, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    var settingsManager: SettingsManager = SettingsManager.getInstance()

    var volumeHud = Hud()
    var brightnessHud = Hud()
    var keyboardHud = Hud()

    lazy var positionManager = PositionManager(volumeHud: volumeHud, brightnessHud: brightnessHud, keyboardHud: keyboardHud)
    lazy var displayer = Displayer(positionManager: positionManager, volumeHud: volumeHud, brightnessHud: brightnessHud, keyboardHud: keyboardHud)
    lazy var changesObserver = ChangesObserver(positionManager: positionManager, displayer: displayer)

    weak var settingsViewTabsManager: TabsManager?

    override func awakeFromNib() {
        super.awakeFromNib()

        // menu bar
        statusItem.menu = statusMenu

        if let button = statusItem.button {
            button.image = IconManager.getStatusIcon()
            button.image?.isTemplate = true
        }

        displayer.updateAllAttributes()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSColor.ignoresAlpha = false
        NSApplication.shared.setActivationPolicy(.accessory)

        // continuous check - 0.2 should not take more than 1/800 CPU
        changesObserver.startObserving()

        NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification,
                                               object: NSApplication.shared,
                                               queue: OperationQueue.main) { _ -> Void in
            self.positionManager.setupHUDsPosition(isFullscreen: false)
            self.changesObserver.resetTemporarelyDisabledBars()
        }

        OSDUIManager.stop()
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        if settingsManager.shouldHideMenuBarIcon {
            mainMenuController.showSettingsWindow()
        }
    }

    @IBAction func openGeneralTab(_ sender: Any) {
        settingsViewTabsManager?.selectItem(index: 0)
    }

    @IBAction func openDesignTab(_ sender: Any) {
        settingsViewTabsManager?.selectItem(index: 1)
    }

    @IBAction func openStyleTab(_ sender: Any) {
        settingsViewTabsManager?.selectItem(index: 2)
    }

    @IBAction func openAboutTab(_ sender: Any) {
        settingsViewTabsManager?.selectItem(index: 3)
    }
    
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var mainMenuController: MainMenuController!
}
