//
//  SettingsUITests.swift
//  SettingsUITests
//
//  Created by Alex Perathoner on 22/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class SettingsUITest: XCTestCase {
    func testOpenSettingsWindow() throws {
        let app = XCUIApplication()
        app.launch()
        
        SparkleUITests.waitForAlertAndClose(app: app)
        
        let menuBarsQuery = app.menuBars
        let statusItem = menuBarsQuery.children(matching: .statusItem).element(boundBy: 0)
        
        XCTAssert(statusItem.waitForExistence(timeout: 5))
        statusItem.click()
        
        let preferencesMenuItem = menuBarsQuery.menuItems["Settings..."]
        
        XCTAssert(preferencesMenuItem.waitForExistence(timeout: 5))
        preferencesMenuItem.click()

        let settingsWindow = app.windows["Settings"]
        
        XCTAssert(settingsWindow.waitForExistence(timeout: 5))
        let attachment = XCTAttachment(screenshot: settingsWindow.screenshot())
        attachment.name = "Settings screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
