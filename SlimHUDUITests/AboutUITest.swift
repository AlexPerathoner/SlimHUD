//
//  AboutUITest.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 23/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class AboutUITests: SparkleUITests {
    func testOpenAboutWindow() throws {
        let app = XCUIApplication()
        app.launch()

        SparkleUITests.waitForAlertAndClose(app: app, timeout: 7)
        let statusItem = SparkleUITests.getStatusItem(app: app)

        let aboutMenuItem = statusItem.menuItems["About..."]

        let aboutWindow = app.windows.matching(identifier: "SlimHUD").firstMatch

        var timeout = SparkleUITests.TIMEOUT
        while !aboutWindow.exists && timeout > 0 {

            if !aboutMenuItem.exists || !aboutMenuItem.isHittable {
                statusItem.click()
                usleep(1500000)
            }
            if !aboutWindow.exists && aboutMenuItem.isHittable {
                aboutMenuItem.click()
                usleep(1500000)
            }
            timeout -= 1
        }

        XCTAssert(aboutWindow.waitForExistence(timeout: 5))

        addScreenshot(window: aboutWindow, name: "About window")
    }
}
