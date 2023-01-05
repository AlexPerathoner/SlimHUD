//
//  AppleScriptError.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 01/01/23.
//

import Foundation

enum AppleScriptError: Error {
    case initScriptFailed
    case runtimeError
    case emptyOutput
}
