//
//  HudAnimatorTests.swift
//  SlimHUDTests
//
//  Created by Alex Perathoner on 21/01/23.
//

import XCTest
@testable import SlimHUD

final class HudAnimatorTests: XCTestCase {

    func testLeft() {
        let hudPosition = Position.left
        let originPoint = CGPoint(x: 0, y: 320)

        let actualPoint = HudAnimator.getAnimationFrameOrigin(originPosition: originPoint, screenEdge: hudPosition)

        XCTAssertEqual(actualPoint, CGPoint(x: -Constants.Animation.Movement, y: 320))
    }

    func testBottom() {
        let hudPosition = Position.bottom
        let originPoint = CGPoint(x: 571.5, y: 0)

        let actualPoint = HudAnimator.getAnimationFrameOrigin(originPosition: originPoint, screenEdge: hudPosition)

        XCTAssertEqual(actualPoint, CGPoint(x: 571.5, y: -Constants.Animation.Movement))
    }

    func testTop() {
        let hudPosition = Position.top
        let originPoint = CGPoint(x: 571.5, y: 878)

        let actualPoint = HudAnimator.getAnimationFrameOrigin(originPosition: originPoint, screenEdge: hudPosition)

        XCTAssertEqual(actualPoint, CGPoint(x: 571.5, y: 878 + Constants.Animation.Movement))
    }

    func testRight() {
        let hudPosition = Position.right
        let originPoint = CGPoint(x: 1393, y: 320)

        let actualPoint = HudAnimator.getAnimationFrameOrigin(originPosition: originPoint, screenEdge: hudPosition)

        XCTAssertEqual(actualPoint, CGPoint(x: 1393 + Constants.Animation.Movement, y: 320))
    }

}
