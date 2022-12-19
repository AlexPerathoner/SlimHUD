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
class AppDelegate: NSWindowController, NSApplicationDelegate, SettingsControllerDelegate {    
	
	
	// MARK: - General
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
	
	@IBOutlet weak var statusMenu: NSMenu!
	
	
	@IBAction func quitCliked(_ sender: Any) {
		settingsManager.saveAllItems()
		NSApplication.shared.terminate(self)
	}
    
    
    var enabledBars = EnabledBars(volumeBar: true, brightnessBar: true, keyboardBar: true)
    var marginValue: Float = 0.05
    
    var disabledColor = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
    var enabledColor = NSColor(red: 0.19, green: 0.5, blue: 0.96, alpha: 0.9)
    
    var settingsManager: SettingsManager = SettingsManager.getInstance() // todo remove optional
    
    var oldFullScreen = false
    var oldVolume: Float = 0.5
    var oldBrightness: Float = 0.5
    
	// MARK: - Views, bars & HUDs
	
    var volumeView: BarView = NSView.fromNib(name: BarView.BAR_VIEW_NIB_FILE_NAME) as! BarView
	var brightnessView: BarView = NSView.fromNib(name: BarView.BAR_VIEW_NIB_FILE_NAME) as! BarView
	var keyboardView: BarView = NSView.fromNib(name: BarView.BAR_VIEW_NIB_FILE_NAME) as! BarView
	
	var volumeHud = Hud()
	var brightnessHud = Hud()
	var keyboardHud = Hud()
    
    lazy var positionManager: PositionManager = PositionManager(volumeHud: volumeHud, brightnessHud: brightnessHud, keyboardHud: keyboardHud)
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
        volumeView.image!.image = NSImage(named: NSImage.VOLUME_IMAGE_FILE_NAME)
        brightnessView.image!.image = NSImage(named: NSImage.BRIGHTNESS_IMAGE_FILE_NAME)
        keyboardView.image!.image = NSImage(named: NSImage.KEYBOARD_IMAGE_FILE_NAME)
		
		//menu bar
		
		statusItem.menu = statusMenu
		
		if let button = statusItem.button {
			button.title = "SlimHUD"
            button.image = NSImage(named: NSImage.STATUS_ICON_IMAGE_FILE_NAME)
			button.image?.isTemplate = true
		}
		
		
        oldVolume = VolumeManager.getOutputVolume()
        oldBrightness = DisplayManager.getDisplayBrightness()
		
		
		
		//Setting up huds
		volumeHud.view = volumeView
		brightnessHud.view = brightnessView
		keyboardHud.view = keyboardView
		
		
		
		enabledBars = settingsManager.enabledBars
		marginValue = Float(settingsManager.marginValue)/100.0
		shouldUseAnimation = settingsManager.shouldUseAnimation
		

		for image in [volumeView.image, brightnessView.image, keyboardView.image] as [NSImageView?] {
			image?.wantsLayer = true
			image?.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		}
		
