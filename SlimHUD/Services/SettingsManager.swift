//
//  SettingsController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 03/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa


class SettingsManager {
	// MARK: - Default colors
	static let darkGray = NSColor(red: 0.34, green: 0.4, blue: 0.46, alpha: 0.2) // todo move to Costants file
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
            UserDefaultsManager.setItem(backgroundColor, for: SettingsManager.BACKGROUND_COLOR_KEY)
		}
	}
	var volumeEnabledColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(volumeEnabledColor, for: SettingsManager.VOLUME_ENABLED_COLOR_KEY)
		}
	}
	var volumeDisabledColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(volumeDisabledColor, for: SettingsManager.VOLUME_DISABLED_COLOR_KEY)
		}
	}
	var brightnessColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(brightnessColor, for: SettingsManager.BRIGHTNESS_COLOR_KEY)
		}
	}
	var keyboardColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(keyboardColor, for: SettingsManager.KEYBOARD_COLOR_KEY)
		}
	}
	// MARK: - Icons colors
	var volumeIconColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(volumeIconColor, for: SettingsManager.VOLUME_ICON_COLOR_KEY)
		}
	}
	var brightnessIconColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(brightnessIconColor, for: SettingsManager.BRIGHTNESS_ICON_COLOR_KEY)
		}
	}
	var keyboardIconColor: NSColor! {
		didSet {
            UserDefaultsManager.setItem(keyboardIconColor, for: SettingsManager.KEYBOARD_ICON_COLOR_KEY)
		}
	}
	
	// MARK: - Effects colors
	var shouldShowShadows: Bool = true {
		didSet {
            UserDefaults.standard.set(shouldShowShadows, forKey: SettingsManager.SHOULD_SHOW_SHADOWS_KEY)
		}
	}
	var shouldShowIcons: Bool = true {
		didSet {
            UserDefaults.standard.set(shouldShowIcons, forKey: SettingsManager.SHOULD_SHOW_ICONS_KEY)
		}
	}
	var shouldContinuouslyCheck: Bool = true {
		didSet {
            UserDefaults.standard.set(shouldContinuouslyCheck, forKey: SettingsManager.SHOULD_CONTINUOUSLY_CHECK_KEY)
		}
	}
	var shouldUseAnimation: Bool = true {
		didSet {
            UserDefaults.standard.set(shouldUseAnimation, forKey: SettingsManager.SHOULD_USE_ANIMATION_KEY)
		}
	}
	
	var barHeight: Int = 218 {
		didSet {
            UserDefaults.standard.set(barHeight, forKey: SettingsManager.BAR_HEIGHT_KEY)
		}
	}
	var barThickness: Int = 7 {
		didSet {
            UserDefaults.standard.set(barThickness, forKey: SettingsManager.BAR_THICKNESS_KEY)
		}
	}
	var position: Position = Position.left {
		didSet {
            UserDefaults.standard.set(position.rawValue, forKey: SettingsManager.POSITION_KEY)
		}
	}
	
	// MARK: - General
    var enabledBars: EnabledBars {
		didSet {
            let enabledBarsRaw = [enabledBars.volumeBar,
                                  enabledBars.brightnessBar,
                                  enabledBars.keyboardBar]
            UserDefaults.standard.set(enabledBarsRaw, forKey: SettingsManager.ENABLED_BARS_KEY)
		}
	}
	
	var marginValue: Int = 10 {
		didSet {
            UserDefaults.standard.set(marginValue, forKey: SettingsManager.MARGIN_KEY)
		}
	}
    
    let shadowRadius: CGFloat = 20
	
	
	// MARK: - Class methods
    
    static private let singletonSettingsController = SettingsManager()
    public static func getInstance() -> SettingsManager {
        return singletonSettingsController
    }
    
	private init() {
        backgroundColor = UserDefaultsManager.getItem(for: SettingsManager.BACKGROUND_COLOR_KEY, defaultValue: SettingsManager.darkGray)
        volumeEnabledColor = UserDefaultsManager.getItem(for: SettingsManager.VOLUME_ENABLED_COLOR_KEY, defaultValue: SettingsManager.blue)
        volumeDisabledColor = UserDefaultsManager.getItem(for: SettingsManager.VOLUME_DISABLED_COLOR_KEY, defaultValue: SettingsManager.gray)
        brightnessColor = UserDefaultsManager.getItem(for:SettingsManager.BRIGHTNESS_COLOR_KEY, defaultValue: SettingsManager.yellow)
        keyboardColor = UserDefaultsManager.getItem(for: SettingsManager.KEYBOARD_COLOR_KEY, defaultValue: SettingsManager.azure)
		
        volumeIconColor = UserDefaultsManager.getItem(for: SettingsManager.VOLUME_ICON_COLOR_KEY, defaultValue: .white)
        brightnessIconColor = UserDefaultsManager.getItem(for: SettingsManager.BRIGHTNESS_COLOR_KEY, defaultValue: .white)
        keyboardIconColor = UserDefaultsManager.getItem(for: SettingsManager.KEYBOARD_ICON_COLOR_KEY, defaultValue: .white)
		
        shouldShowShadows = UserDefaultsManager.getBool(for: SettingsManager.SHOULD_SHOW_SHADOWS_KEY)
        shouldShowIcons = UserDefaultsManager.getBool(for: SettingsManager.SHOULD_SHOW_ICONS_KEY)
        barHeight = UserDefaultsManager.getInt(for: SettingsManager.BAR_HEIGHT_KEY)
        barThickness = UserDefaultsManager.getInt(for: SettingsManager.BAR_THICKNESS_KEY)
        if let rawPosition = UserDefaultsManager.getString(for: SettingsManager.POSITION_KEY) {
            position = Position(rawValue: rawPosition) ?? .left
        } else {
            position = .left
        }
        shouldContinuouslyCheck = UserDefaultsManager.getBool(for: SettingsManager.SHOULD_CONTINUOUSLY_CHECK_KEY)
        shouldUseAnimation = UserDefaultsManager.getBool(for: SettingsManager.SHOULD_USE_ANIMATION_KEY)
        let enabledBarsRaw = UserDefaultsManager.getArr(for: SettingsManager.ENABLED_BARS_KEY, defaultValue:  [true, true, true])
        let (volumeBarEnabled, brightnessBarEnabled, keyboardBarEnabled) =
            (enabledBarsRaw[EnabledBars.VOLUME_BAR_INDEX],
             enabledBarsRaw[EnabledBars.BRIGHTNESS_BAR_INDEX],
             enabledBarsRaw[EnabledBars.KEYBOARD_BAR_INDEX])
		enabledBars = EnabledBars(volumeBar: volumeBarEnabled, brightnessBar: brightnessBarEnabled, keyboardBar: keyboardBarEnabled)
        marginValue = UserDefaultsManager.getInt(for: SettingsManager.MARGIN_KEY)
	}
	
	func resetDefaultBarsColors() {
		backgroundColor = SettingsManager.darkGray
		volumeEnabledColor = SettingsManager.blue
		volumeDisabledColor = SettingsManager.gray
		brightnessColor = SettingsManager.yellow
		keyboardColor = SettingsManager.azure
	}
	
	func resetDefaultIconsColors() {
		volumeIconColor = .white
		brightnessIconColor = .white
		keyboardIconColor = .white
	}	
	
    func saveAllItems() {
        UserDefaultsManager.setItem(backgroundColor, for: SettingsManager.BACKGROUND_COLOR_KEY)
        UserDefaultsManager.setItem(volumeEnabledColor, for: SettingsManager.VOLUME_ENABLED_COLOR_KEY)
        UserDefaultsManager.setItem(volumeDisabledColor, for: SettingsManager.VOLUME_DISABLED_COLOR_KEY)
        UserDefaultsManager.setItem(brightnessColor, for: SettingsManager.BRIGHTNESS_COLOR_KEY)
        UserDefaultsManager.setItem(keyboardColor, for:SettingsManager.KEYBOARD_COLOR_KEY)
		
        UserDefaultsManager.setItem(volumeIconColor, for: SettingsManager.VOLUME_ICON_COLOR_KEY)
        UserDefaultsManager.setItem(brightnessIconColor, for: SettingsManager.BRIGHTNESS_ICON_COLOR_KEY)
        UserDefaultsManager.setItem(keyboardIconColor, for: SettingsManager.KEYBOARD_ICON_COLOR_KEY)
		
		
        UserDefaults.standard.set(barHeight, forKey: SettingsManager.BAR_HEIGHT_KEY)
        UserDefaults.standard.set(barThickness, forKey: SettingsManager.BAR_THICKNESS_KEY)
        UserDefaults.standard.set(shouldShowIcons, forKey: SettingsManager.SHOULD_SHOW_ICONS_KEY)
        UserDefaults.standard.set(shouldShowShadows, forKey: SettingsManager.SHOULD_SHOW_SHADOWS_KEY)
		
        UserDefaults.standard.set(marginValue, forKey: SettingsManager.MARGIN_KEY)
        UserDefaults.standard.set(enabledBars, forKey: SettingsManager.ENABLED_BARS_KEY)
        UserDefaults.standard.set(position.rawValue, forKey: SettingsManager.POSITION_KEY)
        UserDefaults.standard.set(shouldUseAnimation, forKey: SettingsManager.SHOULD_USE_ANIMATION_KEY)
        UserDefaults.standard.set(shouldContinuouslyCheck, forKey: SettingsManager.SHOULD_CONTINUOUSLY_CHECK_KEY)
    }
	
	
	deinit {
		saveAllItems()
	}
	
}
