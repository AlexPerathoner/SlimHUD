//
//  SettingsUITests.swift
//  SettingsUITests
//
//  Created by Alex Perathoner on 22/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class SettingsUITest: SparkleUITests {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testOpenSettingsWindow() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.windows.count == 0)

        app.activate()

        let settingsWindow = app.windows.matching(identifier: "SlimHUD").firstMatch
        XCTAssert(settingsWindow.waitForExistence(timeout: 5))
        addScreenshot(window: settingsWindow, name: "Settings")
    }

    func testCloseWindowWithCmdW() throws {
        let app = XCUIApplication()
        app.launch()
        app.activate()

        let settingsWindow = app.windows.matching(identifier: "SlimHUD").firstMatch

        settingsWindow.typeKey("w", modifierFlags: .command)
        usleep(5000)
        XCTAssertFalse(settingsWindow.isHittable)
    }

    func testCloseWindowWithCmdQ() throws {
        let app = XCUIApplication()
        app.launch()
        app.activate()

        let settingsWindow = app.windows.matching(identifier: "SlimHUD").firstMatch

        settingsWindow.typeKey("q", modifierFlags: .command)
        app.dialogs["alert"].buttons["OK"].click()
        usleep(5000)
        XCTAssertFalse(settingsWindow.isHittable)
    }

    func testQuit() throws {
        let app = XCUIApplication()
        app.launch()
        app.activate()
        let settingsWindow = app.windows.matching(identifier: "SlimHUD").firstMatch
        settingsWindow.typeKey("q", modifierFlags: .command)
        app.dialogs["alert"].buttons["Quit now"].click()

        XCTAssertFalse(settingsWindow.isHittable)
        XCTAssertFalse(app.exists)
    }

    func testSwitchTabs() throws {
        let app = XCUIApplication()
        app.showSettings()
        app.launch()

        let settingsWindow = XCUIApplication().windows["Settings"]

        settingsWindow.typeKey("4", modifierFlags: .command)
        XCTAssertTrue(settingsWindow.images["application icon"].waitForExistence(timeout: 1))

        settingsWindow.typeKey("1", modifierFlags: .command)
        XCTAssertTrue(settingsWindow.radioButtons["Top"].waitForExistence(timeout: 1))
    }

    func testChangePreviewHud() throws {
        let app = XCUIApplication()
        app.showSettings()
        app.launch()

        let settingsWindow = app.windows["Settings"]
        settingsWindow.typeKey("2", modifierFlags: .command)

        let radioGroupsQuery = settingsWindow.radioGroups
        radioGroupsQuery.children(matching: .radioButton).element(boundBy: 0).click()
        XCTAssertEqual(settingsWindow.colorWells.count, 4)
        XCTAssertTrue(isVolumeHudVisible(app: app))

        radioGroupsQuery.children(matching: .radioButton).element(boundBy: 1).click()
        XCTAssertEqual(settingsWindow.colorWells.count, 3)
        XCTAssertTrue(isBrightnessHudVisible(app: app))

        radioGroupsQuery.children(matching: .radioButton).element(boundBy: 2).click()
        XCTAssertEqual(settingsWindow.colorWells.count, 3)
        XCTAssertTrue(isKeyboardHudVisible(app: app))
    }
}
