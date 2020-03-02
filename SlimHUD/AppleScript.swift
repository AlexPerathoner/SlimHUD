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
		if let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) {
//			print(output.stringValue)
			return output.stringValue
		} else if (error != nil) {
			print("error: \(error)")
		}
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



enum LoadState {
	case load
	case unload
}

@discardableResult
func shell(_ load: LoadState) -> NSString? {

    let task = Process()
    task.launchPath = "/bin/launchctl/"
    task.arguments = ["load","-wF","/System/Library/LaunchAgents/com.apple.OSDUIHelper.plist"]
	if(load == .unload) {
		task.arguments![0] = "unload"
	}
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)

    return output
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
	let ser: CFTypeRef = IORegistryEntryCreateCFProperty(service, "KeyboardBacklightBrightness" as CFString, kCFAllocatorDefault,0).takeUnretainedValue()
	if let result = ser as? Float {
		return result / 342 //max value is 342, proportioning to %
	}
	return 0
}

