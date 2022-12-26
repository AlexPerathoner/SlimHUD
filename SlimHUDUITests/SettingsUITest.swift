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

        SparkleUITests.waitForAlertAndClose(app: app, timeout: 7)
        let statusItem = SparkleUITests.getStatusItem(app: app)

        let preferencesMenuItem = statusItem.menuItems["Settings..."]

        let settingsWindow = app.windows.matching(identifier: "Settings").firstMatch

        var timeout = SparkleUITests.TIMEOUT
        while !settingsWindow.exists && timeout > 0 {

            if !preferencesMenuItem.exists || !preferencesMenuItem.isHittable {
                statusItem.click()
                usleep(1500000)
            }
            if !settingsWindow.exists && preferencesMenuItem.isHittable {
                preferencesMenuItem.click()
                usleep(1500000)
            }
            timeout -= 1
        }

        XCTAssert(settingsWindow.waitForExistence(timeout: 5))

        addScreenshot(window: settingsWindow, name: "Settings window")

        XCTAssertEqual(app.windows.count, 2)
    }
}
