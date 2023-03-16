//
//  LogicError.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 28/01/23.
//

import Foundation

enum LogicError: Error {
    enum EnabledBarsConversion: Error {
        case multipleBarsSelected
        case noBarsSelected
    }
}
