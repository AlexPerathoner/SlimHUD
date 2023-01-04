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

    var settingsWindowController: SettingsWindowController?
    var aboutWindowController: AboutWindowController?

    @IBOutlet weak var statusMenu: NSMenu!

    @IBAction func quitCliked(_ sender: Any) {
        if(isSomeWindowVisible()) {
            if(settingsManager.showQuitAlert) {
                let alertResponse = showAlert(question: "SlimHUD will continue to show HUDs",
                                              text: "If you want to quit, click quit again",
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
            settingsWindowController?.hidePreviewHud()
        } else {
            quit()
        }
    }
    
    func closeAllWindows() {
        settingsWindowController?.close()
        aboutWindowController?.close()
    }
    
    func quit() {
        settingsManager.saveAllItems()
        exit(0)
    }
    
    @IBAction func aboutClicked(_ sender: Any) {
        if aboutWindowController != nil {
            aboutWindowController?.showWindow(self)
        } else {
            if let wc = NSStoryboard(name: "About", bundle: nil).instantiateInitialController() as? AboutWindowController {
                aboutWindowController = wc
                wc.delegate = self
                wc.showWindow(self)
            }
        }
        NSApplication.shared.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }

    @IBAction func settingsClicked(_ sender: Any) {
        if settingsWindowController != nil {
            settingsWindowController?.showWindow(self)
        } else {
            if let wc = NSStoryboard(name: "Settings", bundle: nil).instantiateInitialController() as? SettingsWindowController {
                settingsWindowController = wc
                wc.delegate = self
                wc.showWindow(self)
            }
        }
        NSApplication.shared.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }

    func setAccessoryActivationPolicyIfAllWindowsClosed() {
        // hiding app if not both windows are visible
        if isOnlyOneWindowVisible() {
            NSApplication.shared.setActivationPolicy(.accessory)
        }
    }
    
    func isSomeWindowVisible() -> Bool {
        return ((aboutWindowController?.window?.isVisible ?? false) || (settingsWindowController?.window?.isVisible ?? false)) &&
            NSApplication.shared.activationPolicy() != .accessory
    }
    
    func isOnlyOneWindowVisible() -> Bool {
        return (aboutWindowController?.window?.isVisible ?? false) != (settingsWindowController?.window?.isVisible ?? false) &&
        NSApplication.shared.activationPolicy() != .accessory
    }

    var settingsManager: SettingsManager = SettingsManager.getInstance()

    // swiftlint:disable:next force_cast
    var volumeView: BarView = NSView.fromNib(name: BarView.BarViewNibFileName) as! BarView
    // swiftlint:disable:next force_cast
    var brightnessView: BarView = NSView.fromNib(name: BarView.BarViewNibFileName) as! BarView
    // swiftlint:disable:next force_cast
    var keyboardView: BarView = NSView.fromNib(name: BarView.BarViewNibFileName) as! BarView

    var volumeHud = Hud()
    var brightnessHud = Hud()
    var keyboardHud = Hud()

    lazy var positionManager = PositionManager(volumeHud: volumeHud, brightnessHud: brightnessHud, keyboardHud: keyboardHud)
    lazy var displayer = Displayer(positionManager: positionManager, volumeHud: volumeHud, brightnessHud: brightnessHud, keyboardHud: keyboardHud)
    lazy var changesObserver = ChangesObserver(positionManager: positionManager, displayer: displayer,
                                               volumeView: volumeView, brightnessView: brightnessView,
                                               keyboardView: keyboardView)

    override func awakeFromNib() {
        super.awakeFromNib()

        // menu bar
        statusItem.menu = statusMenu

        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.StatusIconFileName)
            button.image?.isTemplate = true
        }

        // Setting up huds
        volumeHud.view = volumeView
        brightnessHud.view = brightnessView
        keyboardHud.view = keyboardView

        displayer.setHeight(height: CGFloat(settingsManager.barHeight))
        displayer.setThickness(thickness: CGFloat(settingsManager.barThickness))

        displayer.updateAll()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSColor.ignoresAlpha = false
        NSApplication.shared.setActivationPolicy(.accessory)

        // continuous check - 0.2 should not take more than 1/800 CPU
        changesObserver.startObserving()

        NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification,
                                               object: NSApplication.shared,
                                               queue: OperationQueue.main) { _ -> Void in
            self.positionManager.setupHUDsPosition(false)
            self.changesObserver.resetTemporarelyDisabledBars()
        }

        OSDUIManager.stop()
    }
}
