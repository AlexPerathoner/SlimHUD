//
//  SettingsController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 28/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class SettingsController: NSView, HudsControllerInterface {
    var settingsManager: SettingsManager = SettingsManager.getInstance()

    var volumeHud = Hud()
    var brightnessHud = Hud()
    var keyboardHud = Hud()

    lazy var positionManager: PositionManager = PositionManager(volumeHud: volumeHud, brightnessHud: brightnessHud, keyboardHud: keyboardHud)

    @IBOutlet weak var volumeView: NSView!
    @IBOutlet weak var brightnessView: NSView!
    @IBOutlet weak var keyboardView: NSView!

    @IBOutlet weak var volumeBar: ProgressBar!
    @IBOutlet weak var brightnessBar: ProgressBar!
    @IBOutlet weak var keyboardBar: ProgressBar!

    @IBOutlet weak var volumeImage: NSImageView!
    @IBOutlet weak var brightnessImage: NSImageView!
    @IBOutlet weak var keyboardImage: NSImageView!

    func setup() {
        volumeHud.view = volumeView
        brightnessHud.view = brightnessView
        keyboardHud.view = keyboardView
        updateAll()
    }

    func updateShadows(enabled: Bool) {
        volumeView.setupShadow(enabled, 20)
        brightnessView.setupShadow(enabled, 20)
        keyboardView.setupShadow(enabled, 20)
    }

    func updateIcons(isHidden: Bool) {
        volumeImage.isHidden = isHidden
        brightnessImage.isHidden = isHidden
        keyboardImage.isHidden = isHidden
    }

    func setupDefaultBarsColors() {
        volumeBar.foreground = DefaultColors.Blue
        brightnessBar.foreground = DefaultColors.Yellow
        keyboardBar.foreground = DefaultColors.Azure
        setBackgroundColor(color: DefaultColors.DarkGray)
    }

    func setupDefaultIconsColors() {
        setVolumeIconsTint(.white)
        setBrightnessIconsTint(.white)
        setKeyboardIconsTint(.white)
    }

    func setBackgroundColor(color: NSColor) {
        volumeBar.background = color
        brightnessBar.background = color
        keyboardBar.background = color
    }

    func setVolumeEnabledColor(color: NSColor) {
        volumeBar.foreground = color
        volumeImage.image = NSImage(named: NSImage.VolumeImageFileName)
    }

    func setVolumeDisabledColor(color: NSColor) {
        volumeBar.foreground = color
        volumeImage.image = NSImage(named: NSImage.NoVolumeImageFileName)
    }

    func setBrightnessColor(color: NSColor) {
        brightnessBar.foreground = color
    }

    func setKeyboardColor(color: NSColor) {
        keyboardBar.foreground = color
    }

    // isn't showed in preview
    func setHeight(height: CGFloat) {}
    func setThickness(thickness: CGFloat) {}

    func setShouldUseAnimation(shouldUseAnimation: Bool) {
        volumeHud.animated = shouldUseAnimation
        brightnessHud.animated = shouldUseAnimation
        keyboardHud.animated = shouldUseAnimation
        volumeBar.setupAnimation(animated: shouldUseAnimation)
        brightnessBar.setupAnimation(animated: shouldUseAnimation)
        keyboardBar.setupAnimation(animated: shouldUseAnimation)
        showAnimation()
    }

    var enabledBars: EnabledBars = EnabledBars(volumeBar: true, brightnessBar: true, keyboardBar: true) {
        didSet {
            volumeView.isHidden = !enabledBars.volumeBar
            brightnessView.isHidden = !enabledBars.brightnessBar
            keyboardView.isHidden = !enabledBars.keyboardBar
        }
    }

    func setVolumeIconsTint(_ color: NSColor) {
        if #available(OSX 10.14, *) {
            volumeImage.contentTintColor = color
        } else {
            NSLog("Can't change icons' tint - MacOS 10.14+ needed")
        }
    }
    func setBrightnessIconsTint(_ color: NSColor) {
        if #available(OSX 10.14, *) {
            brightnessImage.contentTintColor = color
        } else {
            NSLog("Can't change icons' tint - MacOS 10.14+ needed")
        }
    }
    func setKeyboardIconsTint(_ color: NSColor) {
        if #available(OSX 10.14, *) {
            keyboardImage.contentTintColor = color
        } else {
            NSLog("Can't change icons' tint - MacOS 10.14+ needed")
        }
    }

    func updateAll() {
        enabledBars = settingsManager.enabledBars
        updateIcons(isHidden: !(settingsManager.shouldShowIcons))
        updateShadows(enabled: settingsManager.shouldShowShadows)
        setBackgroundColor(color: settingsManager.backgroundColor)
        setVolumeDisabledColor(color: settingsManager.volumeDisabledColor)
        setVolumeEnabledColor(color: settingsManager.volumeEnabledColor)
        setBrightnessColor(color: settingsManager.brightnessColor)
        setKeyboardColor(color: settingsManager.keyboardColor)
        setShouldUseAnimation(shouldUseAnimation: settingsManager.shouldUseAnimation)
        setVolumeIconsTint(settingsManager.volumeIconColor)
        setBrightnessIconsTint(settingsManager.brightnessIconColor)
        setKeyboardIconsTint(settingsManager.keyboardIconColor)
    }

    var value: Float = 0.5
    var timerChangeValue: Timer?
    func showAnimation() {
        if timerChangeValue != nil {
            timerChangeValue?.invalidate()
        }
        timerChangeValue = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { (_) in
            let val = (self.value).truncatingRemainder(dividingBy: 1.0)
            self.volumeBar.progress = val
            self.brightnessBar.progress = val
            self.keyboardBar.progress = val
            self.value += 0.1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            self.timerChangeValue?.invalidate()
            self.timerChangeValue = nil
        }
    }

}
