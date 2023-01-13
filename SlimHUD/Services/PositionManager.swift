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
        volumeHud.hide(animated: false)
        brightnessHud.hide(animated: false)
        keyboardHud.hide(animated: false)

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
                                                                         hudFrame: barViewFrame,
                                                                         screenFrame: screenFrame,
                                                                         isInFullscreen: isFullscreen)

        setHudsPosition(originPosition: originPosition, screenEdge: screenEdge)

        let isHudHorizontal = screenEdge == .bottom || screenEdge == .top

        // set bar views orientation
        setBarsOrientation(isHorizontal: isHudHorizontal)

        NSLog("screenFrame is \(screenFrame) \(originPosition)")
    }

    static func calculateHUDsOriginPosition(hudPosition: Position, dockPosition: Position,
                                            xDockHeight: CGFloat, yDockHeight: CGFloat,
                                            visibleFrame: NSRect, hudFrame: NSRect, screenFrame: NSRect,
                                            isInFullscreen: Bool) -> CGPoint {
        var position: CGPoint
        switch hudPosition {
        case .left:
            position = CGPoint(x: dockPosition == .right ? 0 : xDockHeight,
                               y: (visibleFrame.height/2) - (hudFrame.height/2) + yDockHeight)
        case .right:
            position = CGPoint(x: screenFrame.width - hudFrame.width - Constants.ShadowRadius - (dockPosition == .left ? 0 : xDockHeight),
                               y: (visibleFrame.height/2) - (hudFrame.height/2)  + yDockHeight)
        case .bottom:
            position = CGPoint(x: (screenFrame.width/2) - (hudFrame.height/2),
                               y: yDockHeight)
        case .top:
            position = CGPoint(x: (screenFrame.width/2) - (hudFrame.height/2),
                               y: screenFrame.height - hudFrame.width - Constants.ShadowRadius - (isInFullscreen ? 0 : DisplayManager.getMenuBarThickness()))
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
    }
}
