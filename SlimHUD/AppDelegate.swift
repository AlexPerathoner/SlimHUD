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
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	
	var hud = Hud()
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		shell(.unload)
		statusItem.menu = statusMenu
		if let button = statusItem.button {
			button.title = "SlimHUD"
			button.image = NSImage(named: "statusIcon")
			button.image?.isTemplate = true
		}
		
		
		NotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD(_:)), name: MediaApplication.volumeChanged, object: nil)
		DistributedNotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD(_:)), name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"), object: nil)

		hud.traslate(.init(x: -7, y: (NSScreen.screens[0].frame.height/2)-(volumeBar.frame.height/2)))
	}
	
	
	@objc func showVolumeHUD(_ sender: Any) {
		volumeBar.setColor(disabled: isMuted())
		volumeBar.progressValue = getOutputVolume()

		hud.show(aview: volumeBar)
		hud.dismiss(delay: 1.5)
	}
	
	///If the application closes without applicationWillTerminate() being called the default OSX hud won't be displayed again automatically. To enable it manually run "launchctl load -wF /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist"
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
