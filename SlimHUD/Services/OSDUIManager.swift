//
//  OSDUIManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation

class OSDUIManager {
    private init() {}
    
    public static func start() {
        do {
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
            // When macOS boots, OSDUIHelper does not start until a volume button is pressed. We can workaround this by kickstarting it.
            task.arguments = ["-9", "OSDUIHelper"]
            try task.run()
        } catch {
            NSLog("Error while trying to re-enable OSDUIHelper. \(error)")
        }
    }

    public static func stop() {
        do {
            let kickstart = Process()
            kickstart.executableURL = URL(fileURLWithPath: "/bin/launchctl")
            // When macOS boots, OSDUIHelper does not start until a volume button is pressed. We can workaround this by kickstarting it.
            kickstart.arguments = ["kickstart", "gui/\(getuid())/com.apple.OSDUIHelper"]
            try kickstart.run()
            kickstart.waitUntilExit()
            usleep(500000) // Make sure it started
            let task = Process()
            task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
            task.arguments = ["-STOP", "OSDUIHelper"]
            try task.run()
        } catch {
            NSLog("Error while trying to hide OSDUIHelper. Please create an issue on GitHub. Error: \(error)")
        }
    }
}
