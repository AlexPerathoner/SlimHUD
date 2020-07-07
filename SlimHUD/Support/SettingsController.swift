//
//  SettingsController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 03/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa


enum Position: String {
	case left = "left"
	case right = "right"
	case bottom = "bottom"
	case top = "top"
}


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
			setItem(backgroundColor, for: "backgroundColor")
		}
	}
	var volumeEnabledColor: NSColor! {
		didSet {
			setItem(volumeEnabledColor, for: "volumeEnabledColor")
		}
	}
	var volumeDisabledColor: NSColor! {
		didSet {
			setItem(volumeDisabledColor, for: "volumeDisabledColor")
		}
	}
	var brightnessColor: NSColor! {
		didSet {
			setItem(brightnessColor, for: "brightnessColor")
		}
	}
	var keyboardColor: NSColor! {
		didSet {
			setItem(keyboardColor, for: "keyboardColor")
		}
	}
	// MARK: - Icons colors
	var volumeIconColor: NSColor! {
		didSet {
			setItem(volumeIconColor, for: "volumeIconColor")
		}
	}
	var brightnessIconColor: NSColor! {
		didSet {
			setItem(brightnessIconColor, for: "brightnessIconColor")
		}
	}
	var keyboardIconColor: NSColor! {
		didSet {
			setItem(keyboardIconColor, for: "keyboardIconColor")
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
	var enabledBars: [Bool] = [true, true, true] {
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
		backgroundColor = getItem(for: "backgroundColor", defaultValue: SettingsController.darkGray)
		volumeEnabledColor = getItem(for: "volumeEnabledColor", defaultValue: SettingsController.blue)
		volumeDisabledColor = getItem(for: "volumeDisabledColor", defaultValue: SettingsController.gray)
		brightnessColor = getItem(for: "brightnessColor", defaultValue: SettingsController.yellow)
		keyboardColor = getItem(for: "keyboardColor", defaultValue: SettingsController.azure)
		
		volumeIconColor = getItem(for: "volumeIconColor", defaultValue: .white)
		brightnessIconColor = getItem(for: "brightnessIconColor", defaultValue: .white)
		keyboardIconColor = getItem(for: "keyboardIconColor", defaultValue: .white)
		
		shouldShowShadows = getBool(for: "shouldShowShadows")
		shouldShowIcons = getBool(for: "shouldShowIcons")
		barHeight = getInt(for: "barHeight")
		barThickness = getInt(for: "barThickness")
		position = Position(rawValue: getString(for: "position", defaultValue: "left"))!
		shouldContinuouslyCheck = getBool(for: "shouldContinuouslyCheck")
		shouldUseAnimation = getBool(for: "shouldUseAnimation")
		enabledBars = getArr(for: "enabledBars", defaultValue:  [true, true, true])
		marginValue = getInt(for: "marginValue")
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
	
	
	func getItem<T>(for key: String, defaultValue: T) -> T where T: NSCoding, T: NSObject {
		do {
			guard let data = UserDefaults.standard.object(forKey: key) as? Data,
				let item = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! T? else {
					return defaultValue
			}
			return item
		} catch {
			NSLog("unarchiveTopLevelObjectWithData() failed!")
			return defaultValue
		}
	}
	func getBool(for key: String) -> Bool {
		return UserDefaults.standard.bool(forKey: key)
	}
	func getArr<T>(for key: String, defaultValue: [T]) -> [T] {
		return UserDefaults.standard.array(forKey: key) as! [T]? ?? defaultValue
	}
	func getString(for key: String, defaultValue: String) -> String {
		return UserDefaults.standard.string(forKey: key) ?? defaultValue
	}
	func getInt(for key: String) -> Int {
		return UserDefaults.standard.integer(forKey: key)
	}
	
	func setItem<T>(_ item: T, for key: String) {
		do {
			UserDefaults.standard.set(try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false), forKey: key)
		} catch {
			NSLog("Failed to archive data!")
		}
	}
	
	
    func saveAllItems() {
		setItem(backgroundColor, for: "backgroundColor")
		setItem(volumeEnabledColor, for: "volumeEnabledColor")
		setItem(volumeDisabledColor, for: "volumeDisabledColor")
		setItem(brightnessColor, for: "brightnessColor")
		setItem(keyboardColor, for: "keyboardColor")
		
		setItem(volumeIconColor, for: "volumeIconColor")
		setItem(brightnessIconColor, for: "brightnessIconColor")
		setItem(keyboardIconColor, for: "keyboardIconColor")
		
		
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
