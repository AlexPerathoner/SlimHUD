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
    
    init(from rawValue: String) {
        self = AnimationStyle(rawValue: rawValue) ?? .None
    }
}
