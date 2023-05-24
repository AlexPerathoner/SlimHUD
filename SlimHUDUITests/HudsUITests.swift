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
            try! self.changeVolume()
        }
        sleep(1)
        XCTAssertTrue(isVolumeHudVisible(app: app))
    }

    func testKeyVolumePress() throws {
        let app = XCUIApplication()
        app.shouldContinuouslyCheck()
        app.launch()

        XCTAssert(app.windows.count == 0)
        DispatchQueue.global().async {

            let NX_KEYTYPE_SOUND_UP: UInt32 = 0
            let NX_KEYTYPE_SOUND_DOWN: UInt32 = 1

            func HIDPostAuxKey(key: UInt32) {
                func doKey(down: Bool) {
                    let flags = NSEvent.ModifierFlags(rawValue: (down ? 0xa00 : 0xb00))
                    let data1 = Int((key<<16) | (down ? 0xa00 : 0xb00))

                    let ev = NSEvent.otherEvent(with: NSEvent.EventType.systemDefined,
                                                location: NSPoint(x: 0, y: 0),
                                                modifierFlags: flags,
                                                timestamp: 0,
                                                windowNumber: 0,
                                                context: nil,
                                                subtype: 8,
                                                data1: data1,
                                                data2: -1)
                    let cev = ev?.cgEvent
                    cev?.post(tap: CGEventTapLocation.cghidEventTap)
                }
                doKey(down: true)
                doKey(down: false)
            }

            for _ in 1...3 {
                HIDPostAuxKey(key: NX_KEYTYPE_SOUND_UP)
                usleep(500000)
                HIDPostAuxKey(key: NX_KEYTYPE_SOUND_DOWN)
                usleep(500000)
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
            try! self.changeVolume()
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
