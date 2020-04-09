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
	func setThickness(thickness: CGFloat)
	func setupHUDsPosition(_ isFullscreen: Bool)
	var shouldUseAnimation: Bool { get set }
	var enabledBars: [Bool] { get set }
	var marginValue: Float { get set }
}


class SettingsWindowController: NSWindowController {
	
	weak var delegate: SettingsWindowControllerDelegate?
    weak var settingsController: SettingsController?
	@IBOutlet weak var preview: SettingsPreview!
	
	override func windowDidLoad() {
		do {
			try enabledBarsOutlet.setBarState(values: settingsController?.enabledBars ?? [])
		} catch {
			NSLog("Enabled bars saved in UserDefaults not valid")
		}
		
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
		
        super.windowDidLoad()
		
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
	
	@IBAction func marginValueHelp(_ sender: Any) {
		let generalHelpURL = URL(string: "https://github.com/AlexPerathoner/SlimHUD/wiki/Settings")!
		if NSWorkspace.shared.open(generalHelpURL) {
			NSLog("Link opened successfully")
		}
	}
	
	@IBAction func continuouslyCheckHelp(_ sender: Any) {
		marginValueHelp(sender)
	}
	
	
	
	
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
	
	
	@IBOutlet weak var iconOutlet: NSButton!
	@IBOutlet weak var shadowOutlet: NSButton!
	@IBOutlet weak var animationsOutlet: NSButton!
	
	@IBOutlet weak var backgroundColorOutlet: NSColorWell!
	@IBOutlet weak var volumeEnabledColorOutlet: NSColorWell!
	@IBOutlet weak var volumeDisabledColorOutlet: NSColorWell!
	@IBOutlet weak var brightnessColorOutlet: NSColorWell!
	@IBOutlet weak var keyboardColorOutlet: NSColorWell!
	
	
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
	
	
	@IBAction func resetDefaults(_ sender: Any) {
		delegate?.setupDefaultColors()
		settingsController?.resetDefaultColors()
		volumeEnabledColorOutlet.color = SettingsController.blue
		volumeDisabledColorOutlet.color = SettingsController.gray
		keyboardColorOutlet.color = SettingsController.azure
		brightnessColorOutlet.color = SettingsController.yellow
		backgroundColorOutlet.color = SettingsController.darkGray
		preview.setupDefaultColors()
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
		delegate?.setBacklightColor(color: sender.color)
		preview.setBacklightColor(color: sender.color)
	}
	
	@IBAction func volumeHelp(_ sender: NSButton) {
		let styleHelpURL = URL(string: "https://github.com/AlexPerathoner/SlimHUD/wiki/Settings")!
		if NSWorkspace.shared.open(styleHelpURL) {
			NSLog("Link opened successfully")
		}
	}
	
	
	// MARK: - Preview
	
	@objc func windowWillClose() {
		NotificationCenter.default.removeObserver(self, name: .init("NSWindowWillCloseNotification"), object: window)
		previewTimer?.invalidate()
		previewTimer = nil
	}
	
	
	var previewTimer: Timer?
	func showPreviewHUD() {
		previewTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
			NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
		}
		RunLoop.current.add(previewTimer!, forMode: .eventTracking)
	}
	
	override func showWindow(_ sender: Any?) {
		NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose), name: .init("NSWindowWillCloseNotification"), object: window)
		showPreviewHUD()
		super.showWindow(sender)
	}
	
}

