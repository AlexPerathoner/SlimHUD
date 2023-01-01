//
//  NSButtonExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import AppKit

extension NSButton {
    func boolValue() -> Bool {
        if state.rawValue == 0 {
            return false
        }
        return true
    }
}
