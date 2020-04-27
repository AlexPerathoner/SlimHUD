//
//  SettingsPreview.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 28/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class SettingsPreview: NSView, SettingsWindowControllerDelegate {
	var settingsController: SettingsController?
	
	
	var volumeHud = Hud()
	var brightnessHud = Hud()
	var keyboardHud = Hud()
	
	@IBOutlet weak var volumeView: NSView!
	@IBOutlet weak var brightnessView: NSView!
	@IBOutlet weak var keyboardView: NSView!
	
	@IBOutlet weak var volumeBar: ProgressBar!
	@IBOutlet weak var brightnessBar: ProgressBar!
	@IBOutlet weak var keyboardBar: ProgressBar!
	
	@IBOutlet weak var volumeImage: NSImageView!
	@IBOutlet weak var brightnessImage: NSImageView!
	@IBOutlet weak var keyboardImage: NSImageView!
	
	
	
	func setup() {
		volumeHud.view = volumeView
		brightnessHud.view = brightnessView
		keyboardHud.view = keyboardView
		updateAll()
	}
	
	func updateShadows(enabled: Bool) {
		volumeView.setupShadow(enabled, 20)
		brightnessView.setupShadow(enabled, 20)
		keyboardView.setupShadow(enabled, 20)
	}
	
	func updateIcons(isHidden: Bool) {
		volumeImage.isHidden = isHidden
		brightnessImage.isHidden = isHidden
		keyboardImage.isHidden = isHidden
	}
	
	func setupDefaultColors() {
		volumeBar.foreground = SettingsController.blue
		brightnessBar.foreground = SettingsController.yellow
		keyboardBar.foreground = SettingsController.azure
		setBackgroundColor(color: SettingsController.darkGray)
		setVolumeIconsTint(.white)
		setBrightnessIconsTint(.white)
		setKeyboardIconsTint(.white)
	}
	
	func setBackgroundColor(color: NSColor) {
		volumeBar.background = color
		brightnessBar.background = color
		keyboardBar.background = color
	}
	
	func setVolumeEnabledColor(color: NSColor) {
		volumeBar.foreground = color
		volumeImage.image = NSImage(named: "volume")
	}
	
	func setVolumeDisabledColor(color: NSColor) {
		volumeBar.foreground = color
		volumeImage.image = NSImage(named: "noVolume")
	}
	
	func setBrightnessColor(color: NSColor) {
		brightnessBar.foreground = color
	}
	
	func setKeyboardColor(color: NSColor) {
		keyboardBar.foreground = color
	}
	
	
	// isn't showed in preview
	func setHeight(height: CGFloat) {}
	func setThickness(thickness: CGFloat) {}
	func setupHUDsPosition(_ isFullscreen: Bool) {}
	
	var shouldUseAnimation: Bool = true {
		didSet {
			volumeHud.animated = shouldUseAnimation
			brightnessHud.animated = shouldUseAnimation
			keyboardHud.animated = shouldUseAnimation
			volumeBar.setupAnimation(animated: shouldUseAnimation)
			brightnessBar.setupAnimation(animated: shouldUseAnimation)
			keyboardBar.setupAnimation(animated: shouldUseAnimation)
			showAnimation()
		}
	}
	
	var enabledBars: [Bool] = [true, true, true] {
		didSet {
			volumeView.isHidden = !enabledBars[0]
			brightnessView.isHidden = !enabledBars[1]
			keyboardView.isHidden = !enabledBars[2]
		}
	}
	
	
	func setVolumeIconsTint(_ color: NSColor) {
		if #available(OSX 10.14, *) {
			volumeImage.contentTintColor = color
		} else {
			NSLog("Can't change icons' tint - MacOS 10.14+ needed")
		}
	}
	func setBrightnessIconsTint(_ color: NSColor) {
		if #available(OSX 10.14, *) {
			brightnessImage.contentTintColor = color
		} else {
			NSLog("Can't change icons' tint - MacOS 10.14+ needed")
		}
	}
	func setKeyboardIconsTint(_ color: NSColor) {
		if #available(OSX 10.14, *) {
			keyboardImage.contentTintColor = color
		} else {
			NSLog("Can't change icons' tint - MacOS 10.14+ needed")
		}
	}
	
	
	
	var marginValue: Float = 0.0
	
	func updateAll() {
		enabledBars = settingsController?.enabledBars ?? [true, true, true]
		updateIcons(isHidden: !(settingsController?.shouldShowIcons ?? false))
		updateShadows(enabled: settingsController?.shouldShowShadows ?? true)
		setBackgroundColor(color: settingsController?.backgroundColor ?? SettingsController.darkGray)
		setVolumeDisabledColor(color: settingsController?.volumeDisabledColor ?? SettingsController.gray)
		setVolumeEnabledColor(color: settingsController?.volumeEnabledColor ?? SettingsController.blue)
		setBrightnessColor(color: settingsController?.brightnessColor ?? SettingsController.yellow)
		setKeyboardColor(color: settingsController?.keyboardColor ?? SettingsController.azure)
		shouldUseAnimation = settingsController?.shouldUseAnimation ?? true
		setVolumeIconsTint(settingsController?.volumeIconColor ?? NSColor.white)
		setBrightnessIconsTint(settingsController?.brightnessIconColor ?? NSColor.white)
		setKeyboardIconsTint(settingsController?.keyboardIconColor ?? NSColor.white)
	}
	
	
	
	
	var value: CGFloat = 0.5
	var timerChangeValue: Timer?
	func showAnimation() {
		if(timerChangeValue != nil) {
			timerChangeValue?.invalidate()
		}
		timerChangeValue = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { (t) in
			let val = (self.value).truncatingRemainder(dividingBy: 1.0)
			self.volumeBar.progress = val
			self.brightnessBar.progress = val
			self.keyboardBar.progress = val
			self.value += 0.1
		}
		
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
			self.timerChangeValue?.invalidate()
			self.timerChangeValue = nil
		}
	}
	
	
	
}

