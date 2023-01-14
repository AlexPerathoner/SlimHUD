//
//  NSImageExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa
import AppKit

extension NSImage {

    struct VolumeImageFileName {
        // swiftlint:disable:next identifier_name
        static let no = "volume-no"
        static let zero = "volume-0"
        static let one = "volume-1"
        static let two = "volume-2"
        static let three = "volume-3"
    }
    struct BrightnessImageFileName {
        static let zero = "sun-0"
        static let one = "sun-1"
        static let two = "sun-2"
        static let three = "sun-3"
    }
    struct KeyboardImageFileName {
        static let zero = "key-0"
        static let one = "key-1"
        static let two = "key-2"
        static let three = "key-3"
    }
    static let StatusIconFileName = "statusIcon"

    func tint(with color: NSColor) -> NSImage {
        // swiftlint:disable:next force_cast
        let image = self.copy() as! NSImage
        self.lockFocus()
        color.set()
        let srcSpacePortionRect = NSRect(origin: NSPoint.zero, size: image.size)
        srcSpacePortionRect.fill(using: .sourceAtop)
        self.unlockFocus()
        return image
    }

}
