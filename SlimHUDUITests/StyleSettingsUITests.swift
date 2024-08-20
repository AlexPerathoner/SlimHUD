//
//  StyleSettingsUITests.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 25/03/23.
//

import XCTest

final class StyleSettingsUITests: UITestsUtils {
    func testChangeValuesInShadowPopupRadiusInput() throws {
        let app = XCUIApplication()
        app.showSettings()
        app.launch()

        let settingsWindow = app.windows["Settings"]
        settingsWindow.typeKey("3", modifierFlags: .command)
        let checkBox = settingsWindow.children(matching: .checkBox).element(boundBy: 0)
        if checkBox.value as? Int == 1 {
            checkBox.click()
            XCTAssertFalse(isVolumeHudVisible(app: app))
            usleep(100000) // 0.1s
            checkBox.click()
            XCTAssertTrue(isVolumeHudVisible(app: app))
        } else {
            checkBox.click()
            XCTAssertTrue(isVolumeHudVisible(app: app))
            usleep(100000) // 0.1s
            checkBox.click()
            XCTAssertFalse(isVolumeHudVisible(app: app))
        }
    }
}
