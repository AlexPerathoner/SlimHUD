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

    override func windowDidLoad() {
        window?.delegate = self

        NSApp.activate(ignoringOtherApps: true)
        NSApplication.shared.setActivationPolicy(.regular)

        window?.identifier = .init(rawValue: "Settings")
        super.windowDidLoad()
    }

    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        showPreviewHud()
    }

    func windowWillClose(_ notification: Notification) {
        hidePreviewHud()
        delegate?.setAccessoryActivationPolicyIfAllWindowsClosed()
    }

    private func showPreviewHud() {
        if previewTimer == nil { // windowDidLoad() could be called multiple times
            // sends a notification every second causing the bar to appear and be kept visible
            previewTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { (_) in
                self.displayer.showVolumeHUD()
            }
            RunLoop.current.add(previewTimer!, forMode: .eventTracking)
        }
    }

    private func hidePreviewHud() {
        previewTimer?.invalidate()
        previewTimer = nil
    }
}
