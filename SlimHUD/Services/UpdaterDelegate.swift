//
//  UpdaterDelegate.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 11/01/23.
//

import Cocoa
import Sparkle

class UpdaterDelegate: NSObject, SPUUpdaterDelegate {
    var checkBetaUpdates = false
    func allowedChannels(for updater: SPUUpdater) -> Set<String> {
        if checkBetaUpdates {
            return Set(["beta"])
        } else {
            return Set()
        }
    }
}
