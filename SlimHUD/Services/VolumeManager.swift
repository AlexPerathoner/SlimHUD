//
//  VolumeManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation

class VolumeManager {
    private init() {}
    
    static func isMuted() -> Bool {
        return runAS(script: "return output muted of (get volume settings)") == "true"
    }

    static func getVolumeSettings() -> (outPutVolume: Int, inputVolume: Int, alertVolume: Int, outputMuted: Bool) {
        let o1 = Int(runAS(script: "return output volume of (get volume settings)") ?? "1")!
        let o2 = Int(runAS(script: "return input volume of (get volume settings)") ?? "1")!
        let o3 = Int(runAS(script: "return alert volume of (get volume settings)") ?? "1")!
        let o4 = runAS(script: "return output muted of (get volume settings)") == "true"

        return (o1, o2, o3, o4)
    }

    static func getOutputVolume() -> Float {
        return Float(runAS(script: "return output volume of (get volume settings)") ?? "1")! / 100.0
    }
}
