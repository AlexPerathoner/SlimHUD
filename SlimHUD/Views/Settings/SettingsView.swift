//
//  SettingsView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
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
    
    @available(OSX 10.14, *)
    func setupDefaultIconsColors() {
        settingsManager.volumeIconColor = .white
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
        if #available(OSX 10.14, *) {
            setVolumeIconsTint(settingsManager.volumeIconColor, enabled: true)
        }
    }

    func setVolumeDisabledColor(color: NSColor) {
        volumeBar.foreground = color
        if #available(OSX 10.14, *) {
            setVolumeIconsTint(settingsManager.volumeIconColor, enabled: false)
        }
    }

    func setBrightnessColor(color: NSColor) {
        brightnessBar.foreground = color
    }

    func setKeyboardColor(color: NSColor) {
        keyboardBar.foreground = color
    }

    // isn't showed in preview
    func setHeight(height: CGFloat) {}
    func setThickness(thickness: CGFloat) {
        setFlatBar(progressBar: volumeBar, thickness: 7)
        setFlatBar(progressBar: brightnessBar, thickness: 7)
        setFlatBar(progressBar: keyboardBar, thickness: 7)
    }
    private func setFlatBar(progressBar: ProgressBar, thickness: CGFloat) {
        if settingsManager.flatBar {
            progressBar.progressLayer.cornerRadius = 0
        } else {
            progressBar.progressLayer.cornerRadius = thickness/2
        }
    }

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
    
    // FIXME: changing icons tint in preview only works if instantiation AND tinting are called twice
    @available(OSX 10.14, *)
    func setVolumeIconsTint(_ color: NSColor, enabled: Bool) {
        if(enabled) {
            volumeImage.image = NSImage(named: NSImage.VolumeImageFileName)
        } else {
            volumeImage.image = NSImage(named: NSImage.NoVolumeImageFileName)
        }
        volumeImage.image = volumeImage.image?.tint(with: color)
        if(enabled) {
            volumeImage.image = NSImage(named: NSImage.VolumeImageFileName)
        } else {
            volumeImage.image = NSImage(named: NSImage.NoVolumeImageFileName)
        }
        volumeImage.image = volumeImage.image?.tint(with: color)
    }
    @available(OSX 10.14, *)
    func setVolumeIconsTint(_ color: NSColor) {
        setVolumeIconsTint(settingsManager.volumeIconColor, enabled: true)
    }
    @available(OSX 10.14, *)
    func setBrightnessIconsTint(_ color: NSColor) {
        brightnessImage.image = NSImage(named: NSImage.BrightnessImageFileName)
        brightnessImage.image = brightnessImage.image?.tint(with: color)
        brightnessImage.image = NSImage(named: NSImage.BrightnessImageFileName)
        brightnessImage.image = brightnessImage.image?.tint(with: color)
    }
    @available(OSX 10.14, *)
    func setKeyboardIconsTint(_ color: NSColor) {
        keyboardImage.image = NSImage(named: NSImage.KeyboardImageFileName)
        keyboardImage.image = keyboardImage.image?.tint(with: color)
        keyboardImage.image = NSImage(named: NSImage.KeyboardImageFileName)
        keyboardImage.image = keyboardImage.image?.tint(with: color)
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
        
        if #available(OSX 10.14, *) {
            setVolumeIconsTint(settingsManager.volumeIconColor)
            setBrightnessIconsTint(settingsManager.brightnessIconColor)
            setKeyboardIconsTint(settingsManager.keyboardIconColor)
        }
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
