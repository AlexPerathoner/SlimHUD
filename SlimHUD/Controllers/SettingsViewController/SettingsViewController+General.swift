//
//  SettingsViewController+General.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 17/08/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

extension SettingsViewController {
	// MARK: - General tab
	@IBAction func barsStateChanged(_ sender: NSSegmentedControl) {
		let barState = sender.getBarState()
		settingsManager.enabledBars = barState
		preview.enabledBars = barState
	}
    
	@IBAction func shouldContinuouslyCheck(_ sender: NSButton) {
		settingsManager.shouldContinuouslyCheck = sender.boolValue()
	}
	@IBAction func launchAtLoginClicked(_ sender: NSButton) {
		if(sender.boolValue()) {
			if(!loginItemsList.addLoginItem()) {
				print("Error while adding Login Item to the list.");
			}
		} else {
			if(!loginItemsList.removeLoginItem()) {
				print("Error while removing Login Item from the list.");
			}
		}
	}
	
	@IBAction func marginValueChanged(_ sender: NSStepper) {
		let marginValue = sender.integerValue
		marginValueOutlet.stringValue = String(marginValue) + "%"
		settingsManager.marginValue = marginValue
	}
	
	
	
}
