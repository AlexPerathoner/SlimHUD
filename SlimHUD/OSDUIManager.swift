//
//  OSDUIManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 17/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation

class OSDUIManager {
    private init() {}
    
    public static func stop() {
        do {
            let kickstart = Process()
            kickstart.executableURL = URL(fileURLWithPath: "/bin/launchctl")
            kickstart.arguments = ["kickstart", "gui/\(getuid())/com.apple.OSDUIHelper"] // When macOS boots, OSDUIHelper does not start until a volume button is pressed. We can workaround this by kickstarting it.
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
