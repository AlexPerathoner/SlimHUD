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
        return self ? .on : .off
    }

    func toInt() -> Int {
        return self ? 1 : 0
    }
}
