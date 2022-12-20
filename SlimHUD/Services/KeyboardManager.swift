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
    
    private static var useM1KeyboardBrightnessMethod = false
    
    static func getKeyboardBrightness() -> Float {
        if(useM1KeyboardBrightnessMethod) {
            return getM1KeyboardBrightness()
        } else {
            do {
                return try getStandardKeyboardBrightness()
            } catch {
                KeyboardManager.useM1KeyboardBrightnessMethod = true
                return getM1KeyboardBrightness()
            }
        }
    }

    private static func getStandardKeyboardBrightness() throws -> Float {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleHIDKeyboardEventDriverV2"))
        defer {
            IOObjectRelease(service)
        }
        
        if let ser: CFTypeRef = IORegistryEntryCreateCFProperty(service, "KeyboardBacklightBrightness" as CFString, kCFAllocatorDefault, 0)?.takeUnretainedValue() {
            let result = ser as! Float
            return result / 342 //max value is 342, proportioning to %
        }
        throw SensorError.keyboardBrightnessFailure
    }
    private static func getM1KeyboardBrightness() -> Float {
        let task = Process()
        task.launchPath = "/usr/libexec/corebrightnessdiag"
        task.arguments = ["status-info"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()

        var keyboardBrightness: Float?

        if let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? NSDictionary {
            if let keyboards = plist["CBKeyboards"] as? [String: [String: Any]] {
                for keyboard in keyboards.values {
                    if let backlightInfo = keyboard["CBKeyboardBacklightContainer"] as? [String: Any],
                        backlightInfo["KeyboardBacklightBuiltIn"] as? Bool == true,
                        let brightness = backlightInfo["KeyboardBacklightBrightness"] as? Float {
                            keyboardBrightness = brightness
                            break
                    }
                }
            }
        }
        return keyboardBrightness ?? 0.0
    }
}