		setHeight(height: CGFloat(settingsManager.barHeight))
		setThickness(thickness: CGFloat(settingsManager.barThickness))
		
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
            self.positionManager.setupHUDsPosition(false)
		}
		
	}
	
	
	
	// MARK: - Settings & setups
	var shouldUseAnimation = true {
		didSet {
			volumeHud.animated = shouldUseAnimation
			brightnessHud.animated = shouldUseAnimation
			keyboardHud.animated = shouldUseAnimation
			
			volumeView.bar?.setupAnimation(animated: shouldUseAnimation)
			brightnessView.bar?.setupAnimation(animated: shouldUseAnimation)
			keyboardView.bar?.setupAnimation(animated: shouldUseAnimation)
		}
	}
	
	func updateShadows(enabled: Bool) {
        volumeView.setupShadow(enabled, settingsManager.shadowRadius)
        keyboardView.setupShadow(enabled, settingsManager.shadowRadius)
        brightnessView.setupShadow(enabled, settingsManager.shadowRadius)
	}
	
	func updateIcons(isHidden: Bool) {
		volumeView.image?.isHidden = isHidden
		brightnessView.image?.isHidden = isHidden
		keyboardView.image?.isHidden = isHidden
	}
	
	func setupDefaultBarsColors() {
		enabledColor = SettingsManager.blue
		disabledColor = SettingsManager.gray
		keyboardView.bar?.foreground = SettingsManager.azure
		brightnessView.bar?.foreground = SettingsManager.yellow
		volumeView.bar?.background = SettingsManager.darkGray
		keyboardView.bar?.background = SettingsManager.darkGray
		brightnessView.bar?.background = SettingsManager.darkGray
	}
	
	@available(OSX 10.14, *)
	func setupDefaultIconsColors() {
		setVolumeIconsTint(.white)
		setBrightnessIconsTint(.white)
		setKeyboardIconsTint(.white)
	}
	
	func setBackgroundColor(color: NSColor) {
		volumeView.bar?.background = color
		keyboardView.bar?.background = color
		brightnessView.bar?.background = color
	}
	func setVolumeEnabledColor(color: NSColor) {
		enabledColor = color
	}
	func setVolumeDisabledColor(color: NSColor) {
		disabledColor = color
	}
	func setBrightnessColor(color: NSColor) {
		brightnessView.bar?.foreground = color
	}
	func setKeyboardColor(color: NSColor) {
		keyboardView.bar?.foreground = color
	}
	
	func updateAll() {
		updateIcons(isHidden: !settingsManager.shouldShowIcons)
		updateShadows(enabled: settingsManager.shouldShowShadows)
		setBackgroundColor(color: settingsManager.backgroundColor)
		setVolumeEnabledColor(color: settingsManager.volumeEnabledColor)
		setVolumeDisabledColor(color: settingsManager.volumeDisabledColor)
		setBrightnessColor(color: settingsManager.brightnessColor)
		setKeyboardColor(color: settingsManager.keyboardColor)
		if #available(OSX 10.14, *) {
			setVolumeIconsTint(settingsManager.volumeIconColor)
			setBrightnessIconsTint(settingsManager.brightnessIconColor)
			setKeyboardIconsTint(settingsManager.keyboardIconColor)
		}
	}
	
	func setupTimer(with t: TimeInterval) {
		let timer = Timer(timeInterval: t, target: self, selector: #selector(checkChanges), userInfo: nil, repeats: true)
		let mainLoop = RunLoop.main
		mainLoop.add(timer, forMode: .common)
	}
	
	
	
	
	func setHeight(height: CGFloat) {
		let viewSize = volumeView.frame
		for view in [volumeView, brightnessView, keyboardView] as [NSView?] {
			view?.setFrameSize(NSSize(width: viewSize.width, height: height+60))
		}
        positionManager.setupHUDsPosition(DisplayManager.isInFullscreenMode())
	}
	
	func setThickness(thickness: CGFloat) {
		let viewSize = volumeView.frame
		for view in [volumeView, brightnessView, keyboardView] as [NSView?] {
			view?.setFrameSize(NSSize(width: thickness+40, height: viewSize.height))
		}
		for bar in [volumeView.bar, brightnessView.bar, keyboardView.bar] as [ProgressBar?] {
			bar?.progressLayer.frame.size.width = thickness //setting up inner layer
			bar?.progressLayer.cornerRadius = thickness/2
			bar?.layer?.cornerRadius = thickness/2 //setting up outer layer
			bar?.frame.size.width = thickness
		}
        positionManager.setupHUDsPosition(DisplayManager.isInFullscreenMode())
	}
	
	
	
	
	@available(OSX 10.14, *)
	func setVolumeIconsTint(_ color: NSColor) {
		volumeView.image?.contentTintColor = color
	}
	@available(OSX 10.14, *)
	func setBrightnessIconsTint(_ color: NSColor) {
		brightnessView.image?.contentTintColor = color
	}
	@available(OSX 10.14, *)
	func setKeyboardIconsTint(_ color: NSColor) {
		keyboardView.image?.contentTintColor = color
	}	
	
	
	// MARK: - Displayers
	
	@objc func showVolumeHUD() {
        if(!enabledBars.volumeBar) {return}
        let disabled = VolumeManager.isMuted()
		setColor(for: volumeView.bar!, disabled)
		if(!settingsManager.shouldContinuouslyCheck) {
            volumeView.bar!.progress = VolumeManager.getOutputVolume()
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
        if(!enabledBars.brightnessBar) {return}
		brightnessHud.show()
		volumeHud.hide(animated: false)
		keyboardHud.hide(animated: false)
		brightnessHud.dismiss(delay: 1.5)
	}
	@objc func showKeyboardHUD() {
        if(!enabledBars.keyboardBar) {return}
		keyboardHud.show()
		volumeHud.hide(animated: false)
		brightnessHud.hide(animated: false)
		keyboardHud.dismiss(delay: 1.5)
	}
	
	// MARK: - Check functions
	
	
	@objc func checkChanges() {
        let newFullScreen = DisplayManager.isInFullscreenMode()
		
		if(newFullScreen != oldFullScreen) {
            positionManager.setupHUDsPosition(newFullScreen)
			oldFullScreen = newFullScreen
		}
		
        if(enabledBars.brightnessBar) {
			checkBrightnessChanges()
		}
        if(settingsManager.shouldContinuouslyCheck && enabledBars.volumeBar) {
			checkVolumeChanges()
		}
	}
	
	func isAlmost(n1: Float, n2: Float) -> Bool { //used to partially prevent the bars to display when no user input happened
		return (n1+marginValue >= n2 && n1-marginValue <= n2)
	}
    
	func checkVolumeChanges() {
        let newVolume = VolumeManager.getOutputVolume()
		volumeView.bar!.progress = newVolume
		if (!isAlmost(n1: oldVolume, n2: newVolume)) {
			NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
			oldVolume = newVolume
		}
		volumeView.bar!.progress = newVolume
	}
	
    
	func checkBrightnessChanges() {
		if(NSScreen.screens.count == 0) {return}
        let newBrightness = DisplayManager.getDisplayBrightness()
		if(!isAlmost(n1: oldBrightness, n2: newBrightness)) {
			NotificationCenter.default.post(name: ObserverApplication.brightnessChanged, object: self)
			oldBrightness = newBrightness
		}
		brightnessView.bar?.progress = newBrightness
	}
	
	// MARK: -
	
	func setColor(for bar: ProgressBar, _ disabled: Bool) {
		if(disabled) {
			bar.foreground = disabledColor
		} else {
			bar.foreground = enabledColor
		}
	}
	
	
}
