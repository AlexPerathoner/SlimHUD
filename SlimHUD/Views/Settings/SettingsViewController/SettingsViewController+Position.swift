//
//  SettingsViewController+Position.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 17/08/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

extension SettingsViewController {
	// MARK: - Position tab
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
            settingsController?.position = .left
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
	
	
	
	
}
