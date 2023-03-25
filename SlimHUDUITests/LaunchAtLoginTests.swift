//
//  LaunchAtLoginTests.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 25/03/23.
//

import XCTest

final class LaunchAtLoginTests: XCTestCase {
    func testChangeValuesInShadowPopupRadiusInput() throws {
        let app = XCUIApplication()
        app.showSettings()
        app.launch()
        
        let checkBox = XCUIApplication().windows["Settings"].children(matching: .checkBox).element(boundBy: 0)
        checkBox.click()
        sleep(1)
        checkBox.click()
    }
}
