////
////  HudsUITests.swift
////  SlimHUDUITests
////
////  Created by Alex Perathoner on 05/01/23.
////
//
// import Foundation
// import XCTest
//
// final class HudsUITest: SparkleUITests {
//    var app = XCUIApplication()
//    override func setUpWithError() throws {
//        continueAfterFailure = false
//        app.shouldContinuouslyCheck()
//        app.launch()
//    }
//
//    func testTriggerVolumeHud() throws {
//        XCTAssert(app.windows.count == 0)
//        do {
//            try changeVolume()
//        } catch {
//            XCTAssertEqual(error.localizedDescription, "")
//        }
//        usleep(500000)
//        XCTAssert(app.windows.count >= 1)
//    }
//
//    private func changeVolume() throws {
//        let task = Process()
//        task.launchPath = "/usr/bin/osascript"
//        task.arguments = ["-e set volume output volume 50", "-e delay 1", "-e set volume output volume 20"]
//        try task.run()
//    }
// }
