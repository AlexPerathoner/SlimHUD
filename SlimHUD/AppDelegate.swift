//
//  AppDelegate.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

extension NSControl.StateValue {
	func boolValue() -> Bool {
		if(self.rawValue == 0) {
			return false
		}
		return true
	}
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	
	// MARK: - Default colors
	let gray = NSColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
	let blue = NSColor.init(red: 0.19, green: 0.5, blue: 0.96, alpha: 0.9)
	let yellow = NSColor.init(red: 0.77, green: 0.7, blue: 0.3, alpha: 0.9)
	let azure = NSColor.init(red: 0.62, green: 0.8, blue: 0.91, alpha: 0.9)
	
	var disabledColor = NSColor.init(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
	var enabledColor = NSColor.init(red: 0.19, green: 0.5, blue: 0.96, alpha: 0.9)
	
	// MARK: - Settings (actions + outlets)
	@IBOutlet weak var backgroundColorOutlet: NSColorWell!
	@IBOutlet weak var volumeEnabledColorOutlet: NSColorWell!
	@IBOutlet weak var volumeDisabledColorOutlet: NSColorWell!
	@IBOutlet weak var brightnessColorOutlet: NSColorWell!
	@IBOutlet weak var keyboardColorOutlet: NSColorWell!
	
	@IBAction func shouldShowIconsAction(_ sender: NSButton) {
		let val = !sender.state.boolValue()
		volumeImage.isHidden = val
		brightnessImage.isHidden = val
		backlightImage.isHidden = val
	}
	
	@IBAction func shouldShowShadows(_ sender: NSButton) {
		setupShadows(enabled: sender.state.boolValue())
	}
	
	func setupDefaultColors() {
		backgroundColorOutlet.color = NSColor(red: 0.34, green: 0.4, blue: 0.46, alpha: 1.0)
		volumeEnabledColorOutlet.color = blue
		volumeDisabledColorOutlet.color = gray
		brightnessColorOutlet.color = yellow
		keyboardColorOutlet.color = azure
	}
	
	@IBAction func resetDefaults(_ sender: Any) {
		setupDefaultColors()
		let darkGray = NSColor(red: 0.34, green: 0.4, blue: 0.46, alpha: 1.0)
		volumeBar.background = darkGray
		brightnessBar.background = darkGray
		backlightBar.background = darkGray
		enabledColor = blue
		disabledColor = gray
		brightnessBar.foreground = yellow
		backlightBar.foreground = azure
	}
	
	@IBAction func backgroundColorChanged(_ sender: NSColorWell) {
		volumeBar.background = sender.color
		brightnessBar.background = sender.color
		backlightBar.background = sender.color
	}
	@IBAction func volumeEnabledColorChanged(_ sender: NSColorWell) {
		enabledColor = sender.color
	}
	@IBAction func volumeDisabledColorChanged(_ sender: NSColorWell) {
		disabledColor = sender.color
	}
	@IBAction func brightnessColorChanged(_ sender: NSColorWell) {
		brightnessBar.foreground = sender.color
	}
	@IBAction func keyboardBackLightColorChanged(_ sender: NSColorWell) {
		backlightBar.foreground = sender.color
	}
	
	private var settingsWindowController: NSWindowController?
	@IBOutlet weak var settingsWindow: NSWindow!
	
	@IBAction func showWindow(_ sender: Any) {
		
		
		let window = settingsWindow
		settingsWindowController = NSWindowController(window: window)
		NSApp.activate(ignoringOtherApps: true)
		let controllerWindow = settingsWindowController?.window!
		controllerWindow?.makeKeyAndOrderFront(self)
//		settingsWindowController?.showWindow(self)
//		settingsWindow.makeKeyAndOrderFront(self)
		
		NotificationCenter.default.addObserver(self, selector: #selector(deloccContr), name: NSWindow.willCloseNotification, object: settingsWindow)
	}
	
	@objc func deloccContr() {
		//settingsWindowController?.close()
		settingsWindowController?.dismissController(self)
		settingsWindowController = nil
		settingsWindow = nil
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
		setupDefaultColors()
		
		//observers for volume
		NotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD), name: ObserverApplication.volumeChanged, object: nil)
		DistributedNotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD), name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"), object: nil)
		
		//observers for brightness
		NotificationCenter.default.addObserver(self, selector: #selector(showBrightnessHUD), name: ObserverApplication.brightnessChanged, object: nil)
		
		//observers for keyboard backlight
		NotificationCenter.default.addObserver(self, selector: #selector(showBackLightHUD), name: ObserverApplication.keyboardIlluminationChanged, object: nil)
		
		//continuous check - 0.2 should not take more than 1%% CPU
		setupTimer(with: 0.2)
		
		
		NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification,
															object: NSApplication.shared,
															queue: OperationQueue.main) {
				notification -> Void in
																self.setupHUDsPosition()
		}
		
		
		
		//Setting up huds
		setupShadows(enabled: true)
		setupHUDsPosition()
		
		volumeHud.view = volumeView
		
		brightnessBar.foreground = yellow
		brightnessHud.view = brightnessView
		
		backlightBar.foreground = azure
		backlightHud.view = backlightView
		
	}
	
	func setupHUDsPosition() {
		let position = CGPoint.init(x: -7, y: (NSScreen.screens[0].frame.height/2)-(volumeBar.frame.height/2))
		volumeHud.traslate(position)
		brightnessHud.traslate(position)
		backlightHud.traslate(position)
	}
	
	// MARK: - Setups
	
	func setupTimer(with t: TimeInterval) {
		let timer = Timer(timeInterval: t, target: self, selector: #selector(checkChanges), userInfo: nil, repeats: true)
		let mainLoop = RunLoop.main
		mainLoop.add(timer, forMode: .common)
	}
	
	func setupShadows(enabled: Bool) {
		setupShadow(for: volumeView, enabled)
		setupShadow(for: backlightView, enabled)
		setupShadow(for: brightnessView, enabled)
	}
	
	func setupShadow(for view: NSView, _ enabled: Bool) {
		if(enabled) {
			view.shadow = NSShadow()
			view.wantsLayer = true
			view.superview?.wantsLayer = true
			view.layer?.shadowOpacity = 1
			view.layer?.shadowColor = .black
			view.layer?.shadowOffset = NSMakeSize(0, 0)
			view.layer?.shadowRadius = 20
		} else {
			view.shadow = nil
		}
	}
	
	// MARK: - Displayers
	
	@objc func showVolumeHUD() {
		let disabled = isMuted()
		setColor(for: volumeBar, disabled)
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
