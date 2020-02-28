//
//  AppDelegate.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet var statusMenu: NSMenu!
	
	@IBAction func quitCliked(_ sender: Any) {
		shell(.load)
		NSApplication.shared.terminate(self)
	}
	
	@IBOutlet weak var volumeBar: ProgressBar!
	@IBOutlet weak var volumeView: NSView!
	
	@IBOutlet weak var brightnessBar: ProgressBar!
	@IBOutlet weak var brightnessView: NSView!
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	
	var volumeHud = Hud()
	var brightnessHud = Hud()
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		shell(.unload)
		statusItem.menu = statusMenu
		if let button = statusItem.button {
			button.title = "SlimHUD"
			button.image = NSImage(named: "statusIcon")
			button.image?.isTemplate = true
		}
		
		//observers for volume
		NotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD(_:)), name: ObserverApplication.volumeChanged, object: nil)
		DistributedNotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD(_:)), name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"), object: nil)
		
		//observers for brightness
		NotificationCenter.default.addObserver(self, selector: #selector(showBrightnessHUD(_:)), name: ObserverApplication.brightnessChanged, object: nil)
		DistributedNotificationCenter.default.addObserver(self, selector: #selector(showBrightnessHUD(_:)), name: NSNotification.Name(rawValue: "com.apple.brightness.settingsChangedNotification"), object: nil)

		let position = CGPoint.init(x: -7, y: (NSScreen.screens[0].frame.height/2)-(volumeBar.frame.height/2))
		volumeHud.traslate(position)
		volumeHud.view = volumeView
		setupShadows()
		
		brightnessHud.traslate(position)
		brightnessHud.view = brightnessView
	}
	
	func setupShadows() {
		volumeView.shadow = NSShadow()
		volumeView.wantsLayer = true
        volumeView.superview?.wantsLayer = true
		volumeView.layer?.shadowOpacity = 1
		volumeView.layer?.shadowColor = .black
        volumeView.layer?.shadowOffset = NSMakeSize(0, 0)
        volumeView.layer?.shadowRadius = 20
		
		brightnessView.shadow = NSShadow()
		brightnessView.wantsLayer = true
        brightnessView.superview?.wantsLayer = true
		brightnessView.layer?.shadowOpacity = 1
		brightnessView.layer?.shadowColor = .black
        brightnessView.layer?.shadowOffset = NSMakeSize(0, 0)
        brightnessView.layer?.shadowRadius = 20
	}
	
	@objc func showVolumeHUD(_ sender: Any) {
		volumeBar.setColor(disabled: isMuted())
		volumeBar.progressValue = getOutputVolume()

		volumeHud.show()
		brightnessHud.hide(animated: false)
		volumeHud.dismiss(delay: 1.5)
	}
	
	@objc func showBrightnessHUD(_ sender: Any) {
		let process = Process()
		process.executableURL = Bundle.main.url(forResource: "dbrightness", withExtension: "")
		let outputPipe = Pipe()
		process.standardOutput = outputPipe
		try? process.run()
		let output = outputPipe.fileHandleForReading.readDataToEndOfFile()
		let str = String(decoding: output, as: UTF8.self)
		
		let index = str.index(str.startIndex, offsetBy: 4)
		let br = Int(Double(String(str[..<index]))! * 100)
		brightnessHud.show()
		volumeHud.hide(animated: false)
		(brightnessHud.view as! ProgressBar).progressValue = br
		brightnessHud.dismiss(delay: 1.5)
	}
	
	//If the application closes without applicationWillTerminate() being called the default OSX hud won't be displayed again automatically. To enable it manually run "launchctl load -wF /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist"
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
		shell(.load)
	}

}

let gray = NSColor.init(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
let blue = NSColor.init(red: 49/255.0, green: 130/255.0, blue: 247/255.0, alpha: 1)

extension ProgressBar {
	func setColor(disabled: Bool) {
		if(disabled) {
			self.barColor = gray
		} else {
			self.barColor = blue
		}
	}
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


func getBrightness() -> Int {
    var brightness: Float = 1.0
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
    return Int(brightness*100)
}

