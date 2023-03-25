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
    func setShadowType(shadowType: String) {
        launchArguments += ["shadowType", shadowType]
    }
    func setHudSize(size: NSSize) {
        launchArguments += ["hudSize", size.width.description, size.height.description]
    }
    func setHudPosition(edge: String) {
        launchArguments += ["hudEdge", edge]
    }
    func showSparkleReminder() {
        UserDefaults.standard.set(Date() + 80000, forKey: "SULastCheckTime")
    }
}
