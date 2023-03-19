//
//  Displayer.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import Cocoa

class Displayer: HudsControllerInterface {
    private var settingsManager: SettingsManager = SettingsManager.getInstance()
    var positionManager: PositionManager
    private var volumeHud: Hud
    private var brightnessHud: Hud
    private var keyboardHud: Hud

    public var temporarelyEnableAllBars = false

    init(positionManager: PositionManager, volumeHud: Hud, brightnessHud: Hud, keyboardHud: Hud) {
        self.positionManager = positionManager
        self.volumeHud = volumeHud
        self.brightnessHud = brightnessHud
        self.keyboardHud = keyboardHud

        volumeHud.setIconImage(icon: IconManager.getStandardVolumeIcon(isMuted: VolumeManager.isMuted()))
        brightnessHud.setIconImage(icon: IconManager.getStandardBrightnessIcon())
        keyboardHud.setIconImage(icon: IconManager.getStandardKeyboardIcon())
    }

    func showVolumeHUD() {
        if !(settingsManager.enabledBars.volumeBar || temporarelyEnableAllBars) {
            return
        }
        let isMuted = VolumeManager.isMuted()
        volumeHud.setForegroundColor(color1: settingsManager.volumeDisabledColor,
                                     color2: settingsManager.volumeEnabledColor,
                                     basedOn: isMuted)
        let progress = VolumeManager.getOutputVolume()
        volumeHud.setProgress(progress: progress)
        volumeHud.setIconImage(icon: IconManager.getVolumeIcon(for: progress, isMuted: isMuted))
        volumeHud.show()
        brightnessHud.hide(animated: false)
        keyboardHud.hide(animated: false)
        volumeHud.dismiss(delay: 1.5)
    }

    func showBrightnessHUD() {
        if !(settingsManager.enabledBars.brightnessBar || temporarelyEnableAllBars) {
            return
        }
        // if the function is being called because the key has been pressed, the display's brightness
        //  hasn't completely changed yet (or not at all). So for the next half a second, we continously check its value.
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            do {
                let progress = try DisplayManager.getDisplayBrightness()
                self.brightnessHud.setProgress(progress: progress)
                self.brightnessHud.setIconImage(icon: IconManager.getBrightnessIcon(for: progress))
            } catch {
                self.brightnessHud.setProgress(progress: 0.5)
                NSLog("Failed to retrieve display brightness. See https://github.com/AlexPerathoner/SlimHUD/issues/60")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            timer.invalidate()
        }
        brightnessHud.show()
        volumeHud.hide(animated: false)
        keyboardHud.hide(animated: false)
        brightnessHud.dismiss(delay: 1.5)
    }
    func showKeyboardHUD() {
        if !(settingsManager.enabledBars.keyboardBar || temporarelyEnableAllBars) {
            return
        }
        // if the function is being called because the key has been pressed, the keyboard's brightness
        //  hasn't completely changed yet (or not at all). So for the next half a second, we continously check its value.
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            do {
                let progress = try KeyboardManager.getKeyboardBrightness()
                self.keyboardHud.setProgress(progress: progress)
                self.keyboardHud.setIconImage(icon: IconManager.getKeyboardIcon(for: progress))
            } catch {
                self.keyboardHud.setProgress(progress: 0.5)
                NSLog("Failed to retrieve display brightness. See https://github.com/AlexPerathoner/SlimHUD/issues/60")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            timer.invalidate()
        }
        keyboardHud.show()
        volumeHud.hide(animated: false)
        brightnessHud.hide(animated: false)
        keyboardHud.dismiss(delay: 1.5)
    }

    func setColor(for bar: ProgressBar, _ disabled: Bool) {
        if disabled {
            bar.foreground = settingsManager.volumeDisabledColor
        } else {
            bar.foreground = settingsManager.volumeEnabledColor
        }
    }

    func updateShadows(enabled: Bool) {
        volumeHud.setShadow(enabled: enabled, shadowRadius: Constants.ShadowRadius, shadowType: .view, color: .black) // todo update, add parameters
        brightnessHud.setShadow(enabled: enabled, shadowRadius: Constants.ShadowRadius, shadowType: .view, color: .black)
        keyboardHud.setShadow(enabled: enabled, shadowRadius: Constants.ShadowRadius, shadowType: .view, color: .black)
    }

