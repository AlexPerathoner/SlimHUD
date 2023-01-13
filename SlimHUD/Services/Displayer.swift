//
//  Displayer.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import Cocoa

class Displayer: HudsControllerInterface {
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

        volumeHud.setIconImage(icon: NSImage(named: NSImage.VolumeImageFileName)!)
        brightnessHud.setIconImage(icon: NSImage(named: NSImage.BrightnessImageFileName)!)
        keyboardHud.setIconImage(icon: NSImage(named: NSImage.KeyboardImageFileName)!)
    }

    func showVolumeHUD() {
        if !settingsManager.enabledBars.volumeBar {return}
        let muted = VolumeManager.isMuted()
        volumeHud.setForegroundColor(color1: settingsManager.volumeDisabledColor,
                                     color2: settingsManager.volumeEnabledColor,
                                     based_on: muted)
        volumeHud.setProgress(progress: VolumeManager.getOutputVolume())

        if muted {
            volumeHud.setIconImage(icon: NSImage(named: NSImage.NoVolumeImageFileName)!)
        } else {
            volumeHud.setIconImage(icon: NSImage(named: NSImage.VolumeImageFileName)!)
        }
        volumeHud.show()
        brightnessHud.hide(animated: false)
        keyboardHud.hide(animated: false)
        volumeHud.dismiss(delay: 1.5)
    }

    func showBrightnessHUD() {
        if !settingsManager.enabledBars.brightnessBar {return}
        // if the function is being called because the key has been pressed, the display's brightness
        //  hasn't completely changed yet (or not at all). So for the next half a second, we continously check its value.
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            do {
                self.brightnessHud.setProgress(progress: try DisplayManager.getDisplayBrightness())
            } catch {
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
        if !settingsManager.enabledBars.keyboardBar {return}
        // if the function is being called because the key has been pressed, the keyboard's brightness
        //  hasn't completely changed yet (or not at all). So for the next half a second, we continously check its value.
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            do {
                self.keyboardHud.setProgress(progress: try KeyboardManager.getKeyboardBrightness())
            } catch {
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
        volumeHud.setShadow(enabled, Constants.ShadowRadius)
        brightnessHud.setShadow(enabled, Constants.ShadowRadius)
        keyboardHud.setShadow(enabled, Constants.ShadowRadius)
    }

    func updateIcons(isHidden: Bool) {
        volumeHud.hideIcon(isHidden: isHidden)
        brightnessHud.hideIcon(isHidden: isHidden)
        keyboardHud.hideIcon(isHidden: isHidden)
    }

    func setupDefaultBarsColors() {
        setVolumeEnabledColor(color: DefaultColors.Blue)
        setVolumeDisabledColor(color: DefaultColors.Gray)
        setBrightnessColor(color: DefaultColors.Yellow)
        setKeyboardColor(color: DefaultColors.Azure)
        setBackgroundColor(color: DefaultColors.DarkGray)
    }

    @available(OSX 10.14, *)
    func setupDefaultIconsColors() {
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
        updateIcons(isHidden: !settingsManager.shouldShowIcons)
        updateShadows(enabled: settingsManager.shouldShowShadows)
        setBackgroundColor(color: settingsManager.backgroundColor)
        setVolumeEnabledColor(color: settingsManager.volumeEnabledColor)
        setVolumeDisabledColor(color: settingsManager.volumeDisabledColor)
        setBrightnessColor(color: settingsManager.brightnessColor)
        setKeyboardColor(color: settingsManager.keyboardColor)
        setShouldUseAnimation(shouldUseAnimation: settingsManager.shouldUseAnimation)
        if #available(OSX 10.14, *) {
            setVolumeIconsTint(settingsManager.volumeIconColor)
            setBrightnessIconsTint(settingsManager.brightnessIconColor)
            setKeyboardIconsTint(settingsManager.keyboardIconColor)
        }
    }

    func setShouldUseAnimation(shouldUseAnimation: Bool) {
        volumeHud.setShouldUseAnimation(shouldUseAnimation)
        brightnessHud.setShouldUseAnimation(shouldUseAnimation)
        keyboardHud.setShouldUseAnimation(shouldUseAnimation)
    }

    func setHeight(height: CGFloat) {
        volumeHud.setHeight(height: height)
        brightnessHud.setHeight(height: height)
        keyboardHud.setHeight(height: height)
        positionManager.setupHUDsPosition(DisplayManager.isInFullscreenMode())
    }

    func setThickness(thickness: CGFloat) {
        volumeHud.setThickness(thickness: thickness, flatBar: settingsManager.flatBar)
        brightnessHud.setThickness(thickness: thickness, flatBar: settingsManager.flatBar)
        keyboardHud.setThickness(thickness: thickness, flatBar: settingsManager.flatBar)
        positionManager.setupHUDsPosition(DisplayManager.isInFullscreenMode())
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

}
