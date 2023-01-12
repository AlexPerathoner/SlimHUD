//
//  KeyPressObserver.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa
import MediaKeyTap

class KeyPressObserver {
    static let volumeChanged = Notification.Name("SlimHUD.volumeChanged")
    static let brightnessChanged = Notification.Name("SlimHUD.brightnessChanged")
    static let keyboardIlluminationChanged = Notification.Name("SlimHUD.keyboardIlluminationChanged")
    
    var mediaKeyTap: MediaKeyTap?
    
    func startObserving() {
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
