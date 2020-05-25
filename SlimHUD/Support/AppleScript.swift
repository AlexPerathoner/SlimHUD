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
	var brightness: Float = 0
	var service: io_object_t = 1
	var iterator: io_iterator_t = 0
	let result: kern_return_t = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator)
	if result == kIOReturnSuccess {
		while service != 0 {
			service = IOIteratorNext(iterator)
			IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
			IOObjectRelease(service)
		}
	}
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
