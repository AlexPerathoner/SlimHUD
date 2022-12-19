//
//  SettingsWindowControllerDelegate.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 17/08/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

protocol SettingsWindowControllerDelegate: class {
	func updateShadows(enabled: Bool)
	func updateIcons(isHidden: Bool)
	func setupDefaultBarsColors()
	func setBackgroundColor(color: NSColor)
	func setVolumeEnabledColor(color: NSColor)
	func setVolumeDisabledColor(color: NSColor)
	func setBrightnessColor(color: NSColor)
	func setKeyboardColor(color: NSColor)
	func setHeight(height: CGFloat)
	func setThickness(thickness: CGFloat)
	var shouldUseAnimation: Bool { get set }
	var enabledBars: EnabledBars { get set }
	var marginValue: Float { get set }
	@available(OSX 10.14, *)
	func setVolumeIconsTint(_ color: NSColor)
	@available(OSX 10.14, *)
	func setBrightnessIconsTint(_ color: NSColor)
	@available(OSX 10.14, *)
	func setKeyboardIconsTint(_ color: NSColor)
	@available(OSX 10.14, *)
	func setupDefaultIconsColors()
	var settingsController: SettingsController? { get set }
}
