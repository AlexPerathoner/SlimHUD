//
//  AppDelegate.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import QuartzCore
import AppKit

@NSApplicationMain
class AppDelegate: NSWindowController, NSApplicationDelegate, SettingsWindowControllerDelegate {
	
	
	// MARK: - General
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	
	@IBOutlet weak var statusMenu: NSMenu!
	
	
	@IBAction func quitCliked(_ sender: Any) {
		NSApplication.shared.terminate(self)
	}
	
	// MARK: - Views, bars & HUDs
	
	/*
	let volumeBar = ProgressBar()
	let brightnessBar = ProgressBar()
	let keyboardBar = ProgressBar()
	let volumeView = NSView()
	let brightnessView = NSView()
	let keyboardView = NSView()
	let volumeImage = NSImageView(image: NSImage(named: "volume")!)
	let brightnessImage = NSImageView(image: NSImage(named: "brightness")!)
	let keyboardView.image = NSImageView(image: NSImage(named: "backlight")!)
	*/
	
	var volumeView: BarView = NSView.fromNib(name: "BarView") as! BarView
	var volumeBar: ProgressBar?
	
	var brightnessView: BarView = NSView.fromNib(name: "BarView") as! BarView
	var brightnessBar: ProgressBar?
	
	var keyboardView: BarView = NSView.fromNib(name: "BarView") as! BarView
	var keyboardBar: ProgressBar?
	
	
	var volumeHud = Hud()
	var brightnessHud = Hud()
	var keyboardHud = Hud()
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		volumeBar = volumeView.bar
		volumeView.image!.image = NSImage(named: "volume")
		
		brightnessBar = brightnessView.bar
		brightnessView.image!.image = NSImage(named: "brightness")
		
		keyboardBar = keyboardView.bar
		keyboardView.image!.image = NSImage(named: "backlight")
		
		//menu bar
		statusItem.menu = statusMenu
		
		if let button = statusItem.button {
			button.title = "SlimHUD"
			button.image = NSImage(named: "statusIcon")
			button.image?.isTemplate = true
		}
		
		//Setting up huds
		
		oldVolume = getOutputVolume()
		oldBacklight = getKeyboardBrightness()
		oldBrightness = getDisplayBrightness()
		
		shouldUseAnimation = settingsController!.shouldUseAnimation
		
		volumeHud.view = volumeView
		brightnessHud.view = brightnessView
		keyboardHud.view = keyboardView
		
		enabledBars = settingsController!.enabledBars
		marginValue = Float(settingsController!.marginValue)/100.0
		

		for image in [volumeView.image, brightnessView.image, keyboardView.image] as [NSImageView?] {
			image?.wantsLayer = true
			image?.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		}
		
		setHeight(height: CGFloat(settingsController!.barHeight))
		setThickness(thickness: CGFloat(settingsController!.barThickness))
		
