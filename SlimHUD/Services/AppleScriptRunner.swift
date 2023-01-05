//
//  AppleScriptRunner.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation

class AppleScriptRunner {
    private init() {}

    static func run(script: String) throws -> String {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error) // todo should run in background
            guard error == nil else {
                throw AppleScriptError.runtimeError
            }
            if let outputString = output.stringValue {
                return outputString
            }
            throw AppleScriptError.emptyOutput
        }
        throw AppleScriptError.initScriptFailed
    }
}
