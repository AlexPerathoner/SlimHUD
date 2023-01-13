//
//  SettingsViewController+Position.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

extension SettingsViewController {
    // MARK: - Position tab
    @IBAction func rotationChanged(_ sender: NSPopUpButton) {
        switch sender.indexOfSelectedItem {
        case 0:
            settingsManager.position = .left
        case 1:
            settingsManager.position = .bottom
        case 2:
            settingsManager.position = .top
        case 3:
            settingsManager.position = .right
        default:
            settingsManager.position = .left
        }
        // as the settings window is the frontmost window, fullscreen is certainly false
        delegate?.positionManager.setupHUDsPosition(isFullscreen: false)
    }

    @IBAction func heightSlider(_ sender: NSSlider) {
        heightValue.stringValue = String(sender.integerValue)
        settingsManager.barHeight = sender.integerValue
        delegate?.setHeight(height: CGFloat(sender.integerValue))
        // preview.setHeight(height: CGFloat(sender.integerValue))
    }

    @IBAction func thicknessSlider(_ sender: NSSlider) {
        thicknessValue.stringValue = String(sender.integerValue)
        settingsManager.barThickness = sender.integerValue
        delegate?.setThickness(thickness: CGFloat(sender.integerValue))
        // preview.setThickness(thickness: CGFloat(sender.integerValue))
    }

}
