//
//  AnimationStyle.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/01/23.
//

import Foundation

enum AnimationStyle: String {
    case none = "None"
    case slide = "Slide"
    case popInFadeOut = "Pop in + fade out"
    case fade = "Fade"
    case grow = "Grow"
    case shrink = "Shrink"
    case sideGrow = "Side grow"

    private static let DefaultValue = AnimationStyle.slide

    init(from rawValue: String?) {
        self = AnimationStyle(rawValue: rawValue ?? "") ?? AnimationStyle.DefaultValue
    }

    func requiresInMovement() -> Bool {
        switch self {
        case .slide, .sideGrow:
            return true
        default:
            return false
        }
    }
}
