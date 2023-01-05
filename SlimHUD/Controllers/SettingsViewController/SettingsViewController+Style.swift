//
//  SettingsViewController+Style.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

extension SettingsViewController {
    @IBAction func changeColorOfClicked(_ sender: NSPopUpButton) {
        if sender.titleOfSelectedItem == "Bars" {
            barsBox.isHidden = false
            iconsBox.isHidden = true
        } else {
            barsBox.isHidden = true
            iconsBox.isHidden = false
        }
    }

    @IBAction func shouldShowIconsAction(_ sender: NSButton) {
        let shouldShowIcons = sender.boolValue()
        settingsManager.shouldShowIcons = shouldShowIcons
        delegate?.updateIcons(isHidden: !shouldShowIcons)
        preview.updateIcons(isHidden: !shouldShowIcons)
    }

    @IBAction func shouldShowShadows(_ sender: NSButton) {
        let shouldShowShadows = sender.boolValue()
        settingsManager.shouldShowShadows = shouldShowShadows
        delegate?.updateShadows(enabled: shouldShowShadows)
        preview.updateShadows(enabled: shouldShowShadows)
    }

    @IBAction func shouldUseAnimations(_ sender: NSButton) {
        let shouldUseAnimation = sender.boolValue()
        settingsManager.shouldUseAnimation = shouldUseAnimation
        delegate?.setShouldUseAnimation(shouldUseAnimation: shouldUseAnimation)
        preview.setShouldUseAnimation(shouldUseAnimation: shouldUseAnimation)
    }
    
    @IBAction func shouldUseFlatBar(_ sender: NSButton) {
        let shouldUseFlatBar = sender.boolValue()
        settingsManager.flatBar = shouldUseFlatBar
        preview.setThickness(thickness: CGFloat(settingsManager.barThickness))
        delegate?.setThickness(thickness: CGFloat(settingsManager.barThickness))
    }

    @IBAction func resetDefaultsBarColors(_ sender: Any) {
        // updating bars and preview
        delegate?.setupDefaultBarsColors()
        preview.setupDefaultBarsColors()
        // updating settings
        settingsManager.resetDefaultBarsColors()
        // updating color wells of view
        volumeEnabledColorOutlet.color = DefaultColors.Blue
        volumeDisabledColorOutlet.color = DefaultColors.Gray
        keyboardColorOutlet.color = DefaultColors.Azure
        brightnessColorOutlet.color = DefaultColors.Yellow
        backgroundColorOutlet.color = DefaultColors.DarkGray
    }

    @IBAction func resetDefaultsIconColors(_ sender: Any) {
        // updating bars and preview
        if #available(OSX 10.14, *) {
            delegate?.setupDefaultIconsColors()
            preview.setupDefaultIconsColors()
        }
        // updating settings
        settingsManager.resetDefaultIconsColors()
        // updating color wells of view
        volumeIconColorOutlet.color = .white
        brightnessIconColorOutlet.color = .white
        keyboardIconColorOutlet.color = .white
    }

    // changing values automatically also saves them into userdefaults
    @IBAction func backgroundColorChanged(_ sender: NSColorWell) {
        settingsManager.backgroundColor = sender.color
        delegate?.setBackgroundColor(color: sender.color)
        preview.setBackgroundColor(color: sender.color)
    }
    @IBAction func volumeEnabledColorChanged(_ sender: NSColorWell) {
        settingsManager.volumeEnabledColor = sender.color
        delegate?.setVolumeEnabledColor(color: sender.color)
        preview.setVolumeEnabledColor(color: sender.color)
    }
    @IBAction func volumeDisabledColorChanged(_ sender: NSColorWell) {
        settingsManager.volumeDisabledColor = sender.color
        delegate?.setVolumeDisabledColor(color: sender.color)
        preview.setVolumeDisabledColor(color: sender.color)
    }
    @IBAction func brightnessColorChanged(_ sender: NSColorWell) {
        settingsManager.brightnessColor = sender.color
        delegate?.setBrightnessColor(color: sender.color)
        preview.setBrightnessColor(color: sender.color)
    }
    @IBAction func keyboardBackLightColorChanged(_ sender: NSColorWell) {
        settingsManager.keyboardColor = sender.color
        delegate?.setKeyboardColor(color: sender.color)
        preview.setKeyboardColor(color: sender.color)
    }
    @available(OSX 10.14, *)
    @IBAction func volumeIconColorChanged(_ sender: NSColorWell) {
        settingsManager.volumeIconColor = sender.color
        delegate?.setVolumeIconsTint(sender.color)
        preview.setVolumeIconsTint(sender.color)
    }
    @available(OSX 10.14, *)
    @IBAction func brightnessIconChanged(_ sender: NSColorWell) {
        settingsManager.brightnessIconColor = sender.color
        delegate?.setBrightnessIconsTint(sender.color)
        preview.setBrightnessIconsTint(sender.color)
    }
    @available(OSX 10.14, *)
    @IBAction func keyboardIconColorChanged(_ sender: NSColorWell) {
        settingsManager.keyboardIconColor = sender.color
        delegate?.setKeyboardIconsTint(sender.color)
        preview.setKeyboardIconsTint(sender.color)
    }

}
