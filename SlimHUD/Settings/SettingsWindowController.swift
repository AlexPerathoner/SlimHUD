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
	func setHeight(height: CGFloat)
	func setupHUDsPosition(_ isFullscreen: Bool)
	var shouldUseAnimation: Bool { get set }
}
class SettingsWindowController: NSWindowController {
	
	weak var delegate: SettingsWindowControllerDelegate?
    weak var settingsController: SettingsController?
	
	@IBOutlet weak var previewBox: NSBox!
	override func windowDidLoad() {
		//previewBox.contentView?.insertVibrancyViewBlendingMode(.behindWindow)
		launchAtLoginOutlet.state = LaunchAtLogin.isEnabled.toStateValue()
		iconOutlet.state = settingsController?.shouldShowIcons!.toStateValue() ?? .on
		shadowOutlet.state = settingsController?.shouldShowShadows.toStateValue() ?? .on
		continuousCheckOutlet.state = settingsController?.shouldContinuouslyCheck.toStateValue() ?? .on
		animationsOutlet.state = settingsController?.shouldUseAnimation.toStateValue() ?? .on
		backgroundColorOutlet.color = settingsController!.backgroundColor
		volumeEnabledColorOutlet.color = settingsController!.volumeEnabledColor
		volumeDisabledColorOutlet.color = settingsController!.volumeDisabledColor
		brightnessColorOutlet.color = settingsController!.brightnessColor
		keyboardColorOutlet.color = settingsController!.keyboardColor
		heightValue.stringValue = String(settingsController!.barHeight)
		heightSliderOutlet.integerValue = settingsController!.barHeight
		switch settingsController?.position {
		case .left:
			positionOutlet.selectItem(at: 0)
		case .bottom:
			positionOutlet.selectItem(at: 1)
		case .top:
			positionOutlet.selectItem(at: 2)
		case .right:
			positionOutlet.selectItem(at: 3)
		default:
			NSLog("Error! Could not load saved position")
		}
        super.windowDidLoad()
	}
	
	@IBOutlet weak var launchAtLoginOutlet: NSButton!
	
	@IBOutlet weak var iconOutlet: NSButton!
	@IBOutlet weak var shadowOutlet: NSButton!
	@IBOutlet weak var continuousCheckOutlet: NSButton!
	@IBOutlet weak var animationsOutlet: NSButton!
	
	@IBOutlet weak var backgroundColorOutlet: NSColorWell!
	@IBOutlet weak var volumeEnabledColorOutlet: NSColorWell!
	@IBOutlet weak var volumeDisabledColorOutlet: NSColorWell!
	@IBOutlet weak var brightnessColorOutlet: NSColorWell!
	@IBOutlet weak var keyboardColorOutlet: NSColorWell!
	
	@IBOutlet weak var heightValue: NSTextField!
	@IBOutlet weak var heightSliderOutlet: NSSlider!
	
	@IBOutlet weak var positionOutlet: NSPopUpButton!
	@IBAction func rotationChanged(_ sender: NSPopUpButton) {
		switch sender.indexOfSelectedItem {
		case 0:
			settingsController?.position = .left
		case 1:
			settingsController?.position = .bottom
		case 2:
			settingsController?.position = .top
		case 3:
			settingsController?.position = .right
		default:
			NSLog("What the-? Something went wrong! Please report this bug")
		}
		delegate?.setupHUDsPosition(false)

		if(settingsController?.shouldShowIcons ?? false) {
			displayRelaunchButton()
		}
	}
	
	
	@IBAction func heightSlider(_ sender: NSSlider) {
		heightValue.stringValue = String(sender.integerValue)
		delegate?.setHeight(height: CGFloat(sender.integerValue))
		settingsController?.barHeight = sender.integerValue
	}
	
		
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
	
	@IBAction func shouldContinuouslyCheck(_ sender: NSButton) {
		settingsController?.shouldContinuouslyCheck = sender.state.boolValue()
		
	}
	
	@IBAction func shouldUseAnimations(_ sender: NSButton) {
		let val = sender.state.boolValue()
		settingsController?.shouldUseAnimation = val
		delegate?.shouldUseAnimation = val
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
	@IBOutlet weak var restartOutlet: NSButton!
	
	@IBOutlet weak var positionButtonConstraint: NSLayoutConstraint!
	
	func displayRelaunchButton() {
		if(restartOutlet.isHidden) {
			positionButtonConstraint.constant = 62
			NSAnimationContext.runAnimationGroup({ (context) -> Void in
				context.duration = 0.5
				//restartOutlet.animator().alphaValue = 1
				positionButtonConstraint.animator().constant = 16
			}, completionHandler: { () -> Void in
				
				self.restartOutlet.isHidden = false
			})
		}
	}
	
	@IBAction func restartButton(_ sender: Any) {
		let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
		let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
		let task = Process()
		task.launchPath = "/usr/bin/open"
		task.arguments = [path]
		task.launch()
		exit(0)
	}
	
}
