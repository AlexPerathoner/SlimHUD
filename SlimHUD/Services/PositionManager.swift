//
//  PositionManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import Cocoa

class PositionManager {
    var volumeHud: Hud
    var brightnessHud: Hud
    var keyboardHud: Hud
    let settingsManager = SettingsManager.getInstance()

    init(volumeHud: Hud, brightnessHud: Hud, keyboardHud: Hud) {
        self.volumeHud = volumeHud
        self.brightnessHud = brightnessHud
        self.keyboardHud = keyboardHud
    }

    func setupHUDsPosition(isFullscreen: Bool) {
        let barViewFrame = volumeHud.getFrame()

        let screenFrame = DisplayManager.getScreenFrame()
        let screenEdge = settingsManager.position
        var visibleFrame = DisplayManager.getVisibleScreenFrame()
        var xDockHeight: CGFloat = 0
        var yDockHeight: CGFloat = 0

        if !isFullscreen {
            visibleFrame = DisplayManager.getVisibleScreenFrame()
            (xDockHeight, yDockHeight) = DisplayManager.getDockHeight()
        }

        let originPosition = PositionManager.calculateHUDsOriginPosition(hudPosition: settingsManager.position,
                                                                         dockPosition: DisplayManager.getDockPosition(),
                                                                         xDockHeight: xDockHeight,
                                                                         yDockHeight: yDockHeight,
                                                                         visibleFrame: visibleFrame,
                                                                         barViewFrame: barViewFrame,
                                                                         screenFrame: screenFrame,
                                                                         isInFullscreen: isFullscreen)

        let isHudHorizontal = screenEdge == .bottom || screenEdge == .top

        setBarsOrientation(isHorizontal: isHudHorizontal)
        setHudsPosition(originPosition: originPosition, screenEdge: screenEdge)

        NSLog("screenFrame is \(screenFrame) \(originPosition)")
    }

    static func calculateHUDsOriginPosition(hudPosition: Position, dockPosition: Position,
                                            xDockHeight: CGFloat, yDockHeight: CGFloat,
                                            visibleFrame: NSRect, barViewFrame: NSRect, screenFrame: NSRect,
                                            isInFullscreen: Bool) -> CGPoint {
        var position: CGPoint
        switch hudPosition {
        case .left:
            position = CGPoint(x: dockPosition == .right ? 0 : xDockHeight,
                           y: (visibleFrame.height/2) - (barViewFrame.height/2) + yDockHeight)
        case .right:
            position = CGPoint(x: screenFrame.width - barViewFrame.width - (dockPosition == .left ? 0 : xDockHeight),
                           y: (visibleFrame.height/2) - (barViewFrame.height/2) + yDockHeight)
        case .bottom:
            position = CGPoint(x: (screenFrame.width/2) - (barViewFrame.height/2),
                               y: yDockHeight + barViewFrame.width)
        case .top:
            position = CGPoint(x: (screenFrame.width/2) - (barViewFrame.height/2),
                           y: screenFrame.height - (isInFullscreen ? 0 : DisplayManager.getMenuBarThickness()))
        }
        return position
    }

    private func setHudsPosition(originPosition: CGPoint, screenEdge: Position) {
        volumeHud.setPosition(originPosition: originPosition, screenEdge: screenEdge)
        brightnessHud.setPosition(originPosition: originPosition, screenEdge: screenEdge)
        keyboardHud.setPosition(originPosition: originPosition, screenEdge: screenEdge)
    }

    private func setBarsOrientation(isHorizontal: Bool) {
        volumeHud.setOrientation(isHorizontal: isHorizontal, position: settingsManager.position)
        brightnessHud.setOrientation(isHorizontal: isHorizontal, position: settingsManager.position)
        keyboardHud.setOrientation(isHorizontal: isHorizontal, position: settingsManager.position)
        
        resetPreviewIcons()
    }
    
    private func resetPreviewIcons() {
        /* FIXME: should be solved in a better way: rotating the bounds of the bar causes the icon's constraints to break.
                  a solution for this is to reset the bar's icon. AA
         */
        let volume = VolumeManager.getOutputVolume()
        volumeHud.setIconImage(icon: IconManager.getStandardKeyboardIcon())
        volumeHud.setIconImage(icon: IconManager.getVolumeIcon(for: volume, isMuted: VolumeManager.isMuted()))
        do {
            let brightness = try DisplayManager.getDisplayBrightness()
            brightnessHud.setIconImage(icon: IconManager.getStandardKeyboardIcon())
            brightnessHud.setIconImage(icon: IconManager.getBrightnessIcon(for: brightness))
        } catch {
            brightnessHud.setIconImage(icon: IconManager.getStandardKeyboardIcon())
            brightnessHud.setIconImage(icon: IconManager.getStandardBrightnessIcon())
        }
        do {
            let keyboard = try KeyboardManager.getKeyboardBrightness()
            keyboardHud.setIconImage(icon: IconManager.getStandardBrightnessIcon())
            keyboardHud.setIconImage(icon: IconManager.getKeyboardIcon(for: keyboard))
        } catch {
            keyboardHud.setIconImage(icon: IconManager.getStandardBrightnessIcon())
            keyboardHud.setIconImage(icon: IconManager.getStandardKeyboardIcon())
        }
    }
}
