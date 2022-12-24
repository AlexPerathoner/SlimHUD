//
//  AboutUITest.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 23/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//


import XCTest

final class AboutUITests: XCTestCase {
    func testOpenAboutWindow() throws {
        let app = XCUIApplication()
        app.launch()
        
        SparkleUITests.waitForAlertAndClose(app: app, timeout: 7)
        
        let menuBarsQuery = app.menuBars
        let statusItem = menuBarsQuery.children(matching: .statusItem).element(boundBy: 0)
        
        XCTAssert(statusItem.waitForExistence(timeout: 5))
        statusItem.click()
        
        let aboutMenuItem = menuBarsQuery.menuItems["About..."]
        
        while(!aboutMenuItem.waitForExistence(timeout: 1)) {
            statusItem.click()
        }
        
        aboutMenuItem.click()
        
        let aboutWindow = app.windows.matching(identifier: "SlimHUD").firstMatch
        
        XCTAssert(aboutWindow.waitForExistence(timeout: 5))
        
        let attachment = XCTAttachment(screenshot: aboutWindow.screenshot())
        attachment.name = "About screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
