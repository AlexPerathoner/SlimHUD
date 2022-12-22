//
//  DisplayManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation
import Cocoa

class DisplayManager {
    private init() {}

    private static var useM1DisplayBrightnessMethod = false

    static func getDisplayBrightness() -> Float {
        if useM1DisplayBrightnessMethod {
            return getM1DisplayBrightness()
        } else {
            do {
                return try getStandardDisplayBrightness()
            } catch {
                DisplayManager.useM1DisplayBrightnessMethod = true
                return getM1DisplayBrightness()
            }
        }
    }

    private static func getStandardDisplayBrightness() throws -> Float {
        var brightness: float_t = 1
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"))
        defer {
            IOObjectRelease(service)
        }

        let result = IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
        if result != kIOReturnSuccess {
            throw SensorError.displayBrightnessFailure
        }
        return brightness
    }
    private static func getM1DisplayBrightness() -> Float {
        let task = Process()
        task.launchPath = "/usr/libexec/corebrightnessdiag"
        task.arguments = ["status-info"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()

        var displayBrightness: Float?

        if let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? NSDictionary {
            if let displays = plist["CBDisplays"] as? [String: [String: Any]] {
                for display in displays.values {
                    if let displayInfo = display["Display"] as? [String: Any],
                        displayInfo["DisplayServicesIsBuiltInDisplay"] as? Bool == true,
                        let brightness = displayInfo["DisplayServicesBrightness"] as? Float {
                            displayBrightness = brightness
                            break
                    }
                }
            }
        }
        return displayBrightness ?? 0 // todo add throws, handle outside
    }

    /* Note the difference between NSScreen.main and NSScreen.screens[0]:
     * NSScreen.main is the "key" screen, where the currently frontmost window resides.
     * NSScreen.screens[0] is the screen which has a menu bar, and is chosen in the Preferences > monitor settings
     */
    static func getZeroScreen() -> NSScreen {
        return NSScreen.screens[0]
    }

    static func getScreenFrame() -> NSRect {
        return getZeroScreen().frame
    }

    static func getVisibleScreenFrame() -> NSRect {
        return getZeroScreen().visibleFrame
    }

    static func getMenuBarThickness() -> CGFloat {
        let screenFrame = getScreenFrame()
        let visibleFrame = getVisibleScreenFrame()
        var menuBarThickness: CGFloat = 0
        if (screenFrame.height - visibleFrame.height - visibleFrame.minY) != 0 { // menu bar visible
            menuBarThickness = NSStatusBar.system.thickness
        }
        return menuBarThickness
    }

    static func getDockHeight() -> (xDockHeight: CGFloat, yDockHeight: CGFloat) {
        let screenFrame = getScreenFrame()
        let visibleFrame = getVisibleScreenFrame()

        let yDockHeight: CGFloat = visibleFrame.minY
        let xDockHeight: CGFloat = screenFrame.width - visibleFrame.width

        return (xDockHeight, yDockHeight)
    }

    static func getDockPosition() -> Position {
        var dockPosition: Position = .bottom
        if let rawPosition = UserDefaults.standard.persistentDomain(forName: "com.apple.dock")!["orientation"] as? String {
            if let actualPosition = Position(rawValue: rawPosition) {
                dockPosition = actualPosition
            } else {
                NSLog("Error while converting dock position. Rawvalue was: \(rawPosition).")
            }
        } else {
            NSLog("Error while retrieving dock position. Falling back to default: \(dockPosition).")
        }
        return dockPosition
    }

    static func isInFullscreenMode() -> Bool {
        let options = CGWindowListOption(arrayLiteral: CGWindowListOption.excludeDesktopElements, CGWindowListOption.optionOnScreenOnly)
        let windowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
        let windows = windowListInfo as NSArray? as? [[CFString: AnyObject]] ?? []
        let screenSize = DisplayManager.getScreenFrame()
        // TODO: check if it's possible to simplify function with just this:
        //        let windows = infoList.map({ (windowObj) -> String? in
        //            return windowObj[kCGWindowOwnerName] as? String
        //        })
        //        return windows.contains("Window Server") || windows.contains("Dock")

        for window in windows {
            if let windowName = window[kCGWindowOwnerName] as? String {
                // if Window Server or Dock are visible the user is certainly not using fullscreen
                if windowName == "Window Server" || windowName == "Dock" {return false}
                if window[kCGWindowBounds]?["Height"] as? CGFloat ?? 0 == screenSize.height &&
                    window[kCGWindowBounds]?["Width"] as? CGFloat ?? 0 == screenSize.width &&
                    windowName != "SlimHUD" {
                    return true
                }
            }
        }

        return true
    }

}
