//
//  KeyboardManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation

class KeyboardManager {
    private init() {}

    static func getKeyboardBrightnessProportioned(raw: Float) -> Float {
        if raw <= 0.07 { return 0 }
        return (log10(raw+0.03)+1)
    }

    private static let MAX_KEYBOARD_BRIGHTNESS: Float = 342

    static func getRawKeyboardBrightness() -> Float {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleHIDKeyboardEventDriverV2"))
        defer {
            IOObjectRelease(service)
        }

        if let ser: CFTypeRef = IORegistryEntryCreateCFProperty(service, "KeyboardBacklightBrightness" as CFString, kCFAllocatorDefault, 0)?.takeUnretainedValue() {
            let result = ser as! Float
            return result / KeyboardManager.MAX_KEYBOARD_BRIGHTNESS // max value is 342, proportioning to %
        }
        return 0 // todo: should throw exception, maybe show "disabled" icon?
    }
}
