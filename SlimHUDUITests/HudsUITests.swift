//
//  HudsUITests.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 05/01/23.
//

import Foundation
import XCTest

final class HudsUITest: SparkleUITests {

    func testTriggerVolumeHud() throws {
        let app = XCUIApplication()
        app.shouldContinuouslyCheck()
        app.launch()

        XCTAssert(app.windows.count == 0)
        DispatchQueue.global().async {
            do {
                try self.changeVolume()
            } catch {
                fatalError("Could not run change volume script")
            }
        }
        sleep(1)
        XCTAssertTrue(isVolumeHudVisible(app: app))
    }

    private func changeVolume() throws {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e set volume output volume 50",
                          "-e delay 1",
                          "-e set volume output volume 20",
                          "-e delay 1",
                          "-e set volume output volume 50",
                          "-e delay 1",
                          "-e set volume output volume 20"]
        try task.run()
    }

    func testFullscreen() throws {
        let app = XCUIApplication()
        let finder = XCUIApplication(bundleIdentifier: "com.apple.finder")
        app.shouldContinuouslyCheck()
        app.launch()
        finder.launch()

        try openWindowInFullscreenMode()
        sleep(1)

        DispatchQueue.global().async {
            do {
                try self.changeVolume()
            } catch {
                fatalError("Could not run change volume script")
            }
        }
        sleep(1)
        XCTAssertTrue(isVolumeHudVisible(app: app))
    }

    private func openWindowInFullscreenMode() throws {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e tell application \"Finder\" to make new Finder window",
                          "-e delay 1",
                          "-e tell application \"System Events\" to tell process \"Finder\" to set value of attribute \"AXFullScreen\" of window 1 to true"]
        try task.run()
    }
}
