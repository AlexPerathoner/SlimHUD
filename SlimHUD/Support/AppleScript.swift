//
//  AppleScript.swift
//  MusicBar
//
//  Created by Alex Perathoner on 26/12/2019.
//
import Foundation

func runAS(script: String) -> String? {
	var error: NSDictionary?
	if let scriptObject = NSAppleScript(source: script) {
		let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
		return output.stringValue		
	}
	return nil
}

func isMuted() -> Bool {
	return runAS(script: "return output muted of (get volume settings)") == "true"
}

func getVolumeSettings() -> (outPutVolume: Int, inputVolume: Int, alertVolume: Int, outputMuted: Bool) {
	let o1 = Int(runAS(script: "return output volume of (get volume settings)") ?? "1")!
	let o2 = Int(runAS(script: "return input volume of (get volume settings)") ?? "1")!
	let o3 = Int(runAS(script: "return alert volume of (get volume settings)") ?? "1")!
	let o4 = runAS(script: "return output muted of (get volume settings)") == "true"

	return (o1, o2, o3, o4)
}

func getOutputVolume() -> Float {
	return Float(runAS(script: "return output volume of (get volume settings)") ?? "1")! / 100.0
}


func getDisplayBrightness() throws -> Float {
    var brightness: float_t = 1
    let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"))
    defer {
        IOObjectRelease(service)
    }
    
    let result = IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
    
    if(result != kIOReturnSuccess) {
        throw SensorError.displayBrightnessFailure
    }
	return brightness
}

enum SensorError: Error {
    case displayBrightnessFailure
    case keyboardBrightnessFailure
    case m1BrightnessFailure
}

func getM1Brightness() throws -> (display: Float, keyboard: Float) {
    let task = Process()
    task.launchPath = "/usr/libexec/corebrightnessdiag"
    task.arguments = ["status-info"]
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    task.waitUntilExit()

    var displayBrightness: Float?
    var keyboardBrightness: Float?

    if let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? NSDictionary {
        if let displays = plist["CBDisplays"] as? [String: [String: Any]] {
            for display in displays.values {
                if let displayInfo = display["Display"] as? [String: Any],
                    displayInfo["DisplayServicesIsBuiltInDisplay"] as? Bool == true,
                    let brightness = displayInfo["DisplayServicesBrightness"] as? Float {
                        displayBrightness = brightness
                        break
                }
            }
        }
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
    if let displayBrightness = displayBrightness, let keyboardBrightness = keyboardBrightness {
        return (displayBrightness, keyboardBrightness)
    } else {
        throw SensorError.m1BrightnessFailure
    }
}

func getKeyboardBrightness() throws -> Float {
	let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleHIDKeyboardEventDriverV2"))
	defer {
		IOObjectRelease(service)
	}
	
	if let ser: CFTypeRef = IORegistryEntryCreateCFProperty(service, "KeyboardBacklightBrightness" as CFString, kCFAllocatorDefault, 0)?.takeUnretainedValue() {
		let result = ser as! Float
		return result / 342 //max value is 342, proportioning to %
	}
    
    throw SensorError.displayBrightnessFailure
}
