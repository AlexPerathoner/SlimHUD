//
//  SettingsPreview.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 28/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class SettingsPreview: NSView, SettingsWindowControllerDelegate {
	
	
	
	var volumeHud = Hud()
	var brightnessHud = Hud()
	var backlightHud = Hud()
	
	@IBOutlet weak var volumeView: NSView!
	@IBOutlet weak var brightnessView: NSView!
	@IBOutlet weak var backlightView: NSView!
	
	@IBOutlet weak var volumeBar: ProgressBar!
	@IBOutlet weak var brightnessBar: ProgressBar!
	@IBOutlet weak var backlightBar: ProgressBar!
	
	@IBOutlet weak var volumeImage: NSImageView!
	@IBOutlet weak var brightnessImage: NSImageView!
	@IBOutlet weak var keyboardImage: NSImageView!
	
	
	public weak var settingsController: SettingsController?
	
	func setup() {
		volumeHud.view = volumeView
		brightnessHud.view = brightnessView
		backlightHud.view = backlightView
		
		updateAll()
	}
	
	
	func updateShadows(enabled: Bool) {
		
	}
	func updateIcons(isHidden: Bool) {
		
	}
	func setupDefaultColors() {
		
	}
	func setBackgroundColor(color: NSColor) {
		
	}
	func setVolumeEnabledColor(color: NSColor) {
		
	}
	func setVolumeDisabledColor(color: NSColor) {
		
	}
	func setBrightnessColor(color: NSColor) {
		
	}
	func setBacklightColor(color: NSColor) {
		
	}
	func setHeight(height: CGFloat) {
		
	}
	func setupHUDsPosition(_ isFullscreen: Bool) {
		
	}
	var shouldUseAnimation: Bool = true
	
	var enabledBars: [Bool] = [true, true, true] {
		didSet {
			volumeView.isHidden = !enabledBars[0]
			brightnessView.isHidden = !enabledBars[1]
			backlightView.isHidden = !enabledBars[2]
		}
	}
	
	var marginValue: Float = 0.0
	
	
	func updateAll() {
		updateIcons(isHidden: !(settingsController?.shouldShowIcons ?? true))
		updateShadows(enabled: settingsController?.shouldShowShadows ?? true)
		/*setBackgroundColor(color: settingsController?.backgroundColor ?? true)
		setVolumeEnabledColor(color: settingsController?.volumeEnabledColor ?? true)
		setVolumeDisabledColor(color: settingsController?.volumeDisabledColor ?? true)
		setBrightnessColor(color: settingsController?.brightnessColor ?? true)
		setBacklightColor(color: settingsController?.keyboardColor ?? true)*/
	}
}

