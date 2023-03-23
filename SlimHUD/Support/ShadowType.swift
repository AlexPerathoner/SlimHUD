//
//  ShadowType.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/03/23.
//

import Foundation
import Cocoa

enum ShadowType: String {
    case none = "None"
    case nsshadow = "Standard"
    case view = "Custom..."
    
    private static let DefaultValue = ShadowType.nsshadow

    init(from rawValue: String?) {
        self = ShadowType(rawValue: rawValue ?? "") ?? ShadowType.DefaultValue
    }
}
