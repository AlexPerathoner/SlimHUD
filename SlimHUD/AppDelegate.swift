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
	
	@IBOutlet weak var brightnessBar: ProgressBar!
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	
	var volumeHud = Hud()
	var brightnessHud = Hud()
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		shell(.unload)
		
		//menu bar
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

		
		//setting up huds
		let position = CGPoint.init(x: -7, y: (NSScreen.screens[0].frame.height/2)-(volumeBar.frame.height/2))
		volumeHud.traslate(position)
		volumeBar.rotate(1)
		volumeHud.view = volumeBar
		
		brightnessHud.traslate(position)
		brightnessBar.rotate(1)
		brightnessHud.view = brightnessBar
		brightnessBar.background = .init(red: 0.77, green: 0.7, blue: 0.3, alpha: 1)
	}
	
	@objc func showVolumeHUD(_ sender: Any) {
		volumeBar.setColor(disabled: isMuted())
		volumeBar.progress = CGFloat(getOutputVolume())/100.0

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
		let br = Double(String(str[..<index]))!
		brightnessHud.show()
		volumeHud.hide(animated: false)
		
		(brightnessHud.view as! ProgressBar).progress = CGFloat(br)
		brightnessHud.dismiss(delay: 1.5)
	}
	
	//If the application closes without applicationWillTerminate() being called the default OSX hud won't be displayed again automatically. To enable it manually run "launchctl load -wF /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist"
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
		shell(.load)
	}

}

let gray = NSColor.init(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 0.9)
let blue = NSColor.init(red: 49/255.0, green: 130/255.0, blue: 247/255.0, alpha: 0.9)

extension ProgressBar {
	func setColor(disabled: Bool) {
		if(disabled) {
			self.foreground = gray
		} else {
			self.foreground = blue
		}
	}
}

extension NSView {
	func rotate(_ n: CGFloat) {
		if let layer = self.layer, let animatorLayer = self.animator().layer {
			layer.position = CGPoint(x: layer.frame.midX, y: layer.frame.midY)
			layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

			NSAnimationContext.beginGrouping()
			NSAnimationContext.current.allowsImplicitAnimation = true
			animatorLayer.transform = CATransform3DMakeRotation(n*CGFloat.pi / 2, 0, 0, 1)
			NSAnimationContext.endGrouping()
		}
	}
}
