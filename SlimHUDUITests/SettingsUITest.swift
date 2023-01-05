//
//  SettingsUITests.swift
//  SettingsUITests
//
//  Created by Alex Perathoner on 22/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class SettingsUITest: SparkleUITests {
    func testOpenSettingsWindow() throws {
        let app = XCUIApplication()
        app.launch()

        if CommandLine.arguments.contains("-sparkle-will-alert") {
            SparkleUITests.waitForAlertAndClose(app: app, timeout: 7)
        }
        let statusItem = SparkleUITests.getStatusItem(app: app)

        let preferencesMenuItem = statusItem.menuItems["Settings..."]

        let settingsWindow = app.windows.matching(identifier: "Settings").firstMatch

        statusItem.click()

        XCTAssert(preferencesMenuItem.waitForExistence(timeout: 5))
        preferencesMenuItem.click()

        XCTAssert(settingsWindow.waitForExistence(timeout: 5))

        addScreenshot(window: settingsWindow, name: "Settings window")

        usleep(500000)
        XCTAssertTrue(app.windows.count >= 2)
    }
}
