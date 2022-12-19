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
    

    static func getKeyboardBrightness() -> Float {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleHIDKeyboardEventDriverV2"))
        defer {
            IOObjectRelease(service)
        }
        
        if let ser: CFTypeRef = IORegistryEntryCreateCFProperty(service, "KeyboardBacklightBrightness" as CFString, kCFAllocatorDefault, 0)?.takeUnretainedValue() {
            let result = ser as! Float
            return result / 342 //max value is 342, proportioning to %
        }
        //couldn't get keyboard backlight
        return 0.5
    }
}
