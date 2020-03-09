//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 03/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import LaunchAtLogin

protocol SettingsWindowControllerDelegate: class {
	func updateShadows(enabled: Bool)
	func updateIcons(isHidden: Bool)
	func setupDefaultColors()
	func setBackgroundColor(color: NSColor)
	func setVolumeEnabledColor(color: NSColor)
	func setVolumeDisabledColor(color: NSColor)
	func setBrightnessColor(color: NSColor)
	func setBacklightColor(color: NSColor)
}
class SettingsWindowController: NSWindowController {
	
	weak var delegate: SettingsWindowControllerDelegate?
    weak var settingsController: SettingsController?
	
    override func windowDidLoad() {
		launchAtLoginOutlet.state = LaunchAtLogin.isEnabled.toStateValue()
		iconOutlet.state = settingsController?.shouldShowIcons!.toStateValue() ?? .on
		shadowOutlet.state = settingsController?.shouldShowShadows.toStateValue() ?? .on
		backgroundColorOutlet.color = settingsController!.backgroundColor
		volumeEnabledColorOutlet.color = settingsController!.volumeEnabledColor
		volumeDisabledColorOutlet.color = settingsController!.volumeDisabledColor
		brightnessColorOutlet.color = settingsController!.brightnessColor
		keyboardColorOutlet.color = settingsController!.keyboardColor
        super.windowDidLoad()
	}
	
	@IBOutlet weak var launchAtLoginOutlet: NSButton!
	
	@IBOutlet weak var iconOutlet: NSButton!
	@IBOutlet weak var shadowOutlet: NSButton!
	
	@IBOutlet weak var backgroundColorOutlet: NSColorWell!
	@IBOutlet weak var volumeEnabledColorOutlet: NSColorWell!
	@IBOutlet weak var volumeDisabledColorOutlet: NSColorWell!
	@IBOutlet weak var brightnessColorOutlet: NSColorWell!
	@IBOutlet weak var keyboardColorOutlet: NSColorWell!
		
	@IBAction func shouldShowIconsAction(_ sender: NSButton) {
		let val = sender.state.boolValue()
		settingsController?.shouldShowIcons = val
		delegate?.updateIcons(isHidden: !val)
	}
	
	@IBAction func shouldShowShadows(_ sender: NSButton) {
		let val = sender.state.boolValue()
		settingsController?.shouldShowShadows = val
		delegate?.updateShadows(enabled: val)
	}
	
	@IBAction func resetDefaults(_ sender: Any) {
		delegate?.setupDefaultColors()
		settingsController?.resetDefaultColors()
		volumeEnabledColorOutlet.color = settingsController!.blue
		volumeDisabledColorOutlet.color = settingsController!.gray
		keyboardColorOutlet.color = settingsController!.azure
		brightnessColorOutlet.color = settingsController!.yellow
		backgroundColorOutlet.color = settingsController!.darkGray
	}
	
	//changing values automatically also saves them into userdefaults
	@IBAction func backgroundColorChanged(_ sender: NSColorWell) {
		settingsController?.backgroundColor = sender.color
		delegate?.setBackgroundColor(color: sender.color)
	}
	@IBAction func volumeEnabledColorChanged(_ sender: NSColorWell) {
		settingsController?.volumeEnabledColor = sender.color
		delegate?.setVolumeEnabledColor(color: sender.color)
	}
	@IBAction func volumeDisabledColorChanged(_ sender: NSColorWell) {
		settingsController?.volumeDisabledColor = sender.color
		delegate?.setVolumeDisabledColor(color: sender.color)
	}
	@IBAction func brightnessColorChanged(_ sender: NSColorWell) {
		settingsController?.brightnessColor = sender.color
		delegate?.setBrightnessColor(color: sender.color)
	}
	@IBAction func keyboardBackLightColorChanged(_ sender: NSColorWell) {
		settingsController?.keyboardColor = sender.color
		delegate?.setBacklightColor(color: sender.color)
	}
	
	@IBAction func launchAtLoginClicked(_ sender: NSButton) {
		LaunchAtLogin.isEnabled = sender.state.boolValue()
	}
	
}
