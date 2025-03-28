//
//  DisplayManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import Cocoa
import CoreGraphics

class DisplayManager {
    private init() {}

    private static var useM1DisplayBrightnessMethod = false

    private static var method = SensorMethod.standard

    // When the monitor settings change we should invoke this to try all methods again
    // example: connects an external monitor with which brightness doesn't work, then disconnects it. Now the internal
    //   monitor should be recognised, but the old allFailed status would still be there
    static func resetMethod() {
        method = .standard
    }

    static func getDisplayBrightness() throws -> Float {
        switch DisplayManager.method {
        case .standard:
            do {
                return try getStandardDisplayBrightness()
            } catch {
                method = .m1
            }
        case .m1:
            do {
                return try getM1DisplayBrightness()
            } catch {
                method = .allFailed
            }
        case .allFailed:
            throw SensorError.Display.notFound
        }
        return try getDisplayBrightness()
    }

    private static func getStandardDisplayBrightness() throws -> Float {
        var brightness: float_t = 1
        let service = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"))
        defer {
            IOObjectRelease(service)
        }

        let result = IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
        if result != kIOReturnSuccess {
            throw SensorError.Display.notStandard
        }
        return brightness
    }
    private static func getM1DisplayBrightness() throws -> Float {
        let task = Process()
        task.launchPath = "/usr/libexec/corebrightnessdiag"
        task.arguments = ["status-info"]
        let pipe = Pipe()
        task.standardOutput = pipe
        try task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()

        if let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? NSDictionary,
           let displays = plist["CBDisplays"] as? [String: [String: Any]] {
            for display in displays.values {
                if let displayInfo = display["Display"] as? [String: Any],
                    displayInfo["DisplayServicesIsBuiltInDisplay"] as? Bool == true,
                    let brightness = displayInfo["DisplayServicesBrightness"] as? Float {
                        return brightness
                }
            }
        }
        throw SensorError.Display.notSilicon
    }

    static func isInternalDisplay(_ screen: NSScreen) -> Bool {
        // Retrieve the screen's display ID
        guard let screenNumber = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID else {
            return false
        }

        // Use CoreGraphics API to check if the display is built-in
        let isBuiltIn = CGDisplayIsBuiltin(screenNumber) != 0
        return isBuiltIn
    }

    /* https://github.com/AlexPerathoner/SlimHUD/issues/145
     Used to check if the internal screen
     */
    static func hasNotch() -> Bool {
        guard let mainScreen = NSScreen.main else {
            return false
        }
        // todo multiple monitors: will have to deal with following situation
        // slimhud should appear on internal screen with notch, but main screen is external one
        if !isInternalDisplay(mainScreen) {
            // for now, if not the focus is not on the internal display,

        }

        // Get the safe area insets of the main screen
        if #available(macOS 12.0, *) {
            let safeAreaInsets = mainScreen.safeAreaInsets
            // A device with a notch will have non-zero safe area insets at the top
            return safeAreaInsets.top > 0
        } else {
            return false
        }
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

    static func getMenuBarVisibleThickness() -> CGFloat {
        let screenFrame = getScreenFrame()
        let visibleFrame = getVisibleScreenFrame()
        var menuBarThickness: CGFloat = 0
        if (screenFrame.height - visibleFrame.height - visibleFrame.minY) != 0 { // menu bar visible
            menuBarThickness = NSStatusBar.system.thickness
        }
        return menuBarThickness
    }

    static func getNotchThickness() -> CGFloat {
        // todo duplicated code from hasNotch() - refactor when solving multiple monitors
        guard let mainScreen = NSScreen.main else {
            return 0
        }
        // todo multiple monitors: will have to deal with following situation
        // slimhud should appear on internal screen with notch, but main screen is external one
        if !isInternalDisplay(mainScreen) {
            // for now, if not the focus is not on the internal display,

        }

        // Get the safe area insets of the main screen
        if #available(macOS 12.0, *) {
            let safeAreaInsets = mainScreen.safeAreaInsets
            if safeAreaInsets.top == 0 {
                return 0
            }
            return safeAreaInsets.top
        }
        return 0
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
        if let rawPosition = UserDefaults.standard.persistentDomain(forName: "com.apple.dock")?["orientation"] as? String {
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
                if windowName == "Window Server" || windowName == "Dock" {
                    return false
                }
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