		updateAll()
	}
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		NSColor.ignoresAlpha = false
		
		//observers for volume
		NotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD), name: ObserverApplication.volumeChanged, object: nil)
		DistributedNotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD), name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"), object: nil)
		
		//observers for brightness
		NotificationCenter.default.addObserver(self, selector: #selector(showBrightnessHUD), name: ObserverApplication.brightnessChanged, object: nil)
		
		//observers for keyboard backlight
		NotificationCenter.default.addObserver(self, selector: #selector(showKeyboardHUD), name: ObserverApplication.keyboardIlluminationChanged, object: nil)
		
		//continuous check - 0.2 should not take more than 1/800 CPU
		//starts to check after all settings have been imported
		setupTimer(with: 0.2)
		
		NotificationCenter.default.addObserver(forName: NSApplication.didChangeScreenParametersNotification,
															object: NSApplication.shared,
															queue: OperationQueue.main) {
				notification -> Void in
																self.setupHUDsPosition(false)
		}
		
	}
	
	
	
	// MARK: - Settings & setups
	var shouldUseAnimation = true {
		didSet {
			volumeHud.animated = shouldUseAnimation
			brightnessHud.animated = shouldUseAnimation
			keyboardHud.animated = shouldUseAnimation
			
			volumeBar?.setupAnimation(animated: shouldUseAnimation)
			brightnessBar?.setupAnimation(animated: shouldUseAnimation)
			keyboardBar?.setupAnimation(animated: shouldUseAnimation)
		}
	}
	
	var enabledBars: [Bool] = [true, true, true]
	var marginValue: Float = 0.05
	
	private let shadowRadius: CGFloat = 20
	var disabledColor = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
	var enabledColor = NSColor(red: 0.19, green: 0.5, blue: 0.96, alpha: 0.9)
	
	var settingsController: SettingsController? = SettingsController()
	
	func updateShadows(enabled: Bool) {
		volumeView.setupShadow(enabled, shadowRadius)
		keyboardView.setupShadow(enabled, shadowRadius)
		brightnessView.setupShadow(enabled, shadowRadius)
	}
	
	func updateIcons(isHidden: Bool) {
		volumeView.image?.isHidden = isHidden
		brightnessView.image?.isHidden = isHidden
		keyboardView.image?.isHidden = isHidden
	}
	
	func setupDefaultBarsColors() {
		enabledColor = SettingsController.blue
		disabledColor = SettingsController.gray
		keyboardBar?.foreground = SettingsController.azure
		brightnessBar?.foreground = SettingsController.yellow
		volumeBar?.background = SettingsController.darkGray
		keyboardBar?.background = SettingsController.darkGray
		brightnessBar?.background = SettingsController.darkGray
	}
	
	func setupDefaultIconsColors() {
		setVolumeIconsTint(.white)
		setBrightnessIconsTint(.white)
		setKeyboardIconsTint(.white)
	}
	
	func setBackgroundColor(color: NSColor) {
		volumeBar?.background = color
		keyboardBar?.background = color
		brightnessBar?.background = color
	}
	func setVolumeEnabledColor(color: NSColor) {
		enabledColor = color
	}
	func setVolumeDisabledColor(color: NSColor) {
		disabledColor = color
	}
	func setBrightnessColor(color: NSColor) {
		brightnessBar?.foreground = color
	}
	func setKeyboardColor(color: NSColor) {
		keyboardBar?.foreground = color
	}
	
	func updateAll() {
		updateIcons(isHidden: !settingsController!.shouldShowIcons)
		updateShadows(enabled: settingsController!.shouldShowShadows)
		setBackgroundColor(color: settingsController!.backgroundColor)
		setVolumeEnabledColor(color: settingsController!.volumeEnabledColor)
		setVolumeDisabledColor(color: settingsController!.volumeDisabledColor)
		setBrightnessColor(color: settingsController!.brightnessColor)
		setKeyboardColor(color: settingsController!.keyboardColor)
		setVolumeIconsTint(settingsController!.volumeIconColor)
		setBrightnessIconsTint(settingsController!.brightnessIconColor)
		setKeyboardIconsTint(settingsController!.keyboardIconColor)
	}
	
	func setupTimer(with t: TimeInterval) {
		let timer = Timer(timeInterval: t, target: self, selector: #selector(checkChanges), userInfo: nil, repeats: true)
		let mainLoop = RunLoop.main
		mainLoop.add(timer, forMode: .common)
	}
	
	
	
	
	func setHeight(height: CGFloat) {
		let viewSize = volumeView.frame
		for view in [volumeView, brightnessView, keyboardView] as [NSView?] {
			view?.setFrameSize(NSSize(width: viewSize.width ?? 10, height: height+60))
		}
		setupHUDsPosition(isInFullscreenMode())
	}
	
	func setThickness(thickness: CGFloat) {
		let viewSize = volumeView.frame
		for view in [volumeView, brightnessView, keyboardView] as [NSView?] {
			view?.setFrameSize(NSSize(width: thickness+40, height: viewSize.height ?? 10))
		}
		for bar in [volumeBar, brightnessBar, keyboardBar] as [ProgressBar?] {
			bar?.progressLayer.frame.size.width = thickness //setting up inner layer
			bar?.progressLayer.cornerRadius = thickness/2
			bar?.frame.size.width = thickness //setting up outer layer
		}
		
		setupHUDsPosition(isInFullscreenMode())
	}
	
	
	
	
	func setVolumeIconsTint(_ color: NSColor) {
		volumeView.image?.contentTintColor = color
	}
	func setBrightnessIconsTint(_ color: NSColor) {
		brightnessView.image?.contentTintColor = color
	}
	func setKeyboardIconsTint(_ color: NSColor) {
		keyboardView.image?.contentTintColor = color
	}
	
	
	private func getScreenInfo() -> (screenFrame: NSRect, xDockHeight: CGFloat, yDockHeight: CGFloat, menuBarThickness: CGFloat, dockPosition: Position) {
		let visibleFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
		let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
		let yDockHeight: CGFloat = visibleFrame.minY
		let xDockHeight: CGFloat = screenFrame.width - visibleFrame.width
		var menuBarThickness: CGFloat = 0
		
		if((screenFrame.height - visibleFrame.height - yDockHeight) != 0) { //menu bar visible
			menuBarThickness = NSStatusBar.system.thickness
		}
		let dockPosition = Position(rawValue: (UserDefaults.standard.persistentDomain(forName: "com.apple.dock")!["orientation"] as? String) ?? "bottom")
		return (visibleFrame, xDockHeight, yDockHeight, menuBarThickness, dockPosition ?? .bottom)
	}
	
	
	func setupHUDsPosition(_ isFullscreen: Bool) {
		volumeHud.hide(animated: false)
		brightnessHud.hide(animated: false)
		keyboardHud.hide(animated: false)
		
		
		var position: CGPoint
		let viewSize = volumeView.frame
		
		let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
		
		// Here the magic takes place, let it happen
		var (visibleFrame, xDockHeight, yDockHeight, menuBarThickness, dockPosition): (NSRect, CGFloat, CGFloat, CGFloat, Position)// = getScreenInfo()
		if(isFullscreen) {
			(visibleFrame, xDockHeight, yDockHeight, menuBarThickness, dockPosition) = (screenFrame, 0, 0, 0, .bottom)
		} else {
			(visibleFrame, xDockHeight, yDockHeight, menuBarThickness, dockPosition) = getScreenInfo()
		}
		switch settingsController!.position {
		case .left:
			if(dockPosition == .right) {xDockHeight=0}
			position = CGPoint(x: xDockHeight, y: (visibleFrame.height/2)-(viewSize.height/2) + yDockHeight)
		case .right:
			if(dockPosition == .left) {xDockHeight=0}
			position = CGPoint(x: (NSScreen.screens[0].frame.width)-(viewSize.width)-shadowRadius-xDockHeight, y: (visibleFrame.height/2)-(viewSize.height/2) + yDockHeight)
		case .bottom:
			position = CGPoint(x: (screenFrame.width/2)-(viewSize.height/2), y: yDockHeight)
		case .top:
			position = CGPoint(x: (screenFrame.width/2)-(viewSize.height/2), y: (NSScreen.screens[0].frame.height)-(viewSize.width)-shadowRadius-menuBarThickness)
		}
		//end of magic
		
		for hud in [volumeHud, brightnessHud, keyboardHud] as [Hud] {
			hud.position = position
			hud.rotated = settingsController!.position
		}
		
		let rotated = settingsController!.position == .bottom || settingsController!.position == .top
		for view in [volumeView, brightnessView, keyboardView] as [NSView?] {
			view?.layer?.anchorPoint = CGPoint(x: 0, y: 0)
			if(rotated) {
				view?.frameCenterRotation = -90
				view?.setFrameOrigin(.init(x: 0, y: viewSize.width))
			} else {
				view?.frameCenterRotation = 0
				view?.setFrameOrigin(.init(x: 0, y: 0))
			}
			
			//needs a bit more space for displaying shadows...
			if(settingsController!.position == .right) {
				view?.setFrameOrigin(.init(x: shadowRadius, y: 0))
			}
			if(settingsController!.position == .top) {
				view?.setFrameOrigin(.init(x: 0, y: shadowRadius+viewSize.width))
			}
		}
		
		//rotating icons of views
		if(settingsController!.shouldShowIcons) {
			for image in [volumeView.image, brightnessView.image, keyboardView.image] as [NSImageView?] {
				if(rotated) {
					while(image!.boundsRotation.truncatingRemainder(dividingBy: 360) != 90) {
						image!.rotate(byDegrees: 90)
					}
				} else {
					while(image!.boundsRotation.truncatingRemainder(dividingBy: 360) != 0) {
						image!.rotate(byDegrees: 90)
					}
				}
			}
		}
	}
	
	
	
	
	
	
	// MARK: - Displayers
	
	@objc func showVolumeHUD() {
		if(!enabledBars[0]) {return}
		let disabled = isMuted()
		setColor(for: volumeBar!, disabled)
		if(!settingsController!.shouldContinuouslyCheck) {
			volumeBar!.progress = CGFloat(getOutputVolume())
		}
		
		if(disabled) {
			volumeView.image!.image = NSImage(named: "noVolume")
		} else {
			volumeView.image!.image = NSImage(named: "volume")
		}
		volumeHud.show()
		brightnessHud.hide(animated: false)
		keyboardHud.hide(animated: false)
		volumeHud.dismiss(delay: 1.5)
	}
	
	@objc func showBrightnessHUD() {
		if(!enabledBars[1]) {return}
		brightnessHud.show()
		volumeHud.hide(animated: false)
		keyboardHud.hide(animated: false)
		brightnessHud.dismiss(delay: 1.5)
	}
	@objc func showKeyboardHUD() {
		if(!enabledBars[2]) {return}
		keyboardHud.show()
		volumeHud.hide(animated: false)
		brightnessHud.hide(animated: false)
		keyboardHud.dismiss(delay: 1.5)
	}
	
	// MARK: - Check functions
	
	func isInFullscreenMode() -> Bool {
		let options = CGWindowListOption(arrayLiteral: CGWindowListOption.excludeDesktopElements, CGWindowListOption.optionOnScreenOnly)
		let windowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
		let infoList = windowListInfo as NSArray? as? [[String: AnyObject]] ?? []
		let screenSize = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
		for i in infoList {
			let windowName = i["kCGWindowOwnerName"] as? String ?? ""
			
			//if Window Server or Dock are visible the user is certainly not using fullscreen
			if(windowName == "Window Server" || windowName == "Dock") {return false}
			if (i["kCGWindowBounds"]?["Height"] as? CGFloat ?? 0 == screenSize.height && i["kCGWindowBounds"]?["Width"] as? CGFloat ?? 0 == screenSize.width && windowName != "Dock" && windowName != "SlimHUD") {
				return true
			}
		}
		
		return true
	}
	
	var oldFullScreen = false
	@objc func checkChanges() {
		let newFullScreen = isInFullscreenMode()
		
		if(newFullScreen != oldFullScreen) {
			setupHUDsPosition(newFullScreen)
			oldFullScreen = newFullScreen
		}
		
		if(enabledBars[2]) {
			checkBacklightChanges()
		}
		if(enabledBars[1]) {
			checkBrightnessChanges()
		}
		if(settingsController!.shouldContinuouslyCheck && enabledBars[0]) {
			checkVolumeChanges()
		}
	}
	
	func isAlmost(n1: Float, n2: Float) -> Bool { //used to partially prevent the bars to display when no user input happened
		return (n1+marginValue >= n2 && n1-marginValue <= n2)
	}
	
	var oldVolume: Float = 0.5
	func checkVolumeChanges() {
		let newVolume = getOutputVolume()
		volumeBar!.progress = CGFloat(newVolume)
		if (!isAlmost(n1: oldVolume, n2: newVolume)) {
			NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
			oldVolume = newVolume
		}
		volumeBar!.progress = CGFloat(newVolume)
	}
	
	var oldBacklight: Float = 0.5
	func checkBacklightChanges() {
		let newBacklight = getKeyboardBrightness()
		if(!isAlmost(n1: oldBacklight, n2: newBacklight)) {
			NotificationCenter.default.post(name: ObserverApplication.keyboardIlluminationChanged, object: self)
			oldBacklight = newBacklight
		}
		keyboardBar?.progress = CGFloat(newBacklight)
	}
	
	var oldBrightness: Float = 0.5
	func checkBrightnessChanges() {
		if(NSScreen.screens.count == 0) {return}
		let newBrightness = getDisplayBrightness()
		if(!isAlmost(n1: oldBrightness, n2: newBrightness)) {
			NotificationCenter.default.post(name: ObserverApplication.brightnessChanged, object: self)
			oldBrightness = newBrightness
		}
		brightnessBar?.progress = CGFloat(newBrightness)
	}
	
	// MARK: -
	
	func setColor(for bar: ProgressBar, _ disabled: Bool) {
		if(disabled) {
			bar.foreground = disabledColor
		} else {
			bar.foreground = enabledColor
		}
	}
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
}
