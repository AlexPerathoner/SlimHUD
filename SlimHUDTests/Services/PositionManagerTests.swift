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
    let screenFrame = NSRect(x: 0, y: 0, width: 1440, height: 900)

    func testCalculateHudsOriginStandard() throws {
        let hudPosition = Position.left
        let dockPosition = Position.bottom
        let xDockHeight: CGFloat = 0
        let yDockHeight: CGFloat = 62
        let visibleFrame = NSRect(x: 0, y: 62, width: 1440, height: 813)
        let hudSize = NSRect(x: 0, y: 0, width: 47, height: 297)
        let isInFullscreen = false

        let actualPoint = PositionManager.calculateHUDsOriginPosition(hudPosition: hudPosition, dockPosition: dockPosition,
                                                                      xDockHeight: xDockHeight, yDockHeight: yDockHeight,
                                                                      visibleFrame: visibleFrame, hudSize: hudSize, screenFrame: screenFrame,
                                                                      isInFullscreen: isInFullscreen)

        XCTAssertEqual(actualPoint, CGPoint(x: 0, y: 320))
    }

}
