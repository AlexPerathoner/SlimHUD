//
//  HudsControllerInterface.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

protocol HudsControllerInterface: AnyObject {
    func updateShadows(enabled: Bool)
    func hideIcon(isHidden: Bool)
    func setVolumeBackgroundColor(color: NSColor)
    func setBrightnessBackgroundColor(color: NSColor)
    func setKeyboardBackgroundColor(color: NSColor)
    func setVolumeEnabledColor(color: NSColor)
    func setVolumeDisabledColor(color: NSColor)
    func setBrightnessColor(color: NSColor)
    func setKeyboardColor(color: NSColor)
    func setHeight(height: CGFloat)
    func setThickness(thickness: CGFloat)
    func setAnimationStyle(animationStyle: AnimationStyle)
    @available(OSX 10.14, *)
    func setVolumeIconsTint(_ color: NSColor)
    @available(OSX 10.14, *)
    func setBrightnessIconsTint(_ color: NSColor)
    @available(OSX 10.14, *)
    func setKeyboardIconsTint(_ color: NSColor)
    var positionManager: PositionManager { get }
}
