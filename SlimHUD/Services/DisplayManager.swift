//
//  DisplayManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation
import Cocoa

class DisplayManager {
    private init() {}
    
    static func getDisplayBrightness() -> Float {
        var brightness: float_t = 1
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"))
        
        IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
        IOObjectRelease(service)
        return brightness
    }
    
    static func getScreenInfo() -> (screenFrame: NSRect, xDockHeight: CGFloat, yDockHeight: CGFloat, menuBarThickness: CGFloat, dockPosition: Position) {
        let visibleFrame = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
        let screenFrame = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 0, height: 0)
        let yDockHeight: CGFloat = visibleFrame.minY
        let xDockHeight: CGFloat = screenFrame.width - visibleFrame.width
        var menuBarThickness: CGFloat = 0
        
        if((screenFrame.height - visibleFrame.height - yDockHeight) != 0) { //menu bar visible
            menuBarThickness = NSStatusBar.system.thickness
        }
        let dockPosition = Position(rawValue: (UserDefaults.standard.persistentDomain(forName: "com.apple.dock")!["orientation"] as! String) ?? "bottom")
        return (visibleFrame, xDockHeight, yDockHeight, menuBarThickness, dockPosition ?? .bottom)
    }
    
    /* Note the difference between NSScreen.main and NSScreen.screens[0]:
     * NSScreen.main is the "key" screen, where the currently frontmost window resides.
     * NSScreen.screens[0] is the screen which has a menu bar, and is chosen in the Preferences > monitor settings
    */
    static func getZeroScreen() -> NSScreen {
        return NSScreen.screens[0]
    }
    
    static func getScreenFrame() -> NSRect {
        return getZeroScreen().frame
    }
    
    static func getVisibleScreenFrame() -> NSRect {
        return getZeroScreen().visibleFrame
    }
    
    static func getMenuBarThickness() -> CGFloat {
        let screenFrame = getScreenFrame()
        let visibleFrame = getVisibleScreenFrame()
        var menuBarThickness: CGFloat = 0
        if((screenFrame.height - visibleFrame.height - visibleFrame.minY) != 0) { // menu bar visible
            menuBarThickness = NSStatusBar.system.thickness
        }
        return menuBarThickness
    }
    
    static func getDockHeight() -> (xDockHeight: CGFloat, yDockHeight: CGFloat) {
        let dockPosition = DisplayManager.getDockPosition() // TODO: use this
        let screenFrame = getScreenFrame()
        let visibleFrame = getVisibleScreenFrame()
        
        
        let yDockHeight: CGFloat = visibleFrame.minY
        let xDockHeight: CGFloat = screenFrame.width - visibleFrame.width
        
        return (xDockHeight, yDockHeight)
        
    }
//    case .left:
//        if(dockPosition == .right) {xDockHeight=0}
//        position = CGPoint(x: xDockHeight, y: (visibleFrame.height/2)-(viewSize.height/2) + yDockHeight)
//    case .right:
//        if(dockPosition == .left) {xDockHeight=0}
//        position = CGPoint(x: (NSScreen.screens[0].frame.width)-(viewSize.width)-shadowRadius-xDockHeight, y: (visibleFrame.height/2)-(viewSize.height/2) + yDockHeight)
//    case .bottom:
//        position = CGPoint(x: (screenFrame.width/2)-(viewSize.height/2), y: yDockHeight)
//    case .top:
//        position = CGPoint(x: (screenFrame.width/2)-(viewSize.height/2), y: (NSScreen.screens[0].frame.height)-(viewSize.width)-shadowRadius-menuBarThickness)
//    }
    
    static func getDockPosition() -> Position {
        var dockPosition: Position = .bottom
        if let rawPosition = UserDefaults.standard.persistentDomain(forName: "com.apple.dock")!["orientation"] as? String {
            if let actualPosition = Position(rawValue: rawPosition) {
                dockPosition = actualPosition
            } else {
                NSLog("Error while converting dock position. Rawvalue was: \(rawPosition).")
            }
        } else {
            NSLog("Error while retrieving dock position. Falling back to default: \(dockPosition).")
        }
        return dockPosition
    }

}
