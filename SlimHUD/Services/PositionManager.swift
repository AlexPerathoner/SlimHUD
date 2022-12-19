//
//  PositionManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation

class PositionManager {
    var volumeHud: Hud
    var brightnessHud: Hud
    var keyboardHud: Hud
    
    init(volumeHud: Hud, brightnessHud: Hud, keyboardHud: Hud) {
        self.volumeHud = volumeHud
        self.brightnessHud = brightnessHud
        self.keyboardHud = keyboardHud
    }
    
    
    func setupHUDsPosition(_ isFullscreen: Bool) {
        volumeHud.hide(animated: false)
        brightnessHud.hide(animated: false)
        keyboardHud.hide(animated: false)
        
        let viewSize = volumeHud.view.frame
        
        var screenFrame = DisplayManager.getScreenFrame()
        var visibleFrame = DisplayManager.getVisibleScreenFrame()
        var xDockHeight: CGFloat = 0
        var yDockHeight: CGFloat = 0
        var menuBarThickness: CGFloat = 0
        var dockPosition = Position.bottom
        
        if(!isFullscreen) {
            visibleFrame = DisplayManager.getVisibleScreenFrame()
            (xDockHeight, yDockHeight) = DisplayManager.getDockHeight()
            menuBarThickness = DisplayManager.getMenuBarThickness()
            dockPosition = DisplayManager.getDockPosition()
        }
        
        // Todo
//        var position = calculateHUDsPositionOrigin(hudPosition: , dockPosition: <#T##Position#>, xDockHeight: <#T##CGFloat#>, yDockHeight: <#T##CGFloat#>, visibleFrame: <#T##NSRect#>, hudSize: <#T##NSRect#>, screenFrame: <#T##NSRect#>, shadowRadius: <#T##CGFloat#>, menuBarThickness: <#T##CGFloat#>)
//        //end of magic
//
//        for hud in [volumeHud, brightnessHud, keyboardHud] as [Hud] {
//            hud.position = position
//            hud.rotated = settingsController!.position
//        }
//
//        let rotated = settingsController!.position == .bottom || settingsController!.position == .top
//        for view in [volumeView, brightnessView, keyboardView] as [NSView?] {
//            view?.layer?.anchorPoint = CGPoint(x: 0, y: 0)
//            if(rotated) {
//                view?.frameCenterRotation = -90
//                view?.setFrameOrigin(.init(x: 0, y: viewSize.width))
//            } else {
//                view?.frameCenterRotation = 0
//                view?.setFrameOrigin(.init(x: 0, y: 0))
//            }
//
//            //needs a bit more space for displaying shadows...
//            if(settingsController!.position == .right) {
//                view?.setFrameOrigin(.init(x: shadowRadius, y: 0))
//            }
//            if(settingsController!.position == .top) {
//                view?.setFrameOrigin(.init(x: 0, y: shadowRadius+viewSize.width))
//            }
//        }
//
//        //rotating icons of views
//        if(settingsController!.shouldShowIcons) {
//            for image in [volumeView.image, brightnessView.image, keyboardView.image] as [NSImageView?] {
//                if(rotated) {
//                    while(image!.boundsRotation.truncatingRemainder(dividingBy: 360) != 90) {
//                        image!.rotate(byDegrees: 90)
//                    }
//                } else {
//                    while(image!.boundsRotation.truncatingRemainder(dividingBy: 360) != 0) {
//                        image!.rotate(byDegrees: 90)
//                    }
//                }
//            }
//        }
        
        
        NSLog("screenFrame is \(screenFrame) \(position)")
    }
    
    func calculateHUDsPositionOrigin(hudPosition: Position, dockPosition: Position, xDockHeight: CGFloat, yDockHeight: CGFloat, visibleFrame: NSRect, hudSize: NSRect, screenFrame: NSRect, shadowRadius: CGFloat, menuBarThickness: CGFloat) -> CGPoint {
        var position: CGPoint
        switch hudPosition {
        case .left:
            position = CGPoint(x: dockPosition == .right ? 0 : xDockHeight,
                               y: (visibleFrame.height/2) - (hudSize.height/2) + yDockHeight)
        case .right:
            position = CGPoint(x: screenFrame.width - hudSize.width - shadowRadius - (dockPosition == .left ? 0 : xDockHeight),
                               y: (visibleFrame.height/2) - (hudSize.height/2)  + yDockHeight)
        case .bottom:
            position = CGPoint(x: (screenFrame.width/2) - (hudSize.height/2),
                               y: yDockHeight)
        case .top:
            position = CGPoint(x: (screenFrame.width/2) - (hudSize.height/2),
                               y: screenFrame.height - hudSize.width - shadowRadius - menuBarThickness)
        }
        return position
    }
}
