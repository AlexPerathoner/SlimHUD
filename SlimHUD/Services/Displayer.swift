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

        let volumeIcon = getIcon(hud: volumeHud)
        let brightnessIcon = getIcon(hud: brightnessHud)
        let keyboardIcon = getIcon(hud: keyboardHud)
        volumeIcon.image = NSImage(named: NSImage.VolumeImageFileName)
        brightnessIcon.image = NSImage(named: NSImage.BrightnessImageFileName)
        keyboardIcon.image = NSImage(named: NSImage.KeyboardImageFileName)
        setIconsAnchorPointAndWantsLayer(icon: volumeIcon)
        setIconsAnchorPointAndWantsLayer(icon: brightnessIcon)
        setIconsAnchorPointAndWantsLayer(icon: keyboardIcon)
    }

    private func setIconsAnchorPointAndWantsLayer(icon: NSImageView) {
        icon.wantsLayer = true
        icon.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    private func getBarView(hud: Hud) -> BarView { // todo should find way to change type of attribute inside of Hud
        // swiftlint:disable:next force_cast
        return hud.view as! BarView
    }

    private func getProgressBar(hud: Hud) -> ProgressBar {
        return getBarView(hud: hud).bar
    }
    private func getIcon(hud: Hud) -> NSImageView {
        return getBarView(hud: hud).image
    }

    func showVolumeHUD() {
        if !settingsManager.enabledBars.volumeBar {return}
        let muted = VolumeManager.isMuted()
        let volumeView = getBarView(hud: volumeHud)
        setColor(for: volumeView.bar!, muted)
        volumeView.bar!.progress = VolumeManager.getOutputVolume()

        if muted {
            volumeView.image!.image = NSImage(named: NSImage.NoVolumeImageFileName)
        } else {
            volumeView.image!.image = NSImage(named: NSImage.VolumeImageFileName)
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
                self.getProgressBar(hud: self.brightnessHud).progress = try DisplayManager.getDisplayBrightness()
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
                self.getProgressBar(hud: self.keyboardHud).progress = try KeyboardManager.getKeyboardBrightness()
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

    func updateAnimation(shouldUseAnimation: Bool) {
        volumeHud.animated = shouldUseAnimation
        brightnessHud.animated = shouldUseAnimation
        keyboardHud.animated = shouldUseAnimation

        getProgressBar(hud: volumeHud).setupAnimation(animated: shouldUseAnimation)
        getProgressBar(hud: brightnessHud).setupAnimation(animated: shouldUseAnimation)
        getProgressBar(hud: keyboardHud).setupAnimation(animated: shouldUseAnimation)
    }

    func updateShadows(enabled: Bool) {
        getBarView(hud: volumeHud).setupShadow(enabled, Constants.ShadowRadius)
        getBarView(hud: brightnessHud).setupShadow(enabled, Constants.ShadowRadius)
        getBarView(hud: keyboardHud).setupShadow(enabled, Constants.ShadowRadius)
    }

    func updateIcons(isHidden: Bool) {
        getIcon(hud: volumeHud).isHidden = isHidden
        getIcon(hud: brightnessHud).isHidden = isHidden
        getIcon(hud: keyboardHud).isHidden = isHidden
    }

    func setupDefaultBarsColors() {
        getProgressBar(hud: volumeHud).foreground = DefaultColors.Blue
        getProgressBar(hud: brightnessHud).foreground = DefaultColors.Yellow
        getProgressBar(hud: keyboardHud).foreground = DefaultColors.Azure
        setBrightnessColor(color: DefaultColors.Yellow)
        setVolumeEnabledColor(color: DefaultColors.Blue)
        setVolumeDisabledColor(color: DefaultColors.Gray)
        setBackgroundColor(color: DefaultColors.DarkGray)
    }

    @available(OSX 10.14, *)
    func setupDefaultIconsColors() {
        setVolumeIconsTint(.white)
        setBrightnessIconsTint(.white)
        setKeyboardIconsTint(.white)
    }

    func setBackgroundColor(color: NSColor) {
        getProgressBar(hud: volumeHud).background = color
        getProgressBar(hud: brightnessHud).background = color
        getProgressBar(hud: keyboardHud).background = color
    }
    func setVolumeEnabledColor(color: NSColor) {
        settingsManager.volumeEnabledColor = color
    }
    func setVolumeDisabledColor(color: NSColor) {
        settingsManager.volumeDisabledColor = color
    }
    func setBrightnessColor(color: NSColor) {
        getProgressBar(hud: brightnessHud).foreground = color
    }
    func setKeyboardColor(color: NSColor) {
        getProgressBar(hud: keyboardHud).foreground = color
    }

    func updateAll() {
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
        setShouldUseAnimation(hud: volumeHud, shouldUseAnimation: shouldUseAnimation)
        setShouldUseAnimation(hud: brightnessHud, shouldUseAnimation: shouldUseAnimation)
        setShouldUseAnimation(hud: keyboardHud, shouldUseAnimation: shouldUseAnimation)
    }
    private func setShouldUseAnimation(hud: Hud, shouldUseAnimation: Bool) {
        hud.animated = shouldUseAnimation
        getProgressBar(hud: hud).setupAnimation(animated: shouldUseAnimation)
    }

    func setHeight(height: CGFloat) {
        setHeight(view: getBarView(hud: volumeHud), height: height)
        setHeight(view: getBarView(hud: brightnessHud), height: height)
        setHeight(view: getBarView(hud: keyboardHud), height: height)
        positionManager.setupHUDsPosition(DisplayManager.isInFullscreenMode())
    }
    private func setHeight(view: BarView, height: CGFloat) {
        view.setFrameSize(NSSize(width: view.frame.width, height: height + Constants.ShadowRadius * 3))
    }

    func setThickness(thickness: CGFloat) {
        setThickness(barView: getBarView(hud: volumeHud), thickness: thickness)
        setThickness(barView: getBarView(hud: brightnessHud), thickness: thickness)
        setThickness(barView: getBarView(hud: keyboardHud), thickness: thickness)
        positionManager.setupHUDsPosition(DisplayManager.isInFullscreenMode())
    }
    private func setThickness(barView: BarView, thickness: CGFloat) {
        barView.setFrameSize(NSSize(width: thickness + Constants.ShadowRadius * 2, height: barView.frame.height))
        barView.bar.progressLayer.frame.size.width = thickness // setting up inner layer
        if settingsManager.flatBar {
            barView.bar.progressLayer.cornerRadius = 0
        } else {
            barView.bar.progressLayer.cornerRadius = thickness/2
        }
        barView.bar.layer?.cornerRadius = thickness/2 // setting up outer layer
        barView.bar.frame.size.width = thickness
    }

    @available(OSX 10.14, *)
    func setVolumeIconsTint(_ color: NSColor) {
        getIcon(hud: volumeHud).contentTintColor = color
    }
    @available(OSX 10.14, *)
    func setBrightnessIconsTint(_ color: NSColor) {
        getIcon(hud: brightnessHud).contentTintColor = color
    }
    @available(OSX 10.14, *)
    func setKeyboardIconsTint(_ color: NSColor) {
        getIcon(hud: keyboardHud).contentTintColor = color
    }

}
