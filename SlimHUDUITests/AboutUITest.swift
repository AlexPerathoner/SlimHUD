//
//  AboutUITest.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 23/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class AboutUITests: SparkleUITests {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testOpenAboutWindow() throws {
        let app = XCUIApplication()
        app.launch()
        let aboutWindow = openAboutWindow(app)

        addScreenshot(window: aboutWindow, name: "About window")
    }

    func testCloseWindow() throws {
        let app = XCUIApplication()
        app.showCmdQAlert(false)
        app.launch()

        // try closing with cmd + w
        let statusItem = UITestsUtils.getStatusItem(app: app)
        var aboutWindow = openAboutWindow(app)

        aboutWindow.typeKey("w", modifierFlags: .command)

        XCTAssertFalse(aboutWindow.isHittable)

        // relaunching as the app is now in background and doesn't accept test interaction
        app.launch()

        // try closing with cmd + q
        aboutWindow = openAboutWindow(app)

        aboutWindow.typeKey("q", modifierFlags: .command)

        XCTAssertFalse(aboutWindow.isHittable)

        // app should still be running
        XCTAssertTrue(statusItem.exists)
    }

     func testCmdQCloseWindow() throws {
         let app = XCUIApplication()
         app.showCmdQAlert(true)
         app.launch()

         let statusItem = UITestsUtils.getStatusItem(app: app)
         var aboutWindow = openAboutWindow(app)

         aboutWindow.typeKey("q", modifierFlags: .command)

         // alert should have been opened, window should still be visible
         XCTAssertTrue(aboutWindow.isHittable)
         app/*@START_MENU_TOKEN@*/.buttons["OK"]/*[[".dialogs[\"alert\"].buttons[\"OK\"]",".buttons[\"OK\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()

         // after clicking ok all windows should have been closed
         XCTAssertFalse(aboutWindow.isHittable)

         aboutWindow = openAboutWindow(app)
         aboutWindow.typeKey("q", modifierFlags: .command)
         app.buttons["Quit now"].click()
         // app should have been closed
         XCTAssertFalse(statusItem.exists)

         app.launch()

         aboutWindow = openAboutWindow(app)
         aboutWindow.typeKey("q", modifierFlags: .command)
         app.buttons["Don't show again"].click()
         // all windows should have been closed
         XCTAssertFalse(aboutWindow.isHittable)

         aboutWindow = openAboutWindow(app)
         aboutWindow.typeKey("q", modifierFlags: .command)
         // alert shouldn't appear anymore, so the window closes immediately
         XCTAssertFalse(aboutWindow.isHittable)

         // app should still be running
         XCTAssertTrue(statusItem.exists)
     }

     private func openAboutWindow(_ app: XCUIApplication) -> XCUIElement {
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
