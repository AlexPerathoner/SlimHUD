//
//  PositionManagerTests.swift
//  SlimHUDTests
//
//  Created by Alex Perathoner on 20/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest
@testable import SlimHUD

final class PositionManagerTests: XCTestCase {
    
    func testCalculateHudsOriginStandard() throws {
        let hudPosition = Position.left
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = Constants.DockSize
        let visibleFrame = NSRect(x: 0, y: Constants.DockSize,
                                  width: Constants.ScreenWidth,
                                  height: Constants.ScreenHeight - Constants.DockSize - Constants.MenuBarThickness)
        let hudSize = NSRect(x: 0, y: 0, width: 47, height: 297)
        let isInFullscreen = false
        
        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.ScreenFrame,
                                                                      isInFullscreen: isInFullscreen)
        
        XCTAssertEqual(actualPoint, CGPoint(x: 0, y: 320))
    }
    
    func testCalculateHudsOriginStandardNoDock() throws {
        let hudPosition = Position.left
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = 0
        let visibleFrame = NSRect(x: 0, y: 0, width: 1440, height: 875)
        let hudSize = NSRect(x: 0, y: 0, width: 47, height: 297)
        let isInFullscreen = false
        
        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.ScreenFrame,
                                                                      isInFullscreen: isInFullscreen)
        
        XCTAssertEqual(actualPoint, CGPoint(x: 0, y: 289))
    }
    
    func testCalculateHudsOriginStandardRight() throws {
        let hudPosition = Position.right
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = Constants.DockSize
        let visibleFrame = NSRect(x: 0, y: Constants.DockSize, width: 1440, height: 813)
        let hudSize = NSRect(x: 0, y: 0, width: 47, height: 297)
        let isInFullscreen = false
        
        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.ScreenFrame,
                                                                      isInFullscreen: isInFullscreen)
        
        XCTAssertEqual(actualPoint, CGPoint(x: 1373, y: 320))
    }
    
    func testCalculateHudsOriginStandardRightNoDock() throws {
        let hudPosition = Position.right
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = 0
        let visibleFrame = NSRect(x: 0, y: 0, width: 1440, height: 875)
        let hudSize = NSRect(x: 0, y: 0, width: 47, height: 297)
        let isInFullscreen = false
        
        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.ScreenFrame,
                                                                      isInFullscreen: isInFullscreen)
        
        XCTAssertEqual(actualPoint, CGPoint(x: 1373, y: 289))
    }
    
    func testCalculateHudsOriginStandardTopWithAndWithoutDock() throws {
        let hudPosition = Position.top
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        var yDockHeight: CGFloat = Constants.DockSize
        var visibleFrame = NSRect(x: 0, y: Constants.DockSize, width: 1440, height: 813)
        let hudSize = NSRect(x: 0, y: 0, width: 47, height: 297)
        let isInFullscreen = false
        
        let actualPoint1 = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.ScreenFrame,
                                                                      isInFullscreen: isInFullscreen)
        
        XCTAssertEqual(actualPoint1, CGPoint(x: 571.5, y: 811))
        
        
        yDockHeight = 0
        visibleFrame = NSRect(x: 0, y: 0, width: 1440, height: 875)
        
        let actualPoint2 = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.ScreenFrame,
                                                                      isInFullscreen: isInFullscreen)
        
        XCTAssertEqual(actualPoint1, actualPoint2)
    }
    
    func testCalculateHudsOriginStandardBottom() throws {
        let hudPosition = Position.bottom
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = Constants.DockSize
        let visibleFrame = NSRect(x: 0, y: Constants.DockSize, width: 1440, height: 875)
        let hudSize = NSRect(x: 0, y: 0, width: 47, height: 297)
        let isInFullscreen = false
        
        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.ScreenFrame,
                                                                      isInFullscreen: isInFullscreen)
        
        XCTAssertEqual(actualPoint, CGPoint(x: 571.5, y: Constants.DockSize))
    }
    
    func testCalculateHudsOriginStandardBottomNoDock() throws {
        let hudPosition = Position.bottom
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = 0
        let visibleFrame = NSRect(x: 0, y: 0, width: 1440, height: 813)
        let hudSize = NSRect(x: 0, y: 0, width: 47, height: 297)
        let isInFullscreen = false
        
        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.ScreenFrame,
                                                                      isInFullscreen: isInFullscreen)
        
        XCTAssertEqual(actualPoint, CGPoint(x: 571.5, y: 0))
    }
    
}
