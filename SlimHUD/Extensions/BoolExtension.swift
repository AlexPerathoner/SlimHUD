//
//  BoolExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import Cocoa

extension Bool {
    func toStateValue() -> NSControl.StateValue {
        if self {
            return .on
        } else {
            return .off
        }
    }

    func toInt() -> Int {
        if self {return 1}
        return 0
    }
}
