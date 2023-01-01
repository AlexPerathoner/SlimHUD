//
//  NSControlExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import Cocoa

extension NSControl.StateValue {
    func boolValue() -> Bool {
        if self.rawValue == 0 {
            return false
        }
        return true
    }
}
