//
//  NSImageExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa
import AppKit

extension NSImage {

    static let VolumeImageFileName = "volume"
    static let NoVolumeImageFileName = "noVolume"
    static let BrightnessImageFileName = "brightness"
    static let KeyboardImageFileName = "backlight"
    static let StatusIconFileName = "statusIcon"

    func tint(with color: NSColor) -> NSImage {
        self.lockFocus()
        color.set()
        let srcSpacePortionRect = NSRect(origin: CGPoint(), size: self.size)
        srcSpacePortionRect.fill(using: .sourceAtop)
        self.unlockFocus()
        return self
    }

}

// extension NSImage {
//    /// https://stackoverflow.com/a/50074538/6884062
//    /// - Returns: returns the tinted version of a template image
//    func tint(color: NSColor) -> NSImage {
//        let image = self.copy() as! NSImage
//        image.lockFocus()
//
//        color.set()
//
//        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
//        imageRect.fill(using: .sourceAtop)
//
//        image.unlockFocus()
//
//        return image
//    }
// }
