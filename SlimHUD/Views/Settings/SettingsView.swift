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

    @IBOutlet weak var volumeView: BarView!
    @IBOutlet weak var brightnessView: BarView!
    @IBOutlet weak var keyboardView: BarView!

    @IBOutlet weak var volumeBar: ProgressBar!
    @IBOutlet weak var brightnessBar: ProgressBar!
    @IBOutlet weak var keyboardBar: ProgressBar!

    @IBOutlet weak var volumeImage: NSImageView!
    @IBOutlet weak var brightnessImage: NSImageView!
    @IBOutlet weak var keyboardImage: NSImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        volumeView.setBar(bar: volumeBar)
        brightnessView.setBar(bar: brightnessBar)
        keyboardView.setBar(bar: keyboardBar)
        volumeView.setIconImageView(icon: volumeImage)
        brightnessView.setIconImageView(icon: brightnessImage)
        keyboardView.setIconImageView(icon: keyboardImage)

        volumeHud.setBarView(barView: volumeView)
        brightnessHud.setBarView(barView: brightnessView)
        keyboardHud.setBarView(barView: keyboardView)
        updateAllAttributes()
    }

    func updateShadows(enabled: Bool) {
        volumeHud.setShadow(enabled, 20)
        brightnessHud.setShadow(enabled, 20)
        keyboardHud.setShadow(enabled, 20)
    }

    func hideIcon(isHidden: Bool) {
        volumeHud.hideIcon(isHidden: isHidden)
        brightnessHud.hideIcon(isHidden: isHidden)
        keyboardHud.hideIcon(isHidden: isHidden)
    }

    func setupDefaultBarsColors() {
        volumeHud.setForegroundColor(color: DefaultColors.Blue)
        brightnessHud.setForegroundColor(color: DefaultColors.Yellow)
        keyboardHud.setForegroundColor(color: DefaultColors.Azure)
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
        volumeHud.setBackgroundColor(color: color)
        brightnessHud.setBackgroundColor(color: color)
        keyboardHud.setBackgroundColor(color: color)
    }

    func setVolumeEnabledColor(color: NSColor) {
        volumeHud.setForegroundColor(color: color)
        if #available(OSX 10.14, *) {
            setVolumeIconsTint(settingsManager.volumeIconColor, enabled: true)
        }
    }

    func setVolumeDisabledColor(color: NSColor) {
        volumeHud.setForegroundColor(color: color)
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

    // isn't shown in preview
    func setHeight(height: CGFloat) {}
    func setThickness(thickness: CGFloat) {
        volumeHud.setThickness(thickness: 7, flatBar: settingsManager.flatBar)
        brightnessHud.setThickness(thickness: 7, flatBar: settingsManager.flatBar)
        keyboardHud.setThickness(thickness: 7, flatBar: settingsManager.flatBar)
    }
    
    func setAnimationStyle(animationStyle: AnimationStyle) {
        volumeHud.setAnimationStyle(animationStyle)
        brightnessHud.setAnimationStyle(animationStyle)
        keyboardHud.setAnimationStyle(animationStyle)
        showAnimation()
    }

    var enabledBars: EnabledBars = EnabledBars(volumeBar: true, brightnessBar: true, keyboardBar: true) {
        didSet {
            volumeView.isHidden = !enabledBars.volumeBar
            brightnessView.isHidden = !enabledBars.brightnessBar
            keyboardView.isHidden = !enabledBars.keyboardBar
        }
    }

    @available(OSX 10.14, *)
    func setVolumeIconsTint(_ color: NSColor, enabled: Bool) {
        volumeHud.setIconImage(icon: IconManager.getStandardVolumeIcon(isMuted: enabled))
        volumeHud.setIconTint(color)
    }
    @available(OSX 10.14, *)
    func setVolumeIconsTint(_ color: NSColor) {
        setVolumeIconsTint(settingsManager.volumeIconColor, enabled: true)
    }
    @available(OSX 10.14, *)
    func setBrightnessIconsTint(_ color: NSColor) {
        brightnessHud.setIconImage(icon: IconManager.getStandardBrightnessIcon())
        brightnessHud.setIconTint(color)
    }
    @available(OSX 10.14, *)
    func setKeyboardIconsTint(_ color: NSColor) {
        keyboardHud.setIconImage(icon: IconManager.getStandardKeyboardIcon())
        keyboardHud.setIconTint(color)
    }

    func updateAllAttributes() {
        enabledBars = settingsManager.enabledBars
        hideIcon(isHidden: !(settingsManager.shouldShowIcons))
        updateShadows(enabled: settingsManager.shouldShowShadows)
        setBackgroundColor(color: settingsManager.backgroundColor)
        setVolumeDisabledColor(color: settingsManager.volumeDisabledColor)
        setVolumeEnabledColor(color: settingsManager.volumeEnabledColor)
        setBrightnessColor(color: settingsManager.brightnessColor)
        setKeyboardColor(color: settingsManager.keyboardColor)
        setAnimationStyle(animationStyle: settingsManager.animationStyle)

        if #available(OSX 10.14, *) {
            setVolumeIconsTint(settingsManager.volumeIconColor)
            setBrightnessIconsTint(settingsManager.brightnessIconColor)
            setKeyboardIconsTint(settingsManager.keyboardIconColor)
        }
    }
    
    var previewTimer: Timer?

    func showAnimation() {
        var value: Float = 0.5
        
        if previewTimer != nil {
            previewTimer?.invalidate()
        }
        
        previewTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
            let progress = value.truncatingRemainder(dividingBy: 1.0)
            
            self.volumeHud.setProgress(progress: progress)
            self.brightnessHud.setProgress(progress: progress)
            self.keyboardHud.setProgress(progress: progress)
            
            self.volumeHud.setIconImage(icon: IconManager.getVolumeIcon(for: progress, isMuted: false))
            self.brightnessHud.setIconImage(icon: IconManager.getBrightnessIcon(for: progress))
            self.keyboardHud.setIconImage(icon: IconManager.getKeyboardIcon(for: progress))
            
            value += 0.1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 7.0) {
            self.previewTimer?.invalidate()
            self.previewTimer = nil
        }
    }

}
