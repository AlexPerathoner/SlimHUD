//
//  NSImageExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa
import AppKit

extension NSImage {
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
