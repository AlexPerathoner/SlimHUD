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
    
    // MARK: - Keys
    
    static let BACKGROUND_COLOR_KEY = "backgroundColor"
    static let VOLUME_ENABLED_COLOR_KEY = "volumeEnabledColor"
    static let VOLUME_DISABLED_COLOR_KEY = "volumeDisabledColor"
    static let BRIGHTNESS_COLOR_KEY = "brightnessColor"
    static let KEYBOARD_COLOR_KEY = "keyboardColor"
    static let VOLUME_ICON_COLOR_KEY = "volumeIconColor"
    static let BRIGHTNESS_ICON_COLOR_KEY = "brightnessIconColor"
    static let KEYBOARD_ICON_COLOR_KEY = "keyboardIconColor"
    static let SHOULD_SHOW_ICONS_KEY = "shouldShowIcons"
    static let SHOULD_SHOW_SHADOWS_KEY = "shouldShowShadows"
    static let SHOULD_CONTINUOUSLY_CHECK_KEY = "shouldContinuouslyCheck"
    static let SHOULD_USE_ANIMATION_KEY = "shouldUseAnimation"
    static let BAR_HEIGHT_KEY = "barHeight"
    static let BAR_THICKNESS_KEY = "barThickness"
    static let POSITION_KEY = "position"
    static let ENABLED_BARS_KEY = "enabledBars"
    static let MARGIN_KEY = "marginValue"
    
    
	
	 // MARK: - Bars colors
	var backgroundColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(backgroundColor, for: SettingsController.BACKGROUND_COLOR_KEY)
		}
	}
	var volumeEnabledColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(volumeEnabledColor, for: SettingsController.VOLUME_ENABLED_COLOR_KEY)
		}
	}
	var volumeDisabledColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(volumeDisabledColor, for: SettingsController.VOLUME_DISABLED_COLOR_KEY)
		}
	}
	var brightnessColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(brightnessColor, for: SettingsController.BRIGHTNESS_COLOR_KEY)
		}
	}
	var keyboardColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(keyboardColor, for: SettingsController.KEYBOARD_COLOR_KEY)
		}
	}
	// MARK: - Icons colors
	var volumeIconColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(volumeIconColor, for: SettingsController.VOLUME_ICON_COLOR_KEY)
		}
	}
	var brightnessIconColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(brightnessIconColor, for: SettingsController.BRIGHTNESS_ICON_COLOR_KEY)
		}
	}
	var keyboardIconColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(keyboardIconColor, for: SettingsController.KEYBOARD_ICON_COLOR_KEY)
		}
	}
	
	// MARK: - Effects colors
	var shouldShowShadows: Bool! = true {
		didSet {
            UserDefaults.standard.set(shouldShowShadows, forKey: SettingsController.SHOULD_SHOW_SHADOWS_KEY)
		}
	}
	var shouldShowIcons: Bool! = true {
		didSet {
            UserDefaults.standard.set(shouldShowIcons, forKey: SettingsController.SHOULD_SHOW_ICONS_KEY)
		}
	}
	var shouldContinuouslyCheck: Bool! = true {
		didSet {
            UserDefaults.standard.set(shouldContinuouslyCheck, forKey: SettingsController.SHOULD_CONTINUOUSLY_CHECK_KEY)
		}
	}
	var shouldUseAnimation: Bool! = true {
		didSet {
            UserDefaults.standard.set(shouldUseAnimation, forKey: SettingsController.SHOULD_USE_ANIMATION_KEY)
		}
	}
	
	var barHeight: Int = 218 {
		didSet {
            UserDefaults.standard.set(barHeight, forKey: SettingsController.BAR_HEIGHT_KEY)
		}
	}
	var barThickness: Int = 7 {
		didSet {
            UserDefaults.standard.set(barThickness, forKey: SettingsController.BAR_THICKNESS_KEY)
		}
	}
	var position: Position = Position.left {
		didSet {
            UserDefaults.standard.set(position.rawValue, forKey: SettingsController.POSITION_KEY)
		}
	}
	
	// MARK: - General
    var enabledBars: EnabledBars {
		didSet {
            let enabledBarsRaw = [enabledBars.volumeBar,
                                  enabledBars.brightnessBar,
                                  enabledBars.keyboardBar]
            UserDefaults.standard.set(enabledBarsRaw, forKey: SettingsController.ENABLED_BARS_KEY)
		}
	}
	
	var marginValue: Int = 10 {
		didSet {
            UserDefaults.standard.set(marginValue, forKey: SettingsController.MARGIN_KEY)
		}
	}
    
    let shadowRadius: CGFloat = 20
	
	
	// MARK: - Class methods
    
    static private let singletonSettingsController = SettingsController()
    public static func getInstance() -> SettingsController {
        return singletonSettingsController
    }
    
	private init() {
        backgroundColor = UserDefaultsManager.getItem(for: SettingsController.BACKGROUND_COLOR_KEY, defaultValue: SettingsController.darkGray)
        volumeEnabledColor = UserDefaultsManager.getItem(for: SettingsController.VOLUME_ENABLED_COLOR_KEY, defaultValue: SettingsController.blue)
        volumeDisabledColor = UserDefaultsManager.getItem(for: SettingsController.VOLUME_DISABLED_COLOR_KEY, defaultValue: SettingsController.gray)
        brightnessColor = UserDefaultsManager.getItem(for:SettingsController.BRIGHTNESS_COLOR_KEY, defaultValue: SettingsController.yellow)
        keyboardColor = UserDefaultsManager.getItem(for: SettingsController.KEYBOARD_COLOR_KEY, defaultValue: SettingsController.azure)
		
        volumeIconColor = UserDefaultsManager.getItem(for: SettingsController.VOLUME_ICON_COLOR_KEY, defaultValue: .white)
        brightnessIconColor = UserDefaultsManager.getItem(for: SettingsController.BRIGHTNESS_COLOR_KEY, defaultValue: .white)
        keyboardIconColor = UserDefaultsManager.getItem(for: SettingsController.KEYBOARD_ICON_COLOR_KEY, defaultValue: .white)
		
        shouldShowShadows = UserDefaultsManager.getBool(for: SettingsController.SHOULD_SHOW_SHADOWS_KEY)
        shouldShowIcons = UserDefaultsManager.getBool(for: SettingsController.SHOULD_SHOW_ICONS_KEY)
        barHeight = UserDefaultsManager.getInt(for: SettingsController.BAR_HEIGHT_KEY)
        barThickness = UserDefaultsManager.getInt(for: SettingsController.BAR_THICKNESS_KEY)
        if let rawPosition = UserDefaultsManager.getString(for: SettingsController.POSITION_KEY) {
            position = Position(rawValue: rawPosition) ?? .left
        } else {
            position = .left
        }
        shouldContinuouslyCheck = UserDefaultsManager.getBool(for: SettingsController.SHOULD_CONTINUOUSLY_CHECK_KEY)
        shouldUseAnimation = UserDefaultsManager.getBool(for: SettingsController.SHOULD_USE_ANIMATION_KEY)
        let enabledBarsRaw = UserDefaultsManager.getArr(for: SettingsController.ENABLED_BARS_KEY, defaultValue:  [true, true, true])
        let (volumeBarEnabled, brightnessBarEnabled, keyboardBarEnabled) =
            (enabledBarsRaw[EnabledBars.VOLUME_BAR_INDEX],
             enabledBarsRaw[EnabledBars.BRIGHTNESS_BAR_INDEX],
             enabledBarsRaw[EnabledBars.KEYBOARD_BAR_INDEX])
		enabledBars = EnabledBars(volumeBar: volumeBarEnabled, brightnessBar: brightnessBarEnabled, keyboardBar: keyboardBarEnabled)
        marginValue = UserDefaultsManager.getInt(for: SettingsController.MARGIN_KEY)
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
        UserDefaultsManager.setItem(backgroundColor, for: SettingsController.BACKGROUND_COLOR_KEY)
        UserDefaultsManager.setItem(volumeEnabledColor, for: SettingsController.VOLUME_ENABLED_COLOR_KEY)
        UserDefaultsManager.setItem(volumeDisabledColor, for: SettingsController.VOLUME_DISABLED_COLOR_KEY)
        UserDefaultsManager.setItem(brightnessColor, for: SettingsController.BRIGHTNESS_COLOR_KEY)
        UserDefaultsManager.setItem(keyboardColor, for:SettingsController.KEYBOARD_COLOR_KEY)
		
        UserDefaultsManager.setItem(volumeIconColor, for: SettingsController.VOLUME_ICON_COLOR_KEY)
        UserDefaultsManager.setItem(brightnessIconColor, for: SettingsController.BRIGHTNESS_ICON_COLOR_KEY)
        UserDefaultsManager.setItem(keyboardIconColor, for: SettingsController.KEYBOARD_ICON_COLOR_KEY)
		
		
        UserDefaults.standard.set(barHeight, forKey: SettingsController.BAR_HEIGHT_KEY)
        UserDefaults.standard.set(barThickness, forKey: SettingsController.BAR_THICKNESS_KEY)
        UserDefaults.standard.set(shouldShowIcons, forKey: SettingsController.SHOULD_SHOW_ICONS_KEY)
        UserDefaults.standard.set(shouldShowShadows, forKey: SettingsController.SHOULD_SHOW_SHADOWS_KEY)
		
        UserDefaults.standard.set(marginValue, forKey: SettingsController.MARGIN_KEY)
        UserDefaults.standard.set(enabledBars, forKey: SettingsController.ENABLED_BARS_KEY)
        UserDefaults.standard.set(position.rawValue, forKey: SettingsController.POSITION_KEY)
        UserDefaults.standard.set(shouldUseAnimation, forKey: SettingsController.SHOULD_USE_ANIMATION_KEY)
        UserDefaults.standard.set(shouldContinuouslyCheck, forKey: SettingsController.SHOULD_CONTINUOUSLY_CHECK_KEY)
    }
	
	
	deinit {
		saveAllItems()
	}
	
}
