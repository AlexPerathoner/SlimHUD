//
//  AppDelegate.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import QuartzCore



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, SettingsWindowControllerDelegate {

	// MARK: - Settings & setups
	var shouldUseAnimation = true {
		didSet {
			volumeHud.animated = shouldUseAnimation
			brightnessHud.animated = shouldUseAnimation
			backlightHud.animated = shouldUseAnimation
		}
	}
	private let shadowRadius: CGFloat = 20
	var disabledColor = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
	var enabledColor = NSColor(red: 0.19, green: 0.5, blue: 0.96, alpha: 0.9)
	
	var settingsController = SettingsController()
	
	func updateShadows(enabled: Bool) {
		setupShadow(for: volumeView, enabled)
		setupShadow(for: backlightView, enabled)
		setupShadow(for: brightnessView, enabled)
	}
	
	func updateIcons(isHidden: Bool) {
		volumeImage.isHidden = isHidden
		brightnessImage.isHidden = isHidden
		backlightImage.isHidden = isHidden
	}
	
	func setupDefaultColors() {
		enabledColor = settingsController.blue
		disabledColor = settingsController.gray
		backlightBar.foreground = settingsController.azure
		brightnessBar.foreground = settingsController.yellow
		volumeBar.background = settingsController.darkGray
		backlightBar.background = settingsController.darkGray
		brightnessBar.background = settingsController.darkGray
	}
	
	func setBackgroundColor(color: NSColor) {
		volumeBar.background = color
		backlightBar.background = color
		brightnessBar.background = color
	}
	func setVolumeEnabledColor(color: NSColor) {
		enabledColor = color
	}
	func setVolumeDisabledColor(color: NSColor) {
		disabledColor = color
	}
	func setBrightnessColor(color: NSColor) {
		brightnessBar.foreground = color
	}
	func setBacklightColor(color: NSColor) {
		backlightBar.foreground = color
	}
	
	func updateAll() {
		updateIcons(isHidden: !settingsController.shouldShowIcons)
		updateShadows(enabled: settingsController.shouldShowShadows)
		setBackgroundColor(color: settingsController.backgroundColor)
		setVolumeEnabledColor(color: settingsController.volumeEnabledColor)
		setVolumeDisabledColor(color: settingsController.volumeDisabledColor)
		setBrightnessColor(color: settingsController.brightnessColor)
		setBacklightColor(color: settingsController.keyboardColor)
	}
	
	func setupTimer(with t: TimeInterval) {
		let timer = Timer(timeInterval: t, target: self, selector: #selector(checkChanges), userInfo: nil, repeats: true)
		let mainLoop = RunLoop.main
		mainLoop.add(timer, forMode: .common)
	}
	
	
	func setupShadow(for view: NSView, _ enabled: Bool) {
		if(enabled) {
			view.shadow = NSShadow()
			view.wantsLayer = true
			view.superview?.wantsLayer = true
			view.layer?.shadowOpacity = 1
			view.layer?.shadowColor = .black
			view.layer?.shadowOffset = NSMakeSize(0, 0)
			view.layer?.shadowRadius = shadowRadius
		} else {
			view.shadow = nil
		}
	}
	
	func setHeight(height: CGFloat) {
		
		let viewSize = volumeView.frame
		for view in [volumeView, brightnessView, backlightView] as [NSView] {
			view.setFrameSize(NSSize(width: viewSize.width, height: height))
		}
		setupHUDsPosition()
	}
	
	func setupHUDsPosition() {
		var position: CGPoint		
		
		let viewSize = volumeView.frame
		let screenSize = NSScreen.screens[0].frame
		
		switch settingsController.position {
		case .left:
			position = CGPoint(x: 0, y: (screenSize.height/2)-(viewSize.height/2))
		case .right:
			position = CGPoint(x: (screenSize.width)-(viewSize.width)-shadowRadius, y: (screenSize.height/2)-(viewSize.height/2))
		case .bottom:
			position = CGPoint(x: (screenSize.width/2)-(viewSize.height/2), y: 0)
		case .top:
			position = CGPoint(x: (screenSize.width/2)-(viewSize.height/2), y: (screenSize.height)-(viewSize.width)-shadowRadius)
		}
		
		for hud in [volumeHud, brightnessHud, backlightHud] as [Hud] {
			hud.position = position
			hud.rotated = settingsController.position
		}
		
		let rotated = settingsController.position == .bottom || settingsController.position == .top
		for view in [volumeView, brightnessView, backlightView] as [NSView] {
			view.layer?.anchorPoint = CGPoint(x: 0, y: 0)
			if(rotated) {
				view.frameCenterRotation = -90
				view.setFrameOrigin(.init(x: 0, y: viewSize.width))
			} else {
				view.frameCenterRotation = 0
				view.setFrameOrigin(.init(x: 0, y: 0))
			}
			
			//needs a bit space more for displaying shadows...
			if(settingsController.position == .right) {
				view.setFrameOrigin(.init(x: shadowRadius, y: 0))
			}
			if(settingsController.position == .top) {
				view.setFrameOrigin(.init(x: 0, y: shadowRadius+viewSize.width))
			}
		}
		
		//rotating icons of view
		if(settingsController.shouldShowIcons) {
			for image in [volumeImage, brightnessImage, backlightImage] as [NSImageView] {
				if(rotated) {
					while(image.boundsRotation.truncatingRemainder(dividingBy: 360) != 90) {
						image.rotate(byDegrees: 90)
					}
				} else {
					while(image.boundsRotation.truncatingRemainder(dividingBy: 360) != 0) {
						image.rotate(byDegrees: 90)
					}
				}
			}
		}
		
	}
	
	
	
	// MARK: - Views, bars & HUDs
	
	@IBOutlet weak var volumeBar: ProgressBar!
	@IBOutlet weak var volumeView: NSView!
	
	@IBOutlet weak var brightnessBar: ProgressBar!
	@IBOutlet weak var brightnessView: NSView!
	
	@IBOutlet weak var backlightBar: ProgressBar!
	@IBOutlet weak var backlightView: NSView!
	
	@IBOutlet weak var volumeImage: NSImageView!
	@IBOutlet weak var brightnessImage: NSImageView!
	@IBOutlet weak var backlightImage: NSImageView!
	
	var volumeHud = Hud()
	var brightnessHud = Hud()
	var backlightHud = Hud()
	
	// MARK: -
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	
	@IBOutlet var statusMenu: NSMenu!
	
	@IBAction func quitCliked(_ sender: Any) {
		shell(.load)
		NSApplication.shared.terminate(self)
	}
		
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
		
		//continuous check - 0.2 should not take more than 1/800 CPU
		setupTimer(with: 0.2)
		
		
		NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification,
															object: NSApplication.shared,
															queue: OperationQueue.main) {
				notification -> Void in
																self.setupHUDsPosition()
		}
		
		
		//Setting up huds
		
		oldVolume = getOutputVolume()
		oldBacklight = getKeyboardBrightness()
		oldBrightness = getDisplayBrightness()
		
		shouldUseAnimation = settingsController.shouldUseAnimation
		
		volumeHud.view = volumeView
		brightnessHud.view = brightnessView
		backlightHud.view = backlightView
		

		for image in [volumeImage, brightnessImage, backlightImage] as [NSImageView] {
			image.wantsLayer = true
			image.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		}
		
		setHeight(height: CGFloat(settingsController.barHeight))
		
		
		updateAll()
	}
	
	
	
	// MARK: - Displayers
	let settingsWindowController: SettingsWindowController = SettingsWindowController(windowNibName: "SettingsWindow")
	
	
	@IBAction func showWindow(_ sender: Any) {

		settingsWindowController.delegate = self
		settingsWindowController.settingsController = settingsController

		settingsWindowController.window?.center()
        settingsWindowController.window?.makeFirstResponder(nil)
        settingsWindowController.window?.makeKeyAndOrderFront(settingsWindowController)
		settingsWindowController.showWindow(self)
		NSApp.activate(ignoringOtherApps: true)
		
	}
	
	
	@objc func showVolumeHUD() {
		let disabled = isMuted()
		setColor(for: volumeBar, disabled)
		if(!settingsController.shouldContinuouslyCheck) {
			volumeBar.progress = CGFloat(getOutputVolume())
		}
		
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
	
	// MARK: - Check functions
	
	
	@objc func checkChanges() {
		checkBacklightChanges()
		checkBrightnessChanges()
		if(settingsController.shouldContinuouslyCheck) {
			checkVolumeChanges()
		}
	}
	
	var oldVolume: Float = 0.5
	func checkVolumeChanges() {
		let newVolume = getOutputVolume()
		if(oldVolume != newVolume) {
			NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
			volumeBar.progress = CGFloat(newVolume)
			oldVolume = newVolume
		}
	}
	
	var oldBacklight: Float = 0.5
	func checkBacklightChanges() {
		let newBacklight = getKeyboardBrightness()
		if(oldBacklight != newBacklight) {
			NotificationCenter.default.post(name: ObserverApplication.keyboardIlluminationChanged, object: self)
			backlightBar.progress = CGFloat(newBacklight)
			oldBacklight = newBacklight
		}
	}
	
	var oldBrightness: Float = 0.5
	func checkBrightnessChanges() {
		let newBrightness = getDisplayBrightness()
		if(oldBrightness != newBrightness) {
			NotificationCenter.default.post(name: ObserverApplication.brightnessChanged, object: self)
			brightnessBar.progress = CGFloat(newBrightness)
			oldBrightness = newBrightness
		}
	}
	
	// MARK: -
	
	func setColor(for bar: ProgressBar, _ disabled: Bool) {
		if(disabled) {
			bar.foreground = disabledColor
		} else {
			bar.foreground = enabledColor
		}
	}
	
	//If the application closes without applicationWillTerminate() being called the default OSX hud won't be displayed again automatically. To enable it manually run "launchctl load -wF /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist"
	//PS: auto toggling of the system agent only works if SIP (Sistem Integrity Protection) is disabled. -> see "csrutil status"
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
		shell(.load)
	}
	
}
