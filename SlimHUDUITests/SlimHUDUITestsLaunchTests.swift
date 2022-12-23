//
//  SlimHUDUITestsLaunchTests.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 22/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class SlimHUDUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
    }
    
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
