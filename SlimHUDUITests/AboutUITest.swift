//
//  AboutUITest.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 23/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//


import XCTest

final class AboutUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    
    func testAppInMenuBar() throws {
        
        let menuBarsQuery = app.menuBars
        let statusItem = menuBarsQuery.children(matching: .statusItem).element(boundBy: 0)
        
        XCTAssert(statusItem.waitForExistence(timeout: 5))
        
        let actualStatusItemScreenshot = statusItem.screenshot()
        let attachment = XCTAttachment(screenshot: actualStatusItemScreenshot)
        attachment.name = "Status Item screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testOpenAboutWindow() throws {
        
        let menuBarsQuery = app.menuBars
        let statusItem = menuBarsQuery.children(matching: .statusItem).element(boundBy: 0)
        
        XCTAssert(statusItem.waitForExistence(timeout: 5))
        statusItem.click()

        let aboutMenuItem = menuBarsQuery.menuItems["About..."]
        XCTAssert(aboutMenuItem.waitForExistence(timeout: 5))
        aboutMenuItem.click()
        
        let aboutWindow = app.windows.matching(identifier: "SlimHUD").firstMatch
        
        XCTAssert(aboutWindow.waitForExistence(timeout: 5))
        
        let attachment = XCTAttachment(screenshot: aboutWindow.screenshot())
        attachment.name = "About screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
