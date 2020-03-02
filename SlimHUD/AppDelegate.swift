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
	
	// TODO: Add option to hide images
	//var shouldShowIcons = false
	
	
	@IBOutlet var statusMenu: NSMenu!
	
	@IBAction func quitCliked(_ sender: Any) {
		shell(.load)
		NSApplication.shared.terminate(self)
	}
	
	@IBOutlet weak var volumeBar: ProgressBar!
	@IBOutlet weak var volumeView: NSView!
	
	@IBOutlet weak var brightnessBar: ProgressBar!
	@IBOutlet weak var brightnessView: NSView!
	
	@IBOutlet weak var backlightBar: ProgressBar!
	@IBOutlet weak var backlightView: NSView!
	
	@IBOutlet weak var volumeImage: NSImageView!
	@IBOutlet weak var brightnessImage: NSImageView!
	@IBOutlet weak var backlightImage: NSImageView!
	
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	
	var volumeHud = Hud()
	var brightnessHud = Hud()
	var backlightHud = Hud()

	
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
		NotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD), name: ObserverApplication.volumeChanged, object: nil)
		DistributedNotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD), name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"), object: nil)
		
		//observers for brightness
		NotificationCenter.default.addObserver(self, selector: #selector(showBrightnessHUD), name: ObserverApplication.brightnessChanged, object: nil)
		
		//observers for keyboard backlight
		NotificationCenter.default.addObserver(self, selector: #selector(showBackLightHUD), name: ObserverApplication.keyboardIlluminationChanged, object: nil)
		
		
		//As with external keyboards the above instruction doesn't work a Runloop is necessary
		let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(checkChanges), userInfo: nil, repeats: true)
		let mainLoop = RunLoop.main
		mainLoop.add(timer, forMode: .common)
		
		
		
		//Setting up huds
		let position = CGPoint.init(x: -7, y: (NSScreen.screens[0].frame.height/2)-(volumeBar.frame.height/2))
		volumeHud.traslate(position)
		volumeHud.view = volumeView
		setupShadows()
		
		brightnessHud.traslate(position)
		brightnessBar.foreground = .init(red: 0.77, green: 0.7, blue: 0.3, alpha: 0.9)
		brightnessHud.view = brightnessView
		
		backlightHud.traslate(position)
		backlightBar.foreground = .init(red: 0.62, green: 0.8, blue: 0.91, alpha: 0.9)
		backlightHud.view = backlightView
		
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
	
	@objc func showVolumeHUD() {
		let disabled = isMuted()
		volumeBar.setColor(disabled)
		if(disabled) {
			volumeImage.image = NSImage(named: "noVolume")
		} else {
			volumeImage.image = NSImage(named: "volume")
		}
		volumeHud.show()
		brightnessHud.hide(animated: false)
		backlightHud.hide(animated: false)
		volumeHud.dismiss(delay: 1.5)
	}
	
	@objc func showBrightnessHUD() {
		brightnessHud.show()
		volumeHud.hide(animated: false)
		backlightHud.hide(animated: false)
		brightnessHud.dismiss(delay: 1.5)
	}
	@objc func showBackLightHUD() {
		backlightHud.show()
		volumeHud.hide(animated: false)
		brightnessHud.hide(animated: false)
		backlightHud.dismiss(delay: 1.5)
	}
	
	@objc func checkChanges() {
		checkBacklightChanges()
		checkBrightnessChanges()
		checkVolumeChanges()
	}
	
	var oldVolume = getOutputVolume()
	func checkVolumeChanges() {
		let newVolume = getOutputVolume()
		if(oldVolume != newVolume) {
			NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
			volumeBar.progress = CGFloat(newVolume)
			oldVolume = newVolume
		}
	}
	
	var oldBacklight = getKeyboardBrightness()
	func checkBacklightChanges() {
		let newBacklight = getKeyboardBrightness()
		if(oldBacklight != newBacklight) {
			NotificationCenter.default.post(name: ObserverApplication.keyboardIlluminationChanged, object: self)
			backlightBar.progress = CGFloat(newBacklight)
			oldBacklight = newBacklight
		}
	}
	
	var oldBrightness = getDisplayBrightness()
	func checkBrightnessChanges() {
		let newBrightness = getDisplayBrightness()
		if(oldBrightness != newBrightness) {
			NotificationCenter.default.post(name: ObserverApplication.brightnessChanged, object: self)
			brightnessBar.progress = CGFloat(newBrightness)
			oldBrightness = newBrightness
		}
	}
	
	//If the application closes without applicationWillTerminate() being called the default OSX hud won't be displayed again automatically. To enable it manually run "launchctl load -wF /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist"
	//PS: auto toggling of the system agent only works if SIP (Sistem Integrity Protection) is disabled. -> see "csrutil status"
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
		shell(.load)
	}

}

let gray = NSColor.init(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 0.9)
let blue = NSColor.init(red: 49/255.0, green: 130/255.0, blue: 247/255.0, alpha: 0.9)

extension ProgressBar {
	func setColor(_ disabled: Bool) {
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
