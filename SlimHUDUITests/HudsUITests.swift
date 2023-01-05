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
        changeVolume()
        usleep(500000)
        XCTAssert(app.windows.count >= 1)
    }
    
    private func changeVolume() {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e set volume output volume 30", "-e set volume output volume 10"]
        task.launch()
    }
}
