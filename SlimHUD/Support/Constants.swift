//
//  Constants.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

class DefaultColors {
    static let DarkGray = NSColor(red: 0.34, green: 0.4, blue: 0.46, alpha: 0.2)
    static let Gray = NSColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
    static let Blue = NSColor(red: 0.19, green: 0.5, blue: 0.96, alpha: 0.9)
    static let Yellow = NSColor(red: 0.77, green: 0.7, blue: 0.3, alpha: 1)
    static let Azure = NSColor(red: 0.62, green: 0.8, blue: 0.91, alpha: 0.9)
}

class Constants {
    private init() {}
    
    static let ShadowRadius: CGFloat = 20
    
    struct Animation {
        private init() {}
        
        static let Duration: CGFloat = 0.3
        static let Movement: CGFloat = 20
    }
}


