//
//  AAAUITestSetup.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 05/01/23.
//

 import XCTest

/// Tests are run in alphabetical order. Strange name is for that reason
/// 
 final class AAAUITestSetup: SparkleUITests {
    /// Will close dialog opened by Sparkle telling there was an error while checking for updates (GitHub Runner can't connect to rss
    func testAFirstLaunch() {
        let app = XCUIApplication()
        app.launch()
        if CommandLine.arguments.contains("-sparkle-will-alert") {
            SparkleUITests.waitForAlertAndClose(app: app, timeout: 7)
        }
    }

    /// Will close dialog opened by Sparkle asking to 
    func testBSecondLaunch() {
        if CommandLine.arguments.contains("-sparkle-will-alert") {
            var checkAutomaticallyForUpdatesClicked = false
            var timeout = SparkleUITests.TimeOut
            while !checkAutomaticallyForUpdatesClicked && timeout > 0 {
                let app = XCUIApplication()
                app.launch()
                if app.windows.count > 0 {
                    app.windows.firstMatch.typeText("\r")
                    checkAutomaticallyForUpdatesClicked = true
                }
                timeout -= 1
            }
        }
    }
 }
