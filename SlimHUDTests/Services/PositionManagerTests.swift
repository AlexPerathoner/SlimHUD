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

    // MARK: - menu bar visible

    func testCalculateHudsOriginLeft() throws {
        let hudPosition = Position.left
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = Constants.Screen.DockSize
        let visibleFrame = NSRect(x: 0, y: Constants.Screen.DockSize,
                                  width: Constants.Screen.Width,
                                  height: Constants.Screen.Height - Constants.Screen.DockSize - Constants.Screen.MenuBarSize)
        let hudSize = NSRect(x: 0, y: 0, width: Constants.Hud.ShortEdge, height: Constants.Hud.LongEdge)
        let isInFullscreen = false

        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.Screen.Frame,
                                                                      isInFullscreen: isInFullscreen)

        XCTAssertEqual(actualPoint, CGPoint(x: 0, y: 320))
    }

    func testCalculateHudsOriginLeftNoDock() throws {
        let hudPosition = Position.left
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = 0
        let visibleFrame = NSRect(x: 0, y: 0,
                                  width: Constants.Screen.Width,
                                  height: Constants.Screen.Height - Constants.Screen.MenuBarSize)
        let hudSize = NSRect(x: 0, y: 0, width: Constants.Hud.ShortEdge, height: Constants.Hud.LongEdge)
        let isInFullscreen = false

        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.Screen.Frame,
                                                                      isInFullscreen: isInFullscreen)

        XCTAssertEqual(actualPoint, CGPoint(x: 0, y: 289))
    }

    func testCalculateHudsOriginRight() throws {
        let hudPosition = Position.right
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = Constants.Screen.DockSize
        let visibleFrame = NSRect(x: 0, y: Constants.Screen.DockSize,
                                  width: Constants.Screen.Width,
                                  height: Constants.Screen.Height - Constants.Screen.MenuBarSize - Constants.Screen.DockSize)
        let hudSize = NSRect(x: 0, y: 0, width: Constants.Hud.ShortEdge, height: Constants.Hud.LongEdge)
        let isInFullscreen = false

        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.Screen.Frame,
                                                                      isInFullscreen: isInFullscreen)

        XCTAssertEqual(actualPoint, CGPoint(x: 1373, y: 320))
    }

    func testCalculateHudsOriginRightNoDock() throws {
        let hudPosition = Position.right
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = 0
        let visibleFrame = NSRect(x: 0, y: 0,
                                  width: Constants.Screen.Width,
                                  height: Constants.Screen.Height - Constants.Screen.MenuBarSize)
        let hudSize = NSRect(x: 0, y: 0, width: Constants.Hud.ShortEdge, height: Constants.Hud.LongEdge)
        let isInFullscreen = false

        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.Screen.Frame,
                                                                      isInFullscreen: isInFullscreen)

        XCTAssertEqual(actualPoint, CGPoint(x: 1373, y: 289))
    }

    func testCalculateHudsOriginTopWithAndWithoutDock() throws {
        let hudPosition = Position.top
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        var yDockHeight: CGFloat = Constants.Screen.DockSize
        var visibleFrame = NSRect(x: 0, y: Constants.Screen.DockSize,
                                  width: Constants.Screen.Width,
                                  height: Constants.Screen.Height - Constants.Screen.MenuBarSize - Constants.Screen.DockSize)
        let hudSize = NSRect(x: 0, y: 0, width: Constants.Hud.ShortEdge, height: Constants.Hud.LongEdge)
        let isInFullscreen = false

        let actualPoint1 = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.Screen.Frame,
                                                                      isInFullscreen: isInFullscreen)

        XCTAssertEqual(actualPoint1, CGPoint(x: 571.5, y: 811))

        yDockHeight = 0
        visibleFrame = NSRect(x: 0, y: 0,
                              width: Constants.Screen.Width,
                              height: Constants.Screen.Height - Constants.Screen.MenuBarSize)

        let actualPoint2 = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.Screen.Frame,
                                                                      isInFullscreen: isInFullscreen)

        XCTAssertEqual(actualPoint1, actualPoint2)
    }

    func testCalculateHudsOriginBottom() throws {
        let hudPosition = Position.bottom
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = Constants.Screen.DockSize
        let visibleFrame = NSRect(x: 0, y: Constants.Screen.DockSize,
                                  width: Constants.Screen.Width,
                                  height: Constants.Screen.Height - Constants.Screen.MenuBarSize)
        let hudSize = NSRect(x: 0, y: 0, width: Constants.Hud.ShortEdge, height: Constants.Hud.LongEdge)
        let isInFullscreen = false

        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.Screen.Frame,
                                                                      isInFullscreen: isInFullscreen)

        XCTAssertEqual(actualPoint, CGPoint(x: 571.5, y: Constants.Screen.DockSize))
    }

    func testCalculateHudsOriginBottomNoDock() throws {
        let hudPosition = Position.bottom
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = 0
        let visibleFrame = NSRect(x: 0, y: 0,
                                  width: Constants.Screen.Width,
                                  height: Constants.Screen.Height - Constants.Screen.MenuBarSize - Constants.Screen.DockSize)
        let hudSize = NSRect(x: 0, y: 0, width: Constants.Hud.ShortEdge, height: Constants.Hud.LongEdge)
        let isInFullscreen = false

        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: Constants.Screen.Frame,
                                                                      isInFullscreen: isInFullscreen)

        XCTAssertEqual(actualPoint, CGPoint(x: 571.5, y: 0))
    }

    // MARK: - menu bar not visible

}
