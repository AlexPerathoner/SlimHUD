//
//  ObserverApplication.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 18/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class KeyPressObserver: NSApplication {

    static let volumeChanged = Notification.Name("SlimHUD.volumeChanged")
    static let brightnessChanged = Notification.Name("SlimHUD.brightnessChanged")
    static let keyboardIlluminationChanged = Notification.Name("SlimHUD.keyboardIlluminationChanged")

    /* Capturing media key events. Doesn't work on devices with touch bar, but more efficient, so it should be preferred to using continuous check.
     * TODO: automatically decide if SlimHUD should use this or continuous check, removing toggle in settings
     * Taken from https://stackoverflow.com/a/32769093/6884062
     */
    override func sendEvent(_ event: NSEvent) {
        if event.type == .systemDefined && event.subtype.rawValue == 8 {
            let keyCode = ((event.data1 & 0xFFFF0000) >> 16)
            let keyFlags = (event.data1 & 0x0000FFFF)
            // Get the key state. 0xA is KeyDown, OxB is KeyUp
            let keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA
            let keyRepeat = keyFlags & 0x1
            mediaKeyEvent(key: Int32(keyCode), state: keyState, keyRepeat: Bool(truncating: keyRepeat as NSNumber))
        }

        super.sendEvent(event)
    }

    func mediaKeyEvent(key: Int32, state: Bool, keyRepeat: Bool) {
        // Only send events on KeyDown. Without this check, these events will happen twice
        if state {
            switch key {
            case NX_KEYTYPE_SOUND_DOWN, NX_KEYTYPE_SOUND_UP, NX_KEYTYPE_MUTE:
                NotificationCenter.default.post(name: KeyPressObserver.volumeChanged, object: self)
                break
            case NX_KEYTYPE_BRIGHTNESS_UP, NX_KEYTYPE_BRIGHTNESS_DOWN: // doesn't work - only works with built-in keyboard
                NotificationCenter.default.post(name: KeyPressObserver.brightnessChanged, object: self)
                break
            case NX_KEYTYPE_ILLUMINATION_DOWN, NX_KEYTYPE_ILLUMINATION_UP:
                NotificationCenter.default.post(name: KeyPressObserver.keyboardIlluminationChanged, object: self)
                break
            default:
                break
            }
        }
    }
}
