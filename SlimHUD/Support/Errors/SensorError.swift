//
//  SensorError.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation

enum SensorError: Error {
    enum Display: Error {
        case notFound
        case notSilicon
        case notStandard
    }
    enum Keyboard: Error {
        case notFound
        case notSilicon
        case notStandard
    }
}
