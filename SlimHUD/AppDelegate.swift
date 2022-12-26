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

    @IBOutlet weak var statusMenu: NSMenu!

    @IBAction func quitCliked(_ sender: Any) {
        settingsManager.saveAllItems()
        NSApplication.shared.terminate(self)
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
        }

        OSDUIManager.stop()
    }
}
