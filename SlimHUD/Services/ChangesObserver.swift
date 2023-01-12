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
    private var oldMuted: Bool
    private var oldBrightness: Float = 0
    private var oldKeyboard: Float = 0

    private var settingsManager: SettingsManager = SettingsManager.getInstance()
    private var positionManager: PositionManager
    private var displayer: Displayer
    private var volumeView: BarView
    private var brightnessView: BarView
    private var keyboardView: BarView

    private var temporarelyDisabledBars = EnabledBars(volumeBar: false, brightnessBar: false, keyboardBar: false)

    init(positionManager: PositionManager, displayer: Displayer, volumeView: BarView, brightnessView: BarView, keyboardView: BarView) {
        oldFullScreen = DisplayManager.isInFullscreenMode()
        oldVolume = VolumeManager.getOutputVolume()
        oldMuted = VolumeManager.isMuted()

        do {
            oldBrightness = try DisplayManager.getDisplayBrightness()
        } catch {
            temporarelyDisabledBars.brightnessBar = true
            NSLog("Failed to retrieve display brightness. See https://github.com/AlexPerathoner/SlimHUD/issues/60")
        }
        do {
            oldKeyboard = try KeyboardManager.getKeyboardBrightness()
        } catch {
            temporarelyDisabledBars.keyboardBar = true
            NSLog("""
                  Failed to retrieve keyboard brightness. Is no keyboard with backlight connected?
                  Disabling keyboard HUD. If you think this is an error please report it on GitHub.
                  """)  // todo show alert? also when re-enabling hud if it didnt work
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
        DistributedNotificationCenter.default.addObserver(self,
                                                          selector: #selector(showVolumeHUD),
                                                          name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"),
                                                          object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showVolumeHUD),
                                               name: KeyPressObserver.volumeChanged,
                                               object: nil)
        // observers for brightness
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showBrightnessHUD),
                                               name: KeyPressObserver.brightnessChanged,
                                               object: nil)
        // observers for keyboard backlight
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKeyboardHUD),
                                               name: KeyPressObserver.keyboardIlluminationChanged,
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
        if settingsManager.shouldContinuouslyCheck {
            if settingsManager.enabledBars.brightnessBar && !temporarelyDisabledBars.brightnessBar {
                checkBrightnessChanges()
            }
            if settingsManager.enabledBars.keyboardBar && !temporarelyDisabledBars.keyboardBar {
                checkKeyboardChanges()
            }
        }
        // volume can't change on its own, so we always continuously check it
        if settingsManager.enabledBars.volumeBar && settingsManager.enabledBars.volumeBar {
            checkVolumeChanges()
        }
    }

    private func isAlmost(firstNumber: Float, secondNumber: Float) -> Bool { // used to partially prevent the bars to display when no user input happened
        let marginValue = Float(settingsManager.marginValue) / 100.0
        return (firstNumber + marginValue >= secondNumber && firstNumber - marginValue <= secondNumber)
    }

    private func checkVolumeChanges() {
        let newVolume = VolumeManager.getOutputVolume()
        let newMuted = VolumeManager.isMuted()
        volumeView.bar!.progress = newVolume
        if !isAlmost(firstNumber: oldVolume, secondNumber: newVolume) || newMuted != oldMuted {
            displayer.showVolumeHUD()
            oldVolume = newVolume
            oldMuted = newMuted
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
            temporarelyDisabledBars.brightnessBar = true
            NSLog("Failed to retrieve display brightness. See https://github.com/AlexPerathoner/SlimHUD/issues/60")
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
            temporarelyDisabledBars.keyboardBar = true
            NSLog("""
                    Failed to retrieve keyboard brightness. Is no keyboard with backlight connected? Disabling keyboard HUD.
                    If you think this is an error please report it on GitHub.
                    """)
        }
    }

    /// When no keyboard with backlight or display with brightness control is connected, SlimHUD fails to retrieve their values.
    ///  In fact, as they can't be controlled, they won't change. We can therefore disable those bars entirely.
    ///  However, once the display settings change, we need to reset these values.
    public func resetTemporarelyDisabledBars() {
        temporarelyDisabledBars = EnabledBars(volumeBar: false, brightnessBar: false, keyboardBar: false)
    }
}
