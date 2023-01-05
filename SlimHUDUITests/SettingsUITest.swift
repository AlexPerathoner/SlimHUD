//
//  SettingsUITests.swift
//  SettingsUITests
//
//  Created by Alex Perathoner on 22/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

 import XCTest

 final class SettingsUITest: SparkleUITests {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testOpenSettingsWindow() throws {
        let app = XCUIApplication()
        app.launch()
        let settingsWindow = openSettingsWindow(app)

        addScreenshot(window: settingsWindow, name: "Settings window")

        usleep(500000)
        // preview HUD will also appear, so the windows count should be more than 1
        XCTAssertEqual(app.windows.count, 2)
    }

    func testCloseWindow() throws {
        let app = XCUIApplication()
        app.showCmdQAlert(false)
        app.launch()

        // try closing with cmd + w
        let statusItem = UITestsUtils.getStatusItem(app: app)
        var settingsWindow = openSettingsWindow(app)

        settingsWindow.typeKey("w", modifierFlags: .command)

        XCTAssertFalse(settingsWindow.isHittable)

        // relaunching as the app is now in background and doesn't accept test interaction
        
        app.launch()

        // try closing with cmd + q
        settingsWindow = openSettingsWindow(app)

        settingsWindow.typeKey("q", modifierFlags: .command)
        
        XCTAssertFalse(settingsWindow.isHittable)
        // app should still be running
        XCTAssertTrue(statusItem.exists)
    }

     private func openSettingsWindow(_ app: XCUIApplication) -> XCUIElement {

        let statusItem = SparkleUITests.getStatusItem(app: app)

        let preferencesMenuItem = statusItem.menuItems["Settings..."]

        let settingsWindow = app.windows.matching(identifier: "Settings").firstMatch

        statusItem.click()

        XCTAssert(preferencesMenuItem.waitForExistence(timeout: 5))
        preferencesMenuItem.click()

        XCTAssert(settingsWindow.waitForExistence(timeout: 5))

        return settingsWindow
    }
 }
