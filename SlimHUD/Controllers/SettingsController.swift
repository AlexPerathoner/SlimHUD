//
//  SettingsController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 03/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa


class SettingsController {
	// MARK: - Default colors
	static let darkGray = NSColor(red: 0.34, green: 0.4, blue: 0.46, alpha: 0.2)
	static let gray = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
	static let blue = NSColor(red: 0.19, green: 0.5, blue: 0.96, alpha: 0.9)
	static let yellow = NSColor(red: 0.77, green: 0.7, blue: 0.3, alpha: 1)
	static let azure = NSColor(red: 0.62, green: 0.8, blue: 0.91, alpha: 0.9)
	
	 // MARK: - Bars colors
	var backgroundColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(backgroundColor, for: "backgroundColor")
		}
	}
	var volumeEnabledColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(volumeEnabledColor, for: "volumeEnabledColor")
		}
	}
	var volumeDisabledColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(volumeDisabledColor, for: "volumeDisabledColor")
		}
	}
	var brightnessColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(brightnessColor, for: "brightnessColor")
		}
	}
	var keyboardColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(keyboardColor, for: "keyboardColor")
		}
	}
	// MARK: - Icons colors
	var volumeIconColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(volumeIconColor, for: "volumeIconColor")
		}
	}
	var brightnessIconColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(brightnessIconColor, for: "brightnessIconColor")
		}
	}
	var keyboardIconColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(keyboardIconColor, for: "keyboardIconColor")
		}
	}
	
	// MARK: - Effects colors
	var shouldShowShadows: Bool! = true {
		didSet {
			UserDefaults.standard.set(shouldShowShadows, forKey: "shouldShowShadows")
		}
	}
	var shouldShowIcons: Bool! = true {
		didSet {
			UserDefaults.standard.set(shouldShowIcons, forKey: "shouldShowIcons")
		}
	}
	var shouldContinuouslyCheck: Bool! = true {
		didSet {
			UserDefaults.standard.set(shouldContinuouslyCheck, forKey: "shouldContinuouslyCheck")
		}
	}
	var shouldUseAnimation: Bool! = true {
		didSet {
			UserDefaults.standard.set(shouldUseAnimation, forKey: "shouldUseAnimation")
		}
	}
	
	var barHeight: Int = 218 {
		didSet {
			UserDefaults.standard.set(barHeight, forKey: "barHeight")
		}
	}
	var barThickness: Int = 7 {
		didSet {
			UserDefaults.standard.set(barThickness, forKey: "barThickness")
		}
	}
	var position: Position = Position.left {
		didSet {
			UserDefaults.standard.set(position.rawValue, forKey: "position")
		}
	}
	
	// MARK: - General
    var enabledBars: EnabledBars {
		didSet {
			UserDefaults.standard.set(enabledBars, forKey: "enabledBars")
		}
	}
	
	var marginValue: Int = 10 {
		didSet {
			UserDefaults.standard.set(marginValue, forKey: "marginValue")
		}
	}
	
	
	// MARK: - Class methods
	init() {
        backgroundColor = UserDefaultsManager.getItem(for: "backgroundColor", defaultValue: SettingsController.darkGray)
        volumeEnabledColor = UserDefaultsManager.getItem(for: "volumeEnabledColor", defaultValue: SettingsController.blue)
        volumeDisabledColor = UserDefaultsManager.getItem(for: "volumeDisabledColor", defaultValue: SettingsController.gray)
        brightnessColor = UserDefaultsManager.getItem(for: "brightnessColor", defaultValue: SettingsController.yellow)
        keyboardColor = UserDefaultsManager.getItem(for: "keyboardColor", defaultValue: SettingsController.azure)
		
        volumeIconColor = UserDefaultsManager.getItem(for: "volumeIconColor", defaultValue: .white)
        brightnessIconColor = UserDefaultsManager.getItem(for: "brightnessIconColor", defaultValue: .white)
        keyboardIconColor = UserDefaultsManager.getItem(for: "keyboardIconColor", defaultValue: .white)
		
        shouldShowShadows = UserDefaultsManager.getBool(for: "shouldShowShadows")
        shouldShowIcons = UserDefaultsManager.getBool(for: "shouldShowIcons")
        barHeight = UserDefaultsManager.getInt(for: "barHeight")
        barThickness = UserDefaultsManager.getInt(for: "barThickness")
        position = Position(rawValue: UserDefaultsManager.getString(for: "position", defaultValue: "left"))!
        shouldContinuouslyCheck = UserDefaultsManager.getBool(for: "shouldContinuouslyCheck")
        shouldUseAnimation = UserDefaultsManager.getBool(for: "shouldUseAnimation")
        let enabledBarsRaw = UserDefaultsManager.getArr(for: "enabledBars", defaultValue:  [true, true, true])
        let (volumeBarEnabled, brightnessBarEnabled, keyboardBarEnabled) =
            (enabledBarsRaw[EnabledBars.VOLUME_BAR_INDEX],
             enabledBarsRaw[EnabledBars.BRIGHTNESS_BAR_INDEX],
             enabledBarsRaw[EnabledBars.KEYBOARD_BAR_INDEX])
		enabledBars = EnabledBars(volumeBar: volumeBarEnabled, brightnessBar: brightnessBarEnabled, keyboardBar: keyboardBarEnabled)
        marginValue = UserDefaultsManager.getInt(for: "marginValue")
	}
	
	func resetDefaultBarsColors() {
		backgroundColor = SettingsController.darkGray
		volumeEnabledColor = SettingsController.blue
		volumeDisabledColor = SettingsController.gray
		brightnessColor = SettingsController.yellow
		keyboardColor = SettingsController.azure
	}
	
	func resetDefaultIconsColors() {
		volumeIconColor = .white
		brightnessIconColor = .white
		keyboardIconColor = .white
	}	
	
    func saveAllItems() {
        UserDefaultsManager.setItem(backgroundColor, for: "backgroundColor")
        UserDefaultsManager.setItem(volumeEnabledColor, for: "volumeEnabledColor")
        UserDefaultsManager.setItem(volumeDisabledColor, for: "volumeDisabledColor")
        UserDefaultsManager.setItem(brightnessColor, for: "brightnessColor")
        UserDefaultsManager.setItem(keyboardColor, for: "keyboardColor")
		
        UserDefaultsManager.setItem(volumeIconColor, for: "volumeIconColor")
        UserDefaultsManager.setItem(brightnessIconColor, for: "brightnessIconColor")
        UserDefaultsManager.setItem(keyboardIconColor, for: "keyboardIconColor")
		
		
		UserDefaults.standard.set(barHeight, forKey: "barHeight")
		UserDefaults.standard.set(barThickness, forKey: "barThickness")
		UserDefaults.standard.set(shouldShowIcons, forKey: "shouldShowIcons")
		UserDefaults.standard.set(shouldShowShadows, forKey: "shouldShowShadows")
		
		UserDefaults.standard.set(marginValue, forKey: "marginValue")
		UserDefaults.standard.set(enabledBars, forKey: "enabledBars")
		UserDefaults.standard.set(position.rawValue, forKey: "position")
		UserDefaults.standard.set(shouldUseAnimation, forKey: "shouldUseAnimation")
		UserDefaults.standard.set(shouldContinuouslyCheck, forKey: "shouldContinuouslyCheck")
    }
	
	
	deinit {
		saveAllItems()
	}
	
}
