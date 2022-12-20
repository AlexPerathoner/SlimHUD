//
//  NSControlExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation
import Cocoa

extension NSControl.StateValue {
    func boolValue() -> Bool {
        if(self.rawValue == 0) {
            return false
        }
        return true
    }
}
