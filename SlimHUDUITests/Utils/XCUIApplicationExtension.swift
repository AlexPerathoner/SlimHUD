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
    func showCmdQAlert(_ showCmdQAlert: Bool) {
        launchArguments += ["showQuitAlert", showCmdQAlert.description]
    }
    func shouldShowSettingsAtLaunch() {
        launchArguments += ["showSettingsAtLaunch"]
    }
}
