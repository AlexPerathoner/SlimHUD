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
        
        let settingsWindow = openSettingsWindow(app: app)

        addScreenshot(window: settingsWindow, name: "Settings window")

        usleep(500000)
        XCTAssertTrue(app.windows.count >= 2)
    }
    
    func openSettingsWindow(app: XCUIApplication) -> XCUIElement {
        
        let statusItem = SparkleUITests.getStatusItem(app: app)

        let preferencesMenuItem = statusItem.menuItems["Settings..."]

        let settingsWindow = app.windows.matching(identifier: "Settings").firstMatch

        statusItem.click()

        XCTAssert(preferencesMenuItem.waitForExistence(timeout: 5))
        preferencesMenuItem.click()

        XCTAssert(settingsWindow.waitForExistence(timeout: 5))
        
        return settingsWindow
    }
    
    func testCloseWindow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // try closing with cmd + w
        let statusItem = UITestsUtils.getStatusItem(app: app)
        var settingsWindow = openSettingsWindow(app: app)
        
        settingsWindow.typeKey("w", modifierFlags: .command)
        
        XCTAssertFalse(settingsWindow.isHittable)
        
        // try closing with cmd + q
        settingsWindow = openSettingsWindow(app: app)
        
        settingsWindow.typeKey("w", modifierFlags: .command)
        
        XCTAssertFalse(settingsWindow.isHittable)
        // app should still be running
        XCTAssertTrue(statusItem.exists)
    }
}
