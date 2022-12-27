//
//  ChangesObserver.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import Cocoa

class ChangesObserver {
    private var oldFullScreen: Bool
    private var oldVolume: Float
    private var oldBrightness: Float = 0
    private var oldKeyboard: Float = 0

    private var settingsManager: SettingsManager = SettingsManager.getInstance()
    private var positionManager: PositionManager
    private var displayer: Displayer
    private var volumeView: BarView
    private var brightnessView: BarView
    private var keyboardView: BarView

    init(positionManager: PositionManager, displayer: Displayer, volumeView: BarView, brightnessView: BarView, keyboardView: BarView) {
        oldFullScreen = DisplayManager.isInFullscreenMode()
        oldVolume = VolumeManager.getOutputVolume()
        
        do {
            oldBrightness = try DisplayManager.getDisplayBrightness()
        } catch {
            NSLog("Failed to retrieve display brightness. Please report it on GitHub.")
        }
        do {
            oldKeyboard = try KeyboardManager.getKeyboardBrightness()
        } catch {
            NSLog("Failed to retrieve keyboard brightness. Is no keyboard with backlight connected? Disabling keyboard HUD. If you think this is an error please report it on GitHub.")
            settingsManager.enabledBars.keyboardBar = false
        }
        
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
        if settingsManager.enabledBars.keyboardBar {
            checkKeyboardChanges()
        }
        if settingsManager.shouldContinuouslyCheck && settingsManager.enabledBars.volumeBar {
            checkVolumeChanges()
        }
    }

    private func isAlmost(firstNumber: Float, secondNumber: Float) -> Bool { // used to partially prevent the bars to display when no user input happened
        let marginValue = Float(settingsManager.marginValue) / 100.0
        return (firstNumber + marginValue >= secondNumber && firstNumber - marginValue <= secondNumber)
    }

    private func checkVolumeChanges() {
        let newVolume = VolumeManager.getOutputVolume()
        volumeView.bar!.progress = newVolume
        if !isAlmost(firstNumber: oldVolume, secondNumber: newVolume) {
            displayer.showVolumeHUD()
            oldVolume = newVolume
        }
        volumeView.bar!.progress = newVolume
    }

    private func checkBrightnessChanges() {
        if NSScreen.screens.count == 0 {
            return
        }
        do {
            let newBrightness = try DisplayManager.getDisplayBrightness()
            if !isAlmost(firstNumber: oldBrightness, secondNumber: newBrightness) {
                displayer.showBrightnessHUD()
                oldBrightness = newBrightness
            }
            brightnessView.bar?.progress = newBrightness
        } catch {
            NSLog("Failed to retrieve display brightness. Please report it on GitHub.") // todo show alert?
        }
    }

    private func checkKeyboardChanges() {
        do {
            let newKeyboard = try KeyboardManager.getKeyboardBrightness()
            if !isAlmost(firstNumber: oldKeyboard, secondNumber: newKeyboard) {
                displayer.showKeyboardHUD()
                oldKeyboard = newKeyboard
            }
            keyboardView.bar?.progress = try KeyboardManager.getKeyboardBrightness()
        } catch {
            NSLog("Failed to retrieve keyboard brightness. Is no keyboard with backlight connected? Disabling keyboard HUD. If you think this is an error please report it on GitHub.")
            settingsManager.enabledBars.keyboardBar = false
        }
    }
}
