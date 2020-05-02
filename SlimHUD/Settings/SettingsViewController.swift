//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 03/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import LaunchAtLogin
import Sparkle

protocol SettingsWindowControllerDelegate: class {
	func updateShadows(enabled: Bool)
	func updateIcons(isHidden: Bool)
	func setupDefaultBarsColors()
	func setupDefaultIconsColors()
	func setBackgroundColor(color: NSColor)
	func setVolumeEnabledColor(color: NSColor)
	func setVolumeDisabledColor(color: NSColor)
	func setBrightnessColor(color: NSColor)
	func setKeyboardColor(color: NSColor)
	func setHeight(height: CGFloat)
	func setThickness(thickness: CGFloat)
	func setupHUDsPosition(_ isFullscreen: Bool)
	var shouldUseAnimation: Bool { get set }
	var enabledBars: [Bool] { get set }
	var marginValue: Float { get set }
	func setVolumeIconsTint(_ color: NSColor)
	func setBrightnessIconsTint(_ color: NSColor)
	func setKeyboardIconsTint(_ color: NSColor)
	var settingsController: SettingsController? { get set }
}


class SettingsViewController: NSViewController {
	
	weak var delegate: SettingsWindowControllerDelegate?
    weak var settingsController: SettingsController?
	@IBOutlet weak var preview: SettingsPreview!
	
	override func awakeFromNib() {
		self.delegate = NSApplication.shared.delegate as! AppDelegate
		self.settingsController = delegate?.settingsController
		do {
			try enabledBarsOutlet.setBarState(values: settingsController?.enabledBars ?? [])
		} catch {
			NSLog("Enabled bars saved in UserDefaults not valid")
		}
				
		 
		
		let formatter = DateFormatter()
		formatter.dateFormat = "dd MMM yyyy - HH:mm"
		lastCheckForUpdatesOutlet.stringValue = formatter.string(from: SUUpdater.shared()?.lastUpdateCheckDate ?? Date())

		
		marginValueOutlet.stringValue = String(settingsController?.marginValue ?? 5) + "%"
		marginStepperOutlet.integerValue = (settingsController?.marginValue ?? 5 * 100)
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
		thicknessValue.stringValue = String(settingsController!.barThickness)
		thicknessSlider.integerValue = settingsController!.barThickness
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
		
		volumeIconColorOutlet.color = settingsController!.volumeIconColor
		brightnessIconColorOutlet.color = settingsController!.brightnessIconColor
		keyboardIconColorOutlet.color = settingsController!.keyboardIconColor
		
		
		preview.settingsController = settingsController
		preview.setup()
		
		
	}
	
	
	// MARK: - General tab
	@IBOutlet weak var launchAtLoginOutlet: NSButton!
	@IBOutlet weak var continuousCheckOutlet: NSButton!
	@IBOutlet weak var enabledBarsOutlet: NSSegmentedControl!
	
	@IBAction func barsStateChanged(_ sender: NSSegmentedControl) {
		let barState = sender.getBarState()
		settingsController?.enabledBars = barState
		delegate?.enabledBars = barState
		preview.enabledBars = barState
		
	}
	@IBAction func shouldContinuouslyCheck(_ sender: NSButton) {
		settingsController?.shouldContinuouslyCheck = sender.state.boolValue()
	}
	@IBAction func launchAtLoginClicked(_ sender: NSButton) {
		LaunchAtLogin.isEnabled = sender.state.boolValue()
	}
	
	@IBOutlet weak var marginValueOutlet: NSTextField!
	@IBOutlet weak var marginStepperOutlet: NSStepper!
	
	@IBAction func marginValueChanged(_ sender: NSStepper) {
		let marginValue = sender.integerValue
		marginValueOutlet.stringValue = String(marginValue) + "%"
		delegate?.marginValue = Float(marginValue/100)
		settingsController?.marginValue = marginValue
	}
	
		
	@IBOutlet weak var lastCheckForUpdatesOutlet: NSTextField!
	//check for updates button sends action directly to SUUpdater object in storyboard
	
	
	// MARK: - Position tab
	
	@IBOutlet weak var heightValue: NSTextField!
	@IBOutlet weak var heightSliderOutlet: NSSlider!
	
	@IBOutlet weak var thicknessSlider: NSSlider!
	@IBOutlet weak var thicknessValue: NSTextField!
	
	@IBOutlet weak var positionOutlet: NSPopUpButton!
	
	@IBOutlet weak var restartOutlet: NSButton!
	
