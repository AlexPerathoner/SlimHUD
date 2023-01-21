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
    var settingsManager: SettingsManager = SettingsManager.getInstance()
    var settingsWindowController: SettingsWindowController?

    var volumeHud = Hud()
    var brightnessHud = Hud()
    var keyboardHud = Hud()

    lazy var positionManager = PositionManager(volumeHud: volumeHud, brightnessHud: brightnessHud, keyboardHud: keyboardHud)
    lazy var displayer = Displayer(positionManager: positionManager, volumeHud: volumeHud, brightnessHud: brightnessHud, keyboardHud: keyboardHud)
    lazy var changesObserver = ChangesObserver(positionManager: positionManager, displayer: displayer)

    override func awakeFromNib() {
        super.awakeFromNib()
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
        if settingsWindowController != nil {
            settingsWindowController?.showWindow(self)
        } else {
            if let windowController = NSStoryboard(name: "Settings", bundle: nil).instantiateInitialController() as? SettingsWindowController {
                settingsWindowController = windowController
                windowController.showWindow(self)
            }
        }
        NSApplication.shared.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func quitCliked(_ sender: Any) {  // todo deal with this
        if isSomeWindowVisible() {
            if settingsManager.showQuitAlert {
                let alertResponse = showAlert(question: "SlimHUD will continue to show HUDs in background",
                                              text: "If you want to quit, click \"Quit now\"",
                                              buttonsTitle: ["OK", "Quit now", "Don't show again"])
                if alertResponse == NSApplication.ModalResponse.alertSecondButtonReturn {
                    quit()
                }
                if alertResponse == NSApplication.ModalResponse.alertThirdButtonReturn {
                    settingsManager.showQuitAlert = false
                }
            }
            closeAllWindows()
            NSApplication.shared.setActivationPolicy(.accessory)
        } else {
            quit()
        }
    }
    
    private func closeAllWindows() {
        settingsWindowController?.close()
    }

    private func quit() {
        settingsManager.saveAllItems()
        OSDUIManager.start()
        exit(0)
    }
    
    private func isSomeWindowVisible() -> Bool {
        return ((settingsWindowController?.window?.isVisible ?? false)) &&
            NSApplication.shared.activationPolicy() != .accessory
    }
}
