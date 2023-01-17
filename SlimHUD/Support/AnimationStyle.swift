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
    case PopInFadeOut
    case Fade
    case Grow
    case Shrink
    case SideGrow
    
    private static let DefaultValue = AnimationStyle.Slide
    
    init(from rawValue: String) {
        self = AnimationStyle(rawValue: rawValue) ?? AnimationStyle.DefaultValue
    }
    
    init(from intValue: Int) { // TODO: remove this, handle in storyboard with identifiers
        switch intValue {
        case 0: self = .None
        case 1: self = .Slide
        case 2: self = .PopInFadeOut
        case 3: self = .Fade
        case 4: self = .Grow
        case 5: self = .Shrink
        case 6: self = .SideGrow
        default: self = AnimationStyle.DefaultValue
        }
    }
    
    func intValue() -> Int {
        switch self {
        case .None: return 0
        case .Slide: return 1
        case .PopInFadeOut: return 2
        case .Fade: return 3
        case .Grow: return 4
        case .Shrink: return 5
        case .SideGrow: return 6
        }
    }
}
