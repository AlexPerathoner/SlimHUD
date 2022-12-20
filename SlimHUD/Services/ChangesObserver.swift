//
//  ChangesObserver.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation
import Cocoa

class ChangesObserver {
    private var oldFullScreen: Bool
    private var oldVolume: Float
    private var oldBrightness: Float

    var settingsManager: SettingsManager = SettingsManager.getInstance()
    var positionManager: PositionManager
    var displayer: Displayer
    var volumeView: BarView
    var brightnessView: BarView
    var keyboardView: BarView

    init(positionManager: PositionManager, displayer: Displayer, volumeView: BarView, brightnessView: BarView, keyboardView: BarView) {
        oldFullScreen = DisplayManager.isInFullscreenMode()
        oldVolume = VolumeManager.getOutputVolume()
        oldBrightness = DisplayManager.getDisplayBrightness()
        self.positionManager = positionManager
        self.displayer = displayer
        self.volumeView = volumeView
        self.brightnessView = brightnessView
        self.keyboardView = keyboardView
    }

    func startObserving() {
        createObservers()
        createTimerForContinuousChangesCheck(with: 0.2)
    }

    private func createTimerForContinuousChangesCheck(with seconds: TimeInterval) {
        let timer = Timer(timeInterval: seconds, target: self, selector: #selector(checkChanges), userInfo: nil, repeats: true)
        let mainLoop = RunLoop.main
        mainLoop.add(timer, forMode: .common)
    }

    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showVolumeHUD), name: KeyPressObserver.volumeChanged, object: nil)
        DistributedNotificationCenter.default.addObserver(self,
                                                          selector: #selector(showVolumeHUD),
                                                          name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"),
                                                          object: nil)

        // observers for brightness
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showBrightnessHUD),
                                               name: KeyPressObserver.brightnessChanged,
                                               object: nil)

        // observers for keyboard backlight
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKeyboardHUD),
                                               name: KeyPressObserver.keyboardIlluminationChanged, object: nil)
        DistributedNotificationCenter.default.addObserver(self,
                                                          selector: #selector(showVolumeHUD),
                                                          name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"),
                                                          object: nil)
    }

    @objc func showVolumeHUD() {
        displayer.showVolumeHUD()
    }
    @objc func showBrightnessHUD() {
        displayer.showBrightnessHUD()
    }
    @objc func showKeyboardHUD() {
        displayer.showKeyboardHUD()
    }

    @objc func checkChanges() {
        let newFullScreen = DisplayManager.isInFullscreenMode()

        if newFullScreen != oldFullScreen {
            positionManager.setupHUDsPosition(newFullScreen)
            oldFullScreen = newFullScreen
        }

        if settingsManager.enabledBars.brightnessBar {
            checkBrightnessChanges()
        }
        if settingsManager.shouldContinuouslyCheck && settingsManager.enabledBars.volumeBar {
            checkVolumeChanges()
        }
    }

    func isAlmost(firstNumber: Float, secondNumber: Float) -> Bool { // used to partially prevent the bars to display when no user input happened
        let marginValue = Float(settingsManager.marginValue) / 100.0
        return (firstNumber + marginValue >= secondNumber && firstNumber - marginValue <= secondNumber)
    }

    func checkVolumeChanges() {
        let newVolume = VolumeManager.getOutputVolume()
        volumeView.bar!.progress = newVolume
        if !isAlmost(firstNumber: oldVolume, secondNumber: newVolume) {
            displayer.showVolumeHUD()
            oldVolume = newVolume
        }
        volumeView.bar!.progress = newVolume
    }

    func checkBrightnessChanges() {
        if NSScreen.screens.count == 0 {return}
        let newBrightness = DisplayManager.getDisplayBrightness()
        if !isAlmost(firstNumber: oldBrightness, secondNumber: newBrightness) {
            displayer.showBrightnessHUD()
            oldBrightness = newBrightness
        }
        brightnessView.bar?.progress = newBrightness
    }
}
