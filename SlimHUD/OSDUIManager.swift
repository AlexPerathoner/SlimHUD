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
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
        task.arguments = ["-STOP", "OSDUIHelper"]
        do {
            try task.run()
        } catch {
            NSLog("Error while trying to hide OSDUIHelper. Please create an issue on GitHub.")
        }
    }
}
