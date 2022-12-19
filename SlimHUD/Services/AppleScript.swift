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


func getDisplayBrightness() -> Float {
	var brightness: float_t = 1
	let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"))
	
	IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
	IOObjectRelease(service)
	return brightness
}

func getKeyboardBrightness() -> Float {
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
