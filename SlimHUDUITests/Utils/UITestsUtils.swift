////
////  UITestsUtils.swift
////  SlimHUDUITests
////
////  Created by Alex Perathoner on 05/01/23.
////
//
//import XCTest
//
//class UITestsUtils: XCTestCase {
//    static public func getStatusItem(app: XCUIApplication) -> XCUIElement {
//        let menuBarsQuery = app.menuBars
//        let statusItem = menuBarsQuery.children(matching: .statusItem).element(boundBy: 0)
//        XCTAssert(statusItem.waitForExistence(timeout: 5))
//        return statusItem
//    }
//
//    public func addScreenshot(window: XCUIElement, name: String) {
//        let attachment = XCTAttachment(screenshot: window.screenshot())
//        attachment.name = name
//        attachment.lifetime = .keepAlways
//        add(attachment)
//    }
//}
