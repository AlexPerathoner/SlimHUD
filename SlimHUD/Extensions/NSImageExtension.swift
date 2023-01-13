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
        static let no = "volume-no"
        static let zero = "volume-zero"
        static let one = "volume-one"
        static let two = "volume-two"
        static let three = "volume-three"
    }
    struct BrightnessImageFileName {
        static let one = "sun-one"
        static let two = "sun-two"
    }
    struct KeyboardImageFileName {
        static let one = "key-one"
        static let two = "key-two"
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
