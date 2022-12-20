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

    private static let MaxKeyboardBrightness: Float = 342
    
    private static var useM1KeyboardBrightnessMethod = false
    
    static func getKeyboardBrightness() -> Float {
        if(useM1KeyboardBrightnessMethod) {
            return getM1KeyboardBrightness()
        } else {
            do {
                return try getKeyboardBrightnessProportioned(raw: getRawKeyboardBrightness())
            } catch {
                KeyboardManager.useM1KeyboardBrightnessMethod = true
                return getM1KeyboardBrightness()
            }
        }
    }

    // Raw value of sensor is non linear, correcting it
    private static func getKeyboardBrightnessProportioned(raw: Float) -> Float {
        if raw <= 0.07 { return 0 }
        return (log10(raw+0.03)+1)
    }

    private static func getRawKeyboardBrightness() throws -> Float {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleHIDKeyboardEventDriverV2"))
        defer {
            IOObjectRelease(service)
        }

        if let ser: CFTypeRef = IORegistryEntryCreateCFProperty(service, "KeyboardBacklightBrightness" as CFString, kCFAllocatorDefault, 0)?.takeUnretainedValue() {
            let result = ser as! Float
            return result / KeyboardManager.MaxKeyboardBrightness
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
