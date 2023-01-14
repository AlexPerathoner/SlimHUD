//
//  KeyPressObserver.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa
import MediaKeyTap

class KeyPressObserver: NSApplication {
    static let volumeChanged = Notification.Name("SlimHUD.volumeChanged")
    static let brightnessChanged = Notification.Name("SlimHUD.brightnessChanged")
    static let keyboardIlluminationChanged = Notification.Name("SlimHUD.keyboardIlluminationChanged")

    override func sendEvent(_ event: NSEvent) {
        if event.type == .systemDefined && event.subtype.rawValue == 8 {
            let keyCode = ((event.data1 & 0xFFFF0000) >> 16)
            let keyFlags = (event.data1 & 0x0000FFFF)
            // Get the key state. 0xA is KeyDown, OxB is KeyUp
            let keyState = ((keyFlags & 0xFF00) >> 8) == 0xA
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
            case NX_KEYTYPE_BRIGHTNESS_UP, NX_KEYTYPE_BRIGHTNESS_DOWN: // doesn't work - only works with built-in keyboard
                NotificationCenter.default.post(name: KeyPressObserver.brightnessChanged, object: self)
            case NX_KEYTYPE_ILLUMINATION_DOWN, NX_KEYTYPE_ILLUMINATION_UP:
                NotificationCenter.default.post(name: KeyPressObserver.keyboardIlluminationChanged, object: self)
            default:
                break
            }
        }
    }

    var mediaKeyTap: MediaKeyTap?

    override func awakeFromNib() {
        self.mediaKeyTap = MediaKeyTap(delegate: self, on: .keyDownAndUp)
        self.mediaKeyTap?.start()
    }
}

extension KeyPressObserver: MediaKeyTapDelegate {
    func handle(mediaKey: MediaKey, event: KeyEvent?, modifiers: NSEvent.ModifierFlags?) {
        switch mediaKey {
        case .volumeUp, .volumeDown, .mute:
            NotificationCenter.default.post(name: KeyPressObserver.volumeChanged, object: self)
        case .brightnessDown, .brightnessUp:
            NotificationCenter.default.post(name: KeyPressObserver.brightnessChanged, object: self)
        case .keyboardBrightnessUp, .keyboardBrightnessDown, .keyboardBrightnessToggle:
            NotificationCenter.default.post(name: KeyPressObserver.keyboardIlluminationChanged, object: self)
        default:
            return
        }
    }
}
