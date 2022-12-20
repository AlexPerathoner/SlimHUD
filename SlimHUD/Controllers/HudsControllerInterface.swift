//
//  SettingsControllerDelegate.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 17/08/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

protocol HudsControllerInterface: AnyObject {
    func updateShadows(enabled: Bool)
    func updateIcons(isHidden: Bool)
    func setupDefaultBarsColors()
    func setBackgroundColor(color: NSColor)
    func setVolumeEnabledColor(color: NSColor)
    func setVolumeDisabledColor(color: NSColor)
    func setBrightnessColor(color: NSColor)
    func setKeyboardColor(color: NSColor)
    func setHeight(height: CGFloat)
    func setThickness(thickness: CGFloat)
    func setShouldUseAnimation(shouldUseAnimation: Bool)
    @available(OSX 10.14, *)
    func setVolumeIconsTint(_ color: NSColor)
    @available(OSX 10.14, *)
    func setBrightnessIconsTint(_ color: NSColor)
    @available(OSX 10.14, *)
    func setKeyboardIconsTint(_ color: NSColor)
    @available(OSX 10.14, *)
    func setupDefaultIconsColors()
    var positionManager: PositionManager { get }
}
