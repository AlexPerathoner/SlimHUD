//
//  SparkleUITest.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 23/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import XCTest

final class SparkleUITests: XCTestCase {
    static public func closeAlerts(app: XCUIApplication) -> Bool {
        var closedSomeDialogs = false
        while(app.dialogs.count > 0) {
            app.dialogs.firstMatch.buttons.firstMatch.doubleClick()
            closedSomeDialogs = true
        }
        return closedSomeDialogs
    }
}
