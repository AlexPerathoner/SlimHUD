//
//  Displayer.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation
import Cocoa

class Displayer {
    var settingsManager: SettingsManager = SettingsManager.getInstance()
    var positionManager: PositionManager
    var volumeHud: Hud
    var brightnessHud: Hud
    var keyboardHud: Hud
    
    
    init(positionManager: PositionManager, volumeHud: Hud, brightnessHud: Hud, keyboardHud: Hud) {
        self.positionManager = positionManager
        self.volumeHud = volumeHud
        self.brightnessHud = brightnessHud
        self.keyboardHud = keyboardHud
    }
    
    @objc func showVolumeHUD() {
        if(!settingsManager.enabledBars.volumeBar) {return}
        let disabled = VolumeManager.isMuted()
        if let volumeView = volumeHud.view as? BarView {
            setColor(for: volumeView.bar!, disabled)
            if(!settingsManager.shouldContinuouslyCheck) {
                volumeView.bar!.progress = VolumeManager.getOutputVolume()
            }
            
            if(disabled) {
                volumeView.image!.image = NSImage(named: NSImage.NO_VOLUME_IMAGE_FILE_NAME)
            } else {
                volumeView.image!.image = NSImage(named: NSImage.VOLUME_IMAGE_FILE_NAME)
            }
            volumeHud.show()
            brightnessHud.hide(animated: false)
            keyboardHud.hide(animated: false)
            volumeHud.dismiss(delay: 1.5)
        } else {
            NSLog("Error while trying to retrieve the bar view from the volume Hud")
        }
    }
    
    @objc func showBrightnessHUD() {
        if(!settingsManager.enabledBars.brightnessBar) {return}
        brightnessHud.show()
        volumeHud.hide(animated: false)
        keyboardHud.hide(animated: false)
        brightnessHud.dismiss(delay: 1.5)
    }
    @objc func showKeyboardHUD() {
        if(!settingsManager.enabledBars.keyboardBar) {return}
        keyboardHud.show()
        volumeHud.hide(animated: false)
        brightnessHud.hide(animated: false)
        keyboardHud.dismiss(delay: 1.5)
    }
    
    func setColor(for bar: ProgressBar, _ disabled: Bool) { // todo should move into barView
        if(disabled) {
            bar.foreground = SettingsManager.disabledColor
        } else {
            bar.foreground = SettingsManager.enabledColor
        }
    }
}
