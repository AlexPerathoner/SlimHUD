//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 03/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import Sparkle


class SettingsViewController: NSViewController {
	let loginItemsList = LoginItemsList();

    var settingsController: SettingsController = SettingsController.getInstance()
	@IBOutlet weak var preview: SettingsPreview!
    weak var delegate: SettingsWindowControllerDelegate?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		do {
            try enabledBarsOutlet.setBarState(enabledBars: settingsController.enabledBars)
		} catch {
			NSLog("Enabled bars saved in UserDefaults not valid")
		}
		
		let formatter = DateFormatter()
		formatter.dateFormat = "dd MMM yyyy - HH:mm"
		lastCheckForUpdatesOutlet.stringValue = formatter.string(from: SUUpdater.shared()?.lastUpdateCheckDate ?? Date())

		
		marginValueOutlet.stringValue = String(settingsController.marginValue) + "%"
		marginStepperOutlet.integerValue = (settingsController.marginValue * 100)
		launchAtLoginOutlet.state = loginItemsList.isLoginItemInList().toStateValue()
		iconOutlet.state = settingsController.shouldShowIcons!.toStateValue()
		shadowOutlet.state = settingsController.shouldShowShadows.toStateValue()
		continuousCheckOutlet.state = settingsController.shouldContinuouslyCheck.toStateValue()
		animationsOutlet.state = settingsController.shouldUseAnimation.toStateValue()
		backgroundColorOutlet.color = settingsController.backgroundColor
		volumeEnabledColorOutlet.color = settingsController.volumeEnabledColor
		volumeDisabledColorOutlet.color = settingsController.volumeDisabledColor
		brightnessColorOutlet.color = settingsController.brightnessColor
		keyboardColorOutlet.color = settingsController.keyboardColor
		heightValue.stringValue = String(settingsController.barHeight)
		heightSliderOutlet.integerValue = settingsController.barHeight
		thicknessValue.stringValue = String(settingsController.barThickness)
		thicknessSlider.integerValue = settingsController.barThickness
		switch settingsController.position {
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
		if #available(OSX 10.14, *) {
			volumeIconColorOutlet.color = settingsController.volumeIconColor
			brightnessIconColorOutlet.color = settingsController.brightnessIconColor
			keyboardIconColorOutlet.color = settingsController.keyboardIconColor
		} else {
			changedColorOfOutlet.isHidden = true
			chagedColorOfLabel.stringValue = "Changing colors of bars"
		}
		
		preview.settingsController = settingsController
		preview.setup()
		
		
	}
	
	// MARK: - Outlets
	
	
	
	// MARK: General tab
	@IBOutlet weak var launchAtLoginOutlet: NSButton!
	@IBOutlet weak var continuousCheckOutlet: NSButton!
	@IBOutlet weak var enabledBarsOutlet: NSSegmentedControl!
	
	@IBOutlet weak var marginValueOutlet: NSTextField!
	@IBOutlet weak var marginStepperOutlet: NSStepper!
	
	@IBOutlet weak var lastCheckForUpdatesOutlet: NSTextField!
	//check for updates button sends action directly to SUUpdater object in storyboard

	
	// MARK: Position tab
	@IBOutlet weak var heightValue: NSTextField!
	@IBOutlet weak var heightSliderOutlet: NSSlider!
	
	@IBOutlet weak var thicknessSlider: NSSlider!
	@IBOutlet weak var thicknessValue: NSTextField!
	
	@IBOutlet weak var positionOutlet: NSPopUpButton!
	
	@IBOutlet weak var restartOutlet: NSButton!
	
	@IBOutlet weak var positionButtonConstraint: NSLayoutConstraint!
	
	// MARK: Style tab
	@IBOutlet weak var iconsBox: NSBox!
	@IBOutlet weak var barsBox: NSBox!
	@IBOutlet weak var changedColorOfOutlet: NSPopUpButton!
	@IBOutlet weak var chagedColorOfLabel: NSTextField!
	
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
	
}

