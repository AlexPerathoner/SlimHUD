//
//  KeyboardManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import IOKit

class KeyboardManager {
    private init() {}

    private static let MaxKeyboardBrightness: Float = 342

    private static var method = SensorMethod.standard
    private static var lmuDataPort: io_connect_t = 0

    static func getKeyboardBrightness() throws -> Float {
        switch KeyboardManager.method {
        case .standard:
            do {
                return try getKeyboardBrightnessProportioned(raw: getRawKeyboardBrightness())
            } catch {
                method = .lmu
            }
        case .lmu:
            do {
                return try getLMUKeyboardBrightness()
            } catch {
                method = .m1
            }
        case .m1:
            do {
                return try getM1KeyboardBrightness()
            } catch {
                method = .allFailed
            }
        case .allFailed:
            throw SensorError.Keyboard.notFound
        }
        return try getKeyboardBrightness()
    }

    static func resetMethodForTesting() {
        method = .standard
        lmuDataPort = 0
    }

    // Raw value of sensor is non linear, correcting it
    static func getKeyboardBrightnessProportioned(raw: Float) -> Float {
        if raw <= 0.07 {
            return 0
        }
        return (log10(raw+0.03)+1)
    }

    private static func getRawKeyboardBrightness() throws -> Float {
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleHIDKeyboardEventDriverV2"))
        defer {
            IOObjectRelease(service)
        }

        if let ser: CFTypeRef = IORegistryEntryCreateCFProperty(service,
                                                                "KeyboardBacklightBrightness" as CFString,
                                                                kCFAllocatorDefault, 0)?.takeUnretainedValue() {
            // swiftlint:disable:next force_cast
            let result = ser as! Float
            return result / KeyboardManager.MaxKeyboardBrightness
        }
        throw SensorError.Keyboard.notStandard
    }

    // Uses AppleLMUController — works on older Intel Macs (pre-2015) where
    // AppleHIDKeyboardEventDriverV2 is unavailable or doesn't expose KeyboardBacklightBrightness.
    private static func getLMUKeyboardBrightness() throws -> Float {
        if lmuDataPort == 0 {
            let serviceObject = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                            IOServiceMatching("AppleLMUController"))
            guard serviceObject != 0 else {
                throw SensorError.Keyboard.notStandard
            }
            let kr = IOServiceOpen(serviceObject, mach_task_self_, 0, &lmuDataPort)
            IOObjectRelease(serviceObject)
            guard kr == KERN_SUCCESS else {
                throw SensorError.Keyboard.notStandard
            }
        }

        let kGetLEDBrightnessID: UInt32 = 1
        let inputs: [UInt64] = [0]
        var outputCount: UInt32 = 1
        var outputValue: UInt64 = 0

        let kr = IOConnectCallScalarMethod(lmuDataPort, kGetLEDBrightnessID,
                                           inputs, UInt32(inputs.count),
                                           &outputValue, &outputCount)
        guard kr == KERN_SUCCESS else {
            throw SensorError.Keyboard.notStandard
        }

        return Float(outputValue) / Float(0xfff)
    }

    private static func getM1KeyboardBrightness() throws -> Float {
        let task = Process()
        task.launchPath = "/usr/libexec/corebrightnessdiag"
        task.arguments = ["status-info"]
        let pipe = Pipe()
        task.standardOutput = pipe
        try task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()

        if let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? NSDictionary,
           let keyboards = plist["CBKeyboards"] as? [String: [String: Any]] {
            for keyboard in keyboards.values {
                if let backlightInfo = keyboard["CBKeyboardBacklightContainer"] as? [String: Any],
                    backlightInfo["KeyboardBacklightBuiltIn"] as? Bool == true,
                    let brightness = backlightInfo["KeyboardBacklightBrightness"] as? Float {
                        return brightness
                }
            }
        }

        throw SensorError.Keyboard.notSilicon
    }
}
