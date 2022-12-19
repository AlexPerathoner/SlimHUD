//
//  Extensions.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import AppKit

extension NSImage {
    
    static let VOLUME_IMAGE_FILE_NAME = "volume"
    static let BRIGHTNESS_IMAGE_FILE_NAME = "brightness"
    static let KEYBOARD_IMAGE_FILE_NAME = "backlight"
    static let STATUS_ICON_IMAGE_FILE_NAME = "statusIcon"
    
}

//extension NSImage {
//	/// https://stackoverflow.com/a/50074538/6884062
//	/// - Returns: returns the tinted version of a template image
//	func tint(color: NSColor) -> NSImage {
//		let image = self.copy() as! NSImage
//		image.lockFocus()
//
//		color.set()
//
//		let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
//		imageRect.fill(using: .sourceAtop)
//
//		image.unlockFocus()
//
//		return image
//	}
//}

