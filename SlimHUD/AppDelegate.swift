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

    weak var settingsViewTabsManager: TabsManager?

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

        if CommandLine.arguments.contains("showSettingsAtLaunch") {
            showSettingsWindow()
        }
    }

    func applicationDidBecomeActive(_ notification: Notification) {
        showSettingsWindow()
    }

    func showSettingsWindow() {
        if let settingsWindowController = settingsWindowController {
            settingsWindowController.showWindow(self)
        } else {
            if let windowController = NSStoryboard(name: "Settings", bundle: nil).instantiateInitialController() as? SettingsWindowController {
                settingsWindowController = windowController
                windowController.showWindow(self)
            }
        }
        NSApplication.shared.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }

    @IBAction func quitCliked(_ sender: Any) {
        if isSomeWindowVisible() {
            let alertResponse = showAlert(question: "SlimHUD will continue to show HUDs in the background",
                                          text: "If you want to quit, click \"Quit now\"",
                                          buttonsTitle: ["OK", "Quit now"])
            if alertResponse == NSApplication.ModalResponse.alertSecondButtonReturn {
                quit()
            }
            closeAllWindows()
            NSApplication.shared.setActivationPolicy(.accessory)
        } else {
            quit()
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

    private func closeAllWindows() {
        settingsWindowController?.close()
    }

    private func quit() {
        settingsManager.saveAllItems()
        OSDUIManager.start()
        exit(0)
    }

    private func isSomeWindowVisible() -> Bool {
        return (settingsWindowController?.window?.isVisible ?? false) &&
            NSApplication.shared.activationPolicy() != .accessory
    }
}
