//
//  AnimationStyle.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/01/23.
//

import Foundation

enum AnimationStyle: String {
    case None
    case Slide
    case PopInFadeOut = "Pop in + fade out"
    case Fade
    case Grow
    case Shrink
    case SideGrow = "Side grow"
    
    private static let DefaultValue = AnimationStyle.Slide
    
    init(from rawValue: String?) {
        self = AnimationStyle(rawValue: rawValue ?? "") ?? AnimationStyle.DefaultValue
    }
    
    func requiresInMovement() -> Bool {
        switch self {
        case .Slide, .SideGrow:
            return true
        default:
            return false
        }
    }
}