    func hideIcon(isHidden: Bool) {
        volumeHud.hideIcon(isHidden: isHidden)
        brightnessHud.hideIcon(isHidden: isHidden)
        keyboardHud.hideIcon(isHidden: isHidden)
    }

    func setVolumeBackgroundColor(color: NSColor) {
        volumeHud.setBackgroundColor(color: color)
    }
    func setBrightnessBackgroundColor(color: NSColor) {
        brightnessHud.setBackgroundColor(color: color)
    }
    func setKeyboardBackgroundColor(color: NSColor) {
        keyboardHud.setBackgroundColor(color: color)
    }
    func setVolumeEnabledColor(color: NSColor) {
        settingsManager.volumeEnabledColor = color
    }
    func setVolumeDisabledColor(color: NSColor) {
        settingsManager.volumeDisabledColor = color
    }
    func setBrightnessColor(color: NSColor) {
        brightnessHud.setForegroundColor(color: color)
    }
    func setKeyboardColor(color: NSColor) {
        keyboardHud.setForegroundColor(color: color)
    }

    func updateAllAttributes() {
        setHeight(height: CGFloat(settingsManager.barHeight))
        setThickness(thickness: CGFloat(settingsManager.barThickness))
        hideIcon(isHidden: !settingsManager.shouldShowIcons)
        updateShadows(enabled: settingsManager.shouldShowShadows)
        setVolumeBackgroundColor(color: settingsManager.volumeBackgroundColor)
        setBrightnessBackgroundColor(color: settingsManager.brightnessBackgroundColor)
        setKeyboardBackgroundColor(color: settingsManager.keyboardBackgroundColor)
        setVolumeEnabledColor(color: settingsManager.volumeEnabledColor)
        setVolumeDisabledColor(color: settingsManager.volumeDisabledColor)
        setBrightnessColor(color: settingsManager.brightnessColor)
        setKeyboardColor(color: settingsManager.keyboardColor)
        setAnimationStyle(animationStyle: settingsManager.animationStyle)
        if #available(OSX 10.14, *) {
            setVolumeIconsTint(settingsManager.volumeIconColor)
            setBrightnessIconsTint(settingsManager.brightnessIconColor)
            setKeyboardIconsTint(settingsManager.keyboardIconColor)
        }
    }

    func setAnimationStyle(animationStyle: AnimationStyle) {
        volumeHud.setAnimationStyle(animationStyle)
        brightnessHud.setAnimationStyle(animationStyle)
        keyboardHud.setAnimationStyle(animationStyle)
    }

    func setHeight(height: CGFloat) {
        volumeHud.setHeight(height: height)
        brightnessHud.setHeight(height: height)
        keyboardHud.setHeight(height: height)
        positionManager.setupHUDsPosition(isFullscreen: DisplayManager.isInFullscreenMode())
    }

    func setThickness(thickness: CGFloat) {
        volumeHud.setThickness(thickness: thickness, flatBar: settingsManager.flatBar)
        brightnessHud.setThickness(thickness: thickness, flatBar: settingsManager.flatBar)
        keyboardHud.setThickness(thickness: thickness, flatBar: settingsManager.flatBar)
        positionManager.setupHUDsPosition(isFullscreen: DisplayManager.isInFullscreenMode())
    }

    @available(OSX 10.14, *)
    func setVolumeIconsTint(_ color: NSColor) {
        volumeHud.setIconTint(color)
    }
    @available(OSX 10.14, *)
    func setBrightnessIconsTint(_ color: NSColor) {
        brightnessHud.setIconTint(color)
    }
    @available(OSX 10.14, *)
    func setKeyboardIconsTint(_ color: NSColor) {
        keyboardHud.setIconTint(color)
    }

    public func setVolumeProgress(_ progress: Float) {
        volumeHud.setProgress(progress: progress)
    }
    public func setBrightnessProgress(_ progress: Float) {
        brightnessHud.setProgress(progress: progress)
    }
    public func setKeyboardProgress(_ progress: Float) {
        keyboardHud.setProgress(progress: progress)
    }

}
