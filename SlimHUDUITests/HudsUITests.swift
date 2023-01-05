//
//  HudsUITests.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 05/01/23.
//

import XCTest

final class HudsUITest: SparkleUITests {
    var app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()
    }

    func testTriggerVolumeHud() throws {
        XCTAssert(app.windows.count == 0)
        do {
            try AppleScriptRunner.run(script: "set volume output volume 40")
        } catch AppleScriptError.emptyOutput {
            NSLog("Applescript returned empty output")
        }
        usleep(300000)
        do {
            try AppleScriptRunner.run(script: "set volume output volume 10")
        } catch AppleScriptError.emptyOutput {
            NSLog("Applescript returned empty output")
        }

        usleep(1000000)
        XCTAssert(app.windows.count >= 1)
    }
}
