//
//  AboutUITest.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 23/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class AboutUITests: SparkleUITests {
    var app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()

        if CommandLine.arguments.contains("-sparkle-will-alert") {
            SparkleUITests.waitForAlertAndClose(app: app, timeout: 7)
        }
    }

    func testOpenAboutWindow() throws {
        let aboutWindow = openAboutWindow()

        addScreenshot(window: aboutWindow, name: "About window")
    }

    func testCloseWindow() throws {

        // try closing with cmd + w
        let statusItem = UITestsUtils.getStatusItem(app: app)
        var aboutWindow = openAboutWindow()

        aboutWindow.typeKey("w", modifierFlags: .command)

        XCTAssertFalse(aboutWindow.isHittable)

        // try closing with cmd + q
        aboutWindow = openAboutWindow()

        aboutWindow.typeKey("w", modifierFlags: .command)

        XCTAssertFalse(aboutWindow.isHittable)
        // app should still be running
        XCTAssertTrue(statusItem.exists)
    }

    private func openAboutWindow() -> XCUIElement {

        let statusItem = UITestsUtils.getStatusItem(app: app)

        let aboutMenuItem = statusItem.menuItems["About..."]

        let aboutWindow = app.windows.matching(identifier: "SlimHUD").firstMatch

        statusItem.click()

        XCTAssert(aboutMenuItem.waitForExistence(timeout: 5))
        aboutMenuItem.click()

        XCTAssert(aboutWindow.waitForExistence(timeout: 5))

        return aboutWindow
    }

}
