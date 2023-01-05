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
        let image = self.copy() as! NSImage
        self.lockFocus()
        color.set()
        let srcSpacePortionRect = NSRect(origin: NSZeroPoint, size: image.size)
        srcSpacePortionRect.fill(using: .sourceAtop)
        self.unlockFocus()
        return image
    }

}
