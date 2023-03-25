//
//  UITestsUtils.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 05/01/23.
//

import XCTest

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
}
