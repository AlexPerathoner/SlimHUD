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
        app.showSettings() // TODO: add option to make settings non saved (state should be always same when starting - don't save settings when closing app)
        app.launch()
    }
// TODO: error in logs: This method should not be called on the main thread as it may lead to UI unresponsiveness, find out whihc
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
        clickAndCheck(normalisedLeft, settingsWindow.children(matching: .radioButton).matching(identifier: "Left"), 1)
        XCTAssertEqual(getWindowEdge(app: app), .left)

        let normalisedRight = coordinate.withOffset(CGVector(dx: 320, dy: 170))
        clickAndCheck(normalisedRight, settingsWindow.children(matching: .radioButton).matching(identifier: "Right"), 1)
        XCTAssertEqual(getWindowEdge(app: app), .right)

        let normalisedTop = coordinate.withOffset(CGVector(dx: 290, dy: 150))
        clickAndCheck(normalisedTop, settingsWindow.children(matching: .radioButton).matching(identifier: "Top"), 1)
        XCTAssertEqual(getWindowEdge(app: app), .top)

        let normalisedBottom = coordinate.withOffset(CGVector(dx: 290, dy: 180))
        clickAndCheck(normalisedBottom, settingsWindow.children(matching: .radioButton).matching(identifier: "Bottom"), 1)
        XCTAssertEqual(getWindowEdge(app: app), .bottom)

        XCTAssertFalse(settingsWindow.children(matching: .radioButton).matching(identifier: "Left").firstMatch.isSelected)
        XCTAssertFalse(settingsWindow.children(matching: .radioButton).matching(identifier: "Top").firstMatch.isSelected)
        XCTAssertFalse(settingsWindow.children(matching: .radioButton).matching(identifier: "Right").firstMatch.isSelected)
    }

    private func clickAndCheck(_ element: XCUICoordinate, _ actual: XCUIElementQuery, _ expected: Int?) {
        element.click()
        var limit = 5
        var actValue = actual.firstMatch.value as? Int
        while actValue != expected && limit > 0 {
            element.click()
            usleep(100000) // 0.1s
            limit -= 1
            actValue = actual.firstMatch.value as? Int
        }
        XCTAssertEqual(actValue, expected)
    }
}
