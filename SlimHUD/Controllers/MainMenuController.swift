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
            if settingsManager.showQuitAlert {
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
            closeAllWindows(self)
            NSApplication.shared.setActivationPolicy(.accessory)
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
        toggleTabSwitcherMenuItems(isHidden: false)
        if settingsWindowController != nil {
            settingsWindowController?.showWindow(self)
        } else {
            if let windowController = NSStoryboard(name: "Settings", bundle: nil).instantiateInitialController() as? SettingsWindowController {
                settingsWindowController = windowController
                windowController.showWindow(self)
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {_ in
            NSApplication.shared.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
        })
    }

    @IBAction func settingsClicked(_ sender: Any) {
        showSettingsWindow()
    }

    @IBAction func closeAllWindows(_ sender: Any) {
        settingsWindowController?.close()
        toggleTabSwitcherMenuItems(isHidden: true)
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

    private func toggleTabSwitcherMenuItems(isHidden: Bool) {
        generalMenuItemOutlet.isHidden = isHidden
        designMenuItemOutlet.isHidden = isHidden
        styleMenuItemOutlet.isHidden = isHidden
        aboutMenuItemOutlet.isHidden = isHidden
    }
}
