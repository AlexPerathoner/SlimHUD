//
//  XCUIApplicationExtension.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 05/01/23.
//

import XCTest

extension XCUIApplication {
    func shouldContinuouslyCheck() {
        launchArguments += ["shouldContinuouslyCheck"]
    }
    func showSettings() {
        launchArguments += ["showSettingsAtLaunch"]
    }
    func showSparkleReminder() {
        UserDefaults.standard.set(Date() + 80000, forKey: "SULastCheckTime")
    }
}
