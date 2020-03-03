//
//  SettingsController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 03/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class SettingsController {
	let darkGray = NSColor(red: 0.34, green: 0.4, blue: 0.46, alpha: 1.0)
	let gray = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
	let blue = NSColor(red: 0.19, green: 0.5, blue: 0.96, alpha: 0.9)
	let yellow = NSColor(red: 0.77, green: 0.7, blue: 0.3, alpha: 0.9)
	let azure = NSColor(red: 0.62, green: 0.8, blue: 0.91, alpha: 0.9)
	
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
			print("color changed to \(brightnessColor)")
			setItem(brightnessColor, for: "brightnessColor")
		}
	}
	var keyboardColor: NSColor!  {
		didSet {
			setItem(keyboardColor, for: "keyboardColor")
		}
	}
	
	var shouldShowShadows: Bool! = true {
		didSet {
			setItem(shouldShowShadows, for: "shouldShowShadows")
		}
	}
	var shouldShowIcons: Bool! = true {
		didSet {
			setItem(shouldShowIcons, for: "shouldShowIcons")
		}
	}
	
	init() {
		backgroundColor = getItem(for: "backgroundColor", defaultValue: darkGray)
		volumeEnabledColor = getItem(for: "volumeEnabledColor", defaultValue: blue)
		volumeDisabledColor = getItem(for: "volumeDisabledColor", defaultValue: gray)
		brightnessColor = getItem(for: "brightnessColor", defaultValue: yellow)
		keyboardColor = getItem(for: "keyboardColor", defaultValue: azure)
		shouldShowShadows = getItem(for: "shouldShowShadows", defaultValue: true)
		shouldShowIcons = getItem(for: "shouldShowIcons", defaultValue: true)
    }
	
	func getItem<T>(for key: String, defaultValue: T) -> T {
        guard
            let data = UserDefaults.standard.object(forKey: key) as? Data,
			let item = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else {
                return defaultValue
        }
		return item
	}
	
	func setItem<T>(_ item: T, for key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: item)
        UserDefaults.standard.set(data, forKey: key)
	}
	
    private func saveAllItems() {
		setItem(backgroundColor, for: "backgroundColor")
		setItem(volumeEnabledColor, for: "volumeEnabledColor")
		setItem(volumeDisabledColor, for: "volumeDisabledColor")
		setItem(brightnessColor, for: "brightnessColor")
		setItem(keyboardColor, for: "keyboardColor")
		setItem(shouldShowShadows, for: "shouldShowShadows")
		setItem(shouldShowIcons, for: "shouldShowIcons")
    }
	
}
