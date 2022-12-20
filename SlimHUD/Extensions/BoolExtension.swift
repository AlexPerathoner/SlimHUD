//
//  BoolExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
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
