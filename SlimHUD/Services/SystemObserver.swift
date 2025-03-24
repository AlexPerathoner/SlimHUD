//
//  SystemObserver.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 17/03/25.
//

import Foundation
import Cocoa
import IOKit

class SystemObserver: NSObject {
    private var sleepNotificationPort: IONotificationPortRef?
    private var sleepNotifierReference: io_object_t = 0
    private var wakeNotifierReference: io_object_t = 0
    private var timer: Timer?

    override init() {
        super.init()
    }

    deinit {
        NSWorkspace.shared.notificationCenter.removeObserver(self)
        NotificationCenter.default.removeObserver(self)

        if let port = sleepNotificationPort {
            IONotificationPortDestroy(port)
        }
    }

    func setupObservers() {
        // Register for lid events
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(lidStateChanged(_:)),
            name: NSWorkspace.screensDidSleepNotification,
            object: nil
        )

        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(lidStateChanged(_:)),
            name: NSWorkspace.screensDidWakeNotification,
            object: nil
        )

        // Register for sleep/wake notifications
        registerForSleepWakeNotifications()

        // Register for display connect/disconnect events
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(displayConfigurationChanged(_:)),
            name: NSApplication.didChangeScreenParametersNotification,
            object: nil
        )

        // sometimes the macOS Huds still show up randomly after a while, this should usually prevent that
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
            OSDUIManager.stop()
            DisplayManager.resetMethod()
        })
    }

    @objc func lidStateChanged(_ notification: Notification) {
        OSDUIManager.stop()
        DisplayManager.resetMethod()
    }

    @objc func displayConfigurationChanged(_ notification: Notification) {
        OSDUIManager.stop()
        DisplayManager.resetMethod()
    }

    func registerForSleepWakeNotifications() {
        // Register for wake notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveWakeNote(_:)),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(receiveSleepNote(_:)),
            name: NSWorkspace.willSleepNotification,
            object: nil
        )
    }

    @objc func receiveWakeNote(_ notification: Notification) {
        OSDUIManager.stop()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { _ in
            OSDUIManager.stop()
            DisplayManager.resetMethod()
        })
    }

    @objc func receiveSleepNote(_ notification: Notification) {
        // don't prevent sleep
        if let t = timer {
            t.invalidate()
        }
        timer = nil
    }
}
