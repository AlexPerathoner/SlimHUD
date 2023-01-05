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
            let a = try AppleScriptRunner.run(script: "return output volume of (get volume settings)") // XCTAssertEqual failed: ("The operation couldn’t be completed. (SlimHUDUITests.AppleScriptError error 2.)") is not equal to ("")
            XCTAssertEqual(a, "")
        } catch {
            XCTAssertEqual(error.localizedDescription, "")
            NSLog("Applescript returned empty output")
        }
        usleep(300000)
        do {
            let a = try AppleScriptRunner.run(script: "set volume output volume 10")
            XCTAssertEqual(a, "")
        } catch AppleScriptError.emptyOutput {
            NSLog("Applescript returned empty output")
        }

        usleep(1000000)
        XCTAssert(app.windows.count >= 1)
    }
}
