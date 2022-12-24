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
        return AppleScriptRunner.run(script: "return output muted of (get volume settings)") == "true"
    }

    static func getOutputVolume() -> Float {
        return Float(AppleScriptRunner.run(script: "return output volume of (get volume settings)") ?? "1")! / 100.0
    }
}
