//
//  SettingsUITests.swift
//  SettingsUITests
//
//  Created by Alex Perathoner on 22/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class SettingsUITest: SparkleUITests {
    var app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()

        if CommandLine.arguments.contains("-sparkle-will-alert") {
            SparkleUITests.waitForAlertAndClose(app: app, timeout: 7)
        }
    }
    
    func testOpenSettingsWindow() throws {
        let settingsWindow = openSettingsWindow()

        addScreenshot(window: settingsWindow, name: "Settings window")

        usleep(500000)
        XCTAssertTrue(app.windows.count >= 2)
    }
    
    func testCloseWindow() throws {
        
        // try closing with cmd + w
        let statusItem = UITestsUtils.getStatusItem(app: app)
        var settingsWindow = openSettingsWindow()
        
        settingsWindow.typeKey("w", modifierFlags: .command)
        
        XCTAssertFalse(settingsWindow.isHittable)
        
        // try closing with cmd + q
        settingsWindow = openSettingsWindow()
        
        settingsWindow.typeKey("w", modifierFlags: .command)
        
        XCTAssertFalse(settingsWindow.isHittable)
        // app should still be running
        XCTAssertTrue(statusItem.exists)
    }
    
    private func openSettingsWindow() -> XCUIElement {
        
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
