//
//  SlimHUDUITestsLaunchTests.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 22/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

 import XCTest

 final class SlimHUDUITestsLaunchTests: SparkleUITests {
    func testAppInMenuBar() throws {
        let app = XCUIApplication()
        app.launch()

        let menuBarsQuery = app.menuBars
        let statusItem = menuBarsQuery.children(matching: .statusItem).element(boundBy: 0)

        XCTAssert(statusItem.waitForExistence(timeout: 5))

        let actualStatusItemScreenshot = statusItem.screenshot()
        let attachment = XCTAttachment(screenshot: actualStatusItemScreenshot)
        attachment.name = "Status Item screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
 }
