//
//  UITestsUtils.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 05/01/23.
//

 import XCTest

 class UITestsUtils: XCTestCase {
    public func addScreenshot(window: XCUIElement, name: String) {
        let attachment = XCTAttachment(screenshot: window.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
 }
