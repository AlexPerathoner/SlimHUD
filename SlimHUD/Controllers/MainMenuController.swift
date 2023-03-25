//
//  MainMenuController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 13/01/23.
//

import Cocoa

class MainMenuController: NSWindowController {
    @IBOutlet weak var generalMenuItemOutlet: NSMenuItem!
    @IBOutlet weak var designMenuItemOutlet: NSMenuItem!
    @IBOutlet weak var styleMenuItemOutlet: NSMenuItem!
    @IBOutlet weak var aboutMenuItemOutlet: NSMenuItem!

    var settingsWindowController: SettingsWindowController?

    var settingsManager: SettingsManager = SettingsManager.getInstance()

    @IBAction func quitCliked(_ sender: Any) {
        if isSomeWindowVisible() {
            let alertResponse = showAlert(question: "SlimHUD will continue to show HUDs",
                                          text: "If you want to quit, click quit again",
                                          buttonsTitle: ["OK", "Quit now"])
            if alertResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                closeAllWindows()
                NSApplication.shared.setActivationPolicy(.accessory)
            }
            if alertResponse == NSApplication.ModalResponse.alertSecondButtonReturn {
                quit()
            }
        } else {
            quit()
        }
    }

    override func awakeFromNib() {
        if CommandLine.arguments.contains("showSettingsAtLaunch") {
            showSettingsWindow()
        }
    }

    func showSettingsWindow() {
        if isSomeWindowVisible() {
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        if settingsWindowController != nil {
            settingsWindowController?.showWindow(self)
        } else {
            if let windowController = NSStoryboard(name: "Settings", bundle: nil).instantiateInitialController() as? SettingsWindowController {
                settingsWindowController = windowController
                settingsWindowController?.delegate = self
                windowController.showWindow(self)
            }
        }
        // Settings window has now been opened, but isn't frontmost
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {_ in
            NSApplication.shared.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
        })
    }

    @IBAction func settingsClicked(_ sender: Any) {
        showSettingsWindow()
    }

    func closeAllWindows() {
        settingsWindowController?.close()
    }

    private func quit() {
        OSDUIManager.start()
        exit(0)
    }

    private func isSomeWindowVisible() -> Bool {
        return (settingsWindowController?.window?.isVisible ?? false) &&
            NSApplication.shared.activationPolicy() != .accessory
    }

    func toggleTabSwitcherMenuItems(isHidden: Bool) {
        generalMenuItemOutlet.isHidden = isHidden
        designMenuItemOutlet.isHidden = isHidden
        styleMenuItemOutlet.isHidden = isHidden
        aboutMenuItemOutlet.isHidden = isHidden
    }
}
