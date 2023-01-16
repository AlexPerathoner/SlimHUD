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
    case GrowBlur
    case ShrinkBlur
    case Fade
    case Grow
    case Shrink
    case SideGrow
    
    private static let DefaultValue = AnimationStyle.Slide
    
    init(from rawValue: String) {
        self = AnimationStyle(rawValue: rawValue) ?? AnimationStyle.DefaultValue
    }
    
    init(from intValue: Int) {
        switch intValue {
        case 0: self = .None
        case 1: self = .Slide
        case 2: self = .PopInFadeOut
        case 3: self = .GrowBlur
        case 4: self = .ShrinkBlur
        case 5: self = .Fade
        case 6: self = .Grow
        case 7: self = .Shrink
        case 8: self = .SideGrow
        default: self = AnimationStyle.DefaultValue
        }
    }
    
    func intValue() -> Int {
        switch self {
        case .None: return 0
        case .Slide: return 1
        case .PopInFadeOut: return 2
        case .GrowBlur: return 3
        case .ShrinkBlur: return 4
        case .Fade: return 5
        case .Grow: return 6
        case .Shrink: return 7
        case .SideGrow: return 8
        }
    }
}
