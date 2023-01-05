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

        if CommandLine.arguments.contains("-sparkle-will-alert") {
            SparkleUITests.waitForAlertAndClose(app: app, timeout: 7)
        }
        let aboutWindow = openAboutWindow(app: app)
        
        addScreenshot(window: aboutWindow, name: "About window")
    }
    
    func openAboutWindow(app: XCUIApplication) -> XCUIElement {
        
        let statusItem = UITestsUtils.getStatusItem(app: app)

        let aboutMenuItem = statusItem.menuItems["About..."]

        let aboutWindow = app.windows.matching(identifier: "SlimHUD").firstMatch

        statusItem.click()

        XCTAssert(aboutMenuItem.waitForExistence(timeout: 5))
        aboutMenuItem.click()
        
        XCTAssert(aboutWindow.waitForExistence(timeout: 5))
        
        return aboutWindow
    }
    
    func testCloseWindow() throws {
        let app = XCUIApplication()
        app.launch()
        
        // try closing with cmd + w
        let statusItem = UITestsUtils.getStatusItem(app: app)
        var aboutWindow = openAboutWindow(app: app)
        
        aboutWindow.typeKey("w", modifierFlags: .command)
        
        XCTAssertFalse(aboutWindow.isHittable)
        
        // try closing with cmd + q
        aboutWindow = openAboutWindow(app: app)
        
        aboutWindow.typeKey("w", modifierFlags: .command)
        
        XCTAssertFalse(aboutWindow.isHittable)
        // app should still be running
        XCTAssertTrue(statusItem.exists)
    }
}
