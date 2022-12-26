//
//  SparkleUITest.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 23/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

class SparkleUITests: XCTestCase {
    static var TIMEOUT = 10

    static public func closeAlerts(app: XCUIApplication) -> Bool {
        var closedSomeDialogs = false
        while app.dialogs.count > 0 {
            app.dialogs.firstMatch.buttons.firstMatch.doubleClick()
            closedSomeDialogs = true
        }
        return closedSomeDialogs
    }

    static public func waitForAlertAndClose(app: XCUIApplication, timeout: Int) {
        var timeoutCountdown = timeout
        while !SparkleUITests.closeAlerts(app: app) && timeoutCountdown > 0 {
            sleep(1)
            timeoutCountdown -= 1
        }
    }

    static public func getStatusItem(app: XCUIApplication) -> XCUIElement {
        let menuBarsQuery = app.menuBars
        let statusItem = menuBarsQuery.children(matching: .statusItem).element(boundBy: 0)
        XCTAssert(statusItem.waitForExistence(timeout: 5))
        return statusItem
    }

    public func addScreenshot(window: XCUIElement, name: String) {
        let attachment = XCTAttachment(screenshot: window.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
