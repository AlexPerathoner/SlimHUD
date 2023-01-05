//
//  VolumeManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation

class VolumeManager {
    private init() {}

    static func isMuted() -> Bool {
        do {
            return try AppleScriptRunner.run(script: "return output muted of (get volume settings)") == "true"
        } catch {
            NSLog("Error while trying to retrieve muted properties of device: \(error). Returning default value false.")
            return false
        }
    }

    static func getOutputVolume() -> Float {
        do {
            if let volumeStr = Float(try AppleScriptRunner.run(script: "return output volume of (get volume settings)")) {
                return volumeStr / 100
            } else {
                NSLog("Error while trying to parse volume string value. Returning default volume value 1.")
            }
        } catch {
            NSLog("Error while trying to retrieve volume properties of device: \(error). Returning default volume value 1.")
        }
        return 0.01
    }
}
