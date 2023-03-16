//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

class SettingsWindowController: NSWindowController, NSWindowDelegate {
    weak var delegate: MainMenuController?

    private var previewTimer: Timer?

    // swiftlint:disable:next force_cast
    var displayer = (NSApplication.shared.delegate as! AppDelegate).displayer
    // when the settings window is opened, the initially showed hud is the volume's one
    private var currentPreviewHud: SelectedHud? = .volume

    override func windowDidLoad() {
        window?.delegate = self

        NSApp.activate(ignoringOtherApps: true)
        NSApplication.shared.setActivationPolicy(.regular)

        window?.identifier = .init(rawValue: "Settings")
        super.windowDidLoad()

        if let viewController = self.contentViewController as? SettingsViewController {
            viewController.setWindowController(self)
        }
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        showPreviewHud(bar: nil)
        displayer.temporarelyEnableAllBars = true
        delegate?.toggleTabSwitcherMenuItems(isHidden: false)
    }

    func windowWillClose(_ notification: Notification) {
        hidePreviewHud()
        displayer.temporarelyEnableAllBars = false
        NSApplication.shared.setActivationPolicy(.accessory)
        delegate?.toggleTabSwitcherMenuItems(isHidden: true)
    }

    public func restartPreviewHud() {
        let oldHud = currentPreviewHud
        hidePreviewHud()
        showPreviewHud(bar: oldHud)
    }

    public func showPreviewHud(bar: SelectedHud?) {
        if previewTimer == nil || currentPreviewHud != bar { // windowDidLoad() could be called multiple times
            hidePreviewHud()
            // sends a notification every second causing the bar to appear and be kept visible
            if bar == .brightness {
                previewTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { (_) in
                    self.displayer.showBrightnessHUD()
                }
            } else if bar == .keyboard {
                previewTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { (_) in
                    self.displayer.showKeyboardHUD()
                }
            } else {
                previewTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { (_) in
                    self.displayer.showVolumeHUD()
                }
            }
            RunLoop.current.add(previewTimer!, forMode: .eventTracking)
            currentPreviewHud = bar
        }
    }

    private func hidePreviewHud() {
        previewTimer?.invalidate()
        previewTimer = nil
        currentPreviewHud = nil
    }
}
