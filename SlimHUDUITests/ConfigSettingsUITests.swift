//
//  ConfigSettingsUITest.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 04/03/23.
//

import XCTest

final class ConfigSettingsUITest: SparkleUITests {
    let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.showSettings()
        app.launch()
    }

    func testHideStatusItem() throws {
        let checkBox = app.windows["Settings"].children(matching: .checkBox).element(boundBy: 2)

        checkBox.click()
        if checkBox.value as? Int == 0 {
            XCTAssertTrue(app.menuBars.element(boundBy: 1).waitForExistence(timeout: 1))
        } else {
            app.dialogs["alert"].typeText("\r")
            XCTAssertFalse(app.menuBars.element(boundBy: 1).waitForExistence(timeout: 1))
        }

        checkBox.click()
        if checkBox.value as? Int == 0 {
            XCTAssertTrue(app.menuBars.element(boundBy: 1).waitForExistence(timeout: 1))
        } else {
            app.dialogs["alert"].typeText("\r")
            XCTAssertFalse(app.menuBars.element(boundBy: 1).waitForExistence(timeout: 1))
        }
    }

    func testEdgeSelector() throws {
        let settingsWindow = app.windows["Settings"]
        let coordinate = settingsWindow.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))

        let normalisedLeft = coordinate.withOffset(CGVector(dx: 240, dy: 170))
        normalisedLeft.click()

        XCTAssertEqual(settingsWindow.children(matching: .radioButton).matching(identifier: "Left").firstMatch.value as? Int, 1)

        let normalisedRight = coordinate.withOffset(CGVector(dx: 320, dy: 170))
        normalisedRight.click()
        XCTAssertEqual(settingsWindow.children(matching: .radioButton).matching(identifier: "Right").firstMatch.value as? Int, 1)

        let normalisedTop = coordinate.withOffset(CGVector(dx: 290, dy: 150))
        normalisedTop.click()
        XCTAssertEqual(settingsWindow.children(matching: .radioButton).matching(identifier: "Top").firstMatch.value as? Int, 1)

        let normalisedBottom = coordinate.withOffset(CGVector(dx: 290, dy: 180))
        normalisedBottom.click()
        XCTAssertEqual(settingsWindow.children(matching: .radioButton).matching(identifier: "Bottom").firstMatch.value as? Int, 1)

        XCTAssertFalse(settingsWindow.children(matching: .radioButton).matching(identifier: "Left").firstMatch.isSelected)
        XCTAssertFalse(settingsWindow.children(matching: .radioButton).matching(identifier: "Top").firstMatch.isSelected)
        XCTAssertFalse(settingsWindow.children(matching: .radioButton).matching(identifier: "Right").firstMatch.isSelected)

    }

}