	@IBOutlet weak var positionButtonConstraint: NSLayoutConstraint!
	
	
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
		preview.setupHUDsPosition(false)
	}
	
	func displayRelaunchButton() {
		if(restartOutlet.isHidden) {
			positionButtonConstraint.constant = 51
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
	
	@IBAction func heightSlider(_ sender: NSSlider) {
		heightValue.stringValue = String(sender.integerValue)
		settingsController?.barHeight = sender.integerValue
		delegate?.setHeight(height: CGFloat(sender.integerValue))
		//preview.setHeight(height: CGFloat(sender.integerValue))
	}
	
	@IBAction func thicknessSlider(_ sender: NSSlider) {
		thicknessValue.stringValue = String(sender.integerValue)
		settingsController?.barThickness = sender.integerValue
		delegate?.setThickness(thickness: CGFloat(sender.integerValue))
		//preview.setThickness(thickness: CGFloat(sender.integerValue))
	}
	
	
	
	
	// MARK: - Style tab
	
	@IBOutlet weak var iconsBox: NSBox!
	@IBOutlet weak var barsBox: NSBox!
	
	@IBAction func changeColorOfClicked(_ sender: NSPopUpButton) {
		if(sender.titleOfSelectedItem == "Bars") {
			barsBox.isHidden = false
			iconsBox.isHidden = true
		} else {
			barsBox.isHidden = true
			iconsBox.isHidden = false
		}
	}
	
	@IBOutlet weak var iconOutlet: NSButton!
	@IBOutlet weak var shadowOutlet: NSButton!
	@IBOutlet weak var animationsOutlet: NSButton!
	
	@IBOutlet weak var backgroundColorOutlet: NSColorWell!
	@IBOutlet weak var volumeEnabledColorOutlet: NSColorWell!
	@IBOutlet weak var volumeDisabledColorOutlet: NSColorWell!
	@IBOutlet weak var brightnessColorOutlet: NSColorWell!
	@IBOutlet weak var keyboardColorOutlet: NSColorWell!
	
	@IBOutlet weak var volumeIconColorOutlet: NSColorWell!
	@IBOutlet weak var brightnessIconColorOutlet: NSColorWell!
	@IBOutlet weak var keyboardIconColorOutlet: NSColorWell!
	
	
	@IBAction func shouldShowIconsAction(_ sender: NSButton) {
		let val = sender.state.boolValue()
		settingsController?.shouldShowIcons = val
		delegate?.updateIcons(isHidden: !val)
		preview.updateIcons(isHidden: !val)
	}
	
	@IBAction func shouldShowShadows(_ sender: NSButton) {
		let val = sender.state.boolValue()
		settingsController?.shouldShowShadows = val
		delegate?.updateShadows(enabled: val)
		preview.updateShadows(enabled: val)
	}
	
	
	@IBAction func shouldUseAnimations(_ sender: NSButton) {
		let val = sender.state.boolValue()
		settingsController?.shouldUseAnimation = val
		delegate?.shouldUseAnimation = val
		preview.shouldUseAnimation = val
	}
	
	
	@IBAction func resetDefaultsBarColors(_ sender: Any) {
		//updating bars and preview
		delegate?.setupDefaultBarsColors()
		preview.setupDefaultBarsColors()
		//updating settings
		settingsController?.resetDefaultBarsColors()
		//updating color wells of view
		volumeEnabledColorOutlet.color = SettingsController.blue
		volumeDisabledColorOutlet.color = SettingsController.gray
		keyboardColorOutlet.color = SettingsController.azure
		brightnessColorOutlet.color = SettingsController.yellow
		backgroundColorOutlet.color = SettingsController.darkGray
	}
	
	
	@IBAction func resetDefaultsIconColors(_ sender: Any) {
		//updating bars and preview
		delegate?.setupDefaultIconsColors()
		preview.setupDefaultIconsColors()
		//updating settings
		settingsController?.resetDefaultIconsColors()
		//updating color wells of view
		volumeIconColorOutlet.color = .white
		brightnessIconColorOutlet.color = .white
		keyboardIconColorOutlet.color = .white
	}
	
	
	
	
	//changing values automatically also saves them into userdefaults
	@IBAction func backgroundColorChanged(_ sender: NSColorWell) {
		settingsController?.backgroundColor = sender.color
		delegate?.setBackgroundColor(color: sender.color)
		preview.setBackgroundColor(color: sender.color)
	}
	@IBAction func volumeEnabledColorChanged(_ sender: NSColorWell) {
		settingsController?.volumeEnabledColor = sender.color
		delegate?.setVolumeEnabledColor(color: sender.color)
		preview.setVolumeEnabledColor(color: sender.color)
	}
	@IBAction func volumeDisabledColorChanged(_ sender: NSColorWell) {
		settingsController?.volumeDisabledColor = sender.color
		delegate?.setVolumeDisabledColor(color: sender.color)
		preview.setVolumeDisabledColor(color: sender.color)
	}
	@IBAction func brightnessColorChanged(_ sender: NSColorWell) {
		settingsController?.brightnessColor = sender.color
		delegate?.setBrightnessColor(color: sender.color)
		preview.setBrightnessColor(color: sender.color)
	}
	@IBAction func keyboardBackLightColorChanged(_ sender: NSColorWell) {
		settingsController?.keyboardColor = sender.color
		delegate?.setKeyboardColor(color: sender.color)
		preview.setKeyboardColor(color: sender.color)
	}
	@IBAction func volumeIconColorChanged(_ sender: NSColorWell) {
		settingsController?.volumeIconColor = sender.color
		delegate?.setVolumeIconsTint(sender.color)
		preview.setVolumeIconsTint(sender.color)
	}
	@IBAction func brightnessIconChanged(_ sender: NSColorWell) {
		settingsController?.brightnessIconColor = sender.color
		delegate?.setBrightnessIconsTint(sender.color)
		preview.setBrightnessIconsTint(sender.color)
	}
	@IBAction func keyboardIconColorChanged(_ sender: NSColorWell) {
		settingsController?.keyboardIconColor = sender.color
		delegate?.setKeyboardIconsTint(sender.color)
		preview.setKeyboardIconsTint(sender.color)
	}
	
		
}

