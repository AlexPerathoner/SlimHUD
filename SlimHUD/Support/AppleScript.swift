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


func getDisplayBrightness() -> Float {
	var brightness: float_t = 1
	let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"))
	
	IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
	IOObjectRelease(service)
	return brightness
}

func getKeyboardBrightnessProportioned(raw: Float) -> Float {
    if(raw <= 0.07) { return 0 }
    return (log10(raw+0.03)+1)
}

let MAX_KEYBOARD_BRIGHTNESS: Float = 342;

func getRawKeyboardBrightness() -> Float {
	let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("AppleHIDKeyboardEventDriverV2"))
	defer {
		IOObjectRelease(service)
	}
	
	if let ser: CFTypeRef = IORegistryEntryCreateCFProperty(service, "KeyboardBacklightBrightness" as CFString, kCFAllocatorDefault, 0)?.takeUnretainedValue() {
		let result = ser as! Float
		return result / MAX_KEYBOARD_BRIGHTNESS //max value is 342, proportioning to %
	}
    return 0 // todo: should throw exception, maybe show "disabled" icon?
}
