//
//  Constants.swift
//  SlimHUDTests
//
//  Created by Alex Perathoner on 21/12/22.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation

final class Constants {
    public struct Hud {
        static let ShortEdge: CGFloat = 47
        static let LongEdge: CGFloat = 297
    }
    public struct Screen {
        static let Width: CGFloat = 1440
        static let Height: CGFloat = 900
        public static let MenuBarSize: CGFloat = 25
        public static let DockSize: CGFloat = 62
        public static let Frame = NSRect(x: 0, y: 0, width: Screen.Width, height: Screen.Height)
    }
}
