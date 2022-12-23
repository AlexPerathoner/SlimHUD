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
        app.launchArguments = ["-uitesting"]
        app.launch()
        
        
        let menuBarsQuery = app.menuBars
        let statusItem = menuBarsQuery.children(matching: .statusItem).element(boundBy: 0)
        
        XCTAssert(statusItem.waitForExistence(timeout: 5))
        statusItem.click()

        let aboutMenuItem = menuBarsQuery.menuItems["About..."]
        XCTAssert(aboutMenuItem.waitForExistence(timeout: 5))
        aboutMenuItem.click()
        
        XCTAssertEqual(app.windows.count, 1)
        
        let aboutWindow = app.windows.matching(identifier: "SlimHUD").firstMatch
        let attachment = XCTAttachment(screenshot: aboutWindow.screenshot())
        attachment.name = "About screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
