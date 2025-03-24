//
//  UITestsUtils.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 05/01/23.
//

import XCTest

// swiftlint:disable identifier_name
class UITestsUtils: XCTestCase {
    public func addScreenshot(window: XCUIElement, name: String) {
        let attachment = XCTAttachment(screenshot: window.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    public func isVolumeHudVisible(app: XCUIApplication) -> Bool {
        return app.windows.containing(.image, identifier: "volume no").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "volume 0").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "volume 1").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "volume 2").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "volume 3").element.waitForExistence(timeout: 1)
    }

    public func isBrightnessHudVisible(app: XCUIApplication) -> Bool {
        return app.windows.containing(.image, identifier: "sun 0").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "sun 1").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "sun 2").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "sun 3").element.waitForExistence(timeout: 1)
    }

    public func isKeyboardHudVisible(app: XCUIApplication) -> Bool {
        return app.windows.containing(.image, identifier: "key 0").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "key 1").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "key 2").element.waitForExistence(timeout: 1)
            || app.windows.containing(.image, identifier: "key 3").element.waitForExistence(timeout: 1)
    }

    public func getWindowEdge(app: XCUIApplication) -> Position {
        let barFrame = findBarFrame(app)
        let screenFrame = getScreenSize(app)
        let x = barFrame.origin.x
        let y = barFrame.origin.y // starting from top: 0, to bottom: screenFrame.height
        if h(screenFrame: screenFrame, x: x, y: screenFrame.height-y) {
            if g(screenFrame: screenFrame, x: x, y: screenFrame.height-y) {
                return .left
            } else {
                return .bottom
            }
        } else {
            if g(screenFrame: screenFrame, x: x, y: screenFrame.height-y) {
                return .top
            } else {
                return .right
            }
        }
    }

    // -900x/1600 + 900 > y
    func h(screenFrame: CGRect, x: CGFloat, y: CGFloat) -> Bool {
        return -screenFrame.height * x / screenFrame.width + screenFrame.height > y
    }

    // 900x/1600 > y
    func g(screenFrame: CGRect, x: CGFloat, y: CGFloat) -> Bool {
        return screenFrame.height * x / screenFrame.width < y
    }

    let KEYS = ["volume no", "volume 0", "volume 1", "volume 2", "volume 3", "sun 0", "sun 1", "sun 2", "sun 3", "key 0", "key 1", "key 2", "key 3"]

    private func findBarFrame(_ app: XCUIApplication) -> CGRect {
        for key in KEYS where app.windows.containing(.image, identifier: key).children(matching: .any).allElementsBoundByIndex.count > 0 {
            return app.windows.containing(.image, identifier: key).children(matching: .any).element.frame
        }
        XCTFail("Could not find bar frame")
        return .null
    }

    private func getScreenSize(_ app: XCUIApplication) -> CGRect {
        for key in KEYS where app.windows.containing(.image, identifier: key).allElementsBoundByIndex.count > 0 {
            return app.windows.containing(.image, identifier: key).element.frame
        }
        XCTFail("Could not find bar frame")
        return .null
    }

    enum Position: String {
        case left
        case right
        case bottom
        case top
    }
}
