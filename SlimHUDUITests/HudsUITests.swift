//
//  HudsUITests.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 05/01/23.
//

import Foundation
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
            try changeVolume()
        } catch {
            XCTAssertEqual(error.localizedDescription, "")
        }
        usleep(500000)
        XCTAssert(app.windows.count >= 1)
    }
    
    func testTriggerVolumeHud2() throws {
        XCTAssert(app.windows.count == 0)
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e display alert \"hey\""]
        try task.run()
        do {
            try changeVolume()
        } catch {
            XCTAssertEqual(error.localizedDescription, "")
        }
        usleep(1500000)
        XCTAssert(app.windows.count >= 1)
    }

    private func changeVolume() throws {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e set volume output volume 50", "-e set volume output volume 10"]
        try task.run()
    }
}
