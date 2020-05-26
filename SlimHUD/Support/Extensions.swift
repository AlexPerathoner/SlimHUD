//
//  Extensions.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import AppKit


extension NSButton {
	func boolState() -> Bool {
		if(state.rawValue == 0) {
			return false
		}
		return true
	}
}


extension NSControl.StateValue {
	func boolValue() -> Bool {
		if(self.rawValue == 0) {
			return false
		}
		return true
	}
}

extension Bool {
	func toStateValue() -> NSControl.StateValue {
		if(self) {
			return .on
		} else {
			return .off
		}
	}
	
	func toInt() -> Int {
		if(self) {return 1}
		return 0
	}
}

extension NSView {
	func getCenter() -> CGPoint {
		return CGPoint(x: (self.frame.origin.x + (self.frame.size.width / 2)), y:
		(self.frame.origin.y + (self.frame.size.height / 2)))
	}
	
    func setAnchorPoint (anchorPoint:CGPoint) {
        if let layer = self.layer {
            var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
            var oldPoint = CGPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)

            newPoint = newPoint.applying(layer.affineTransform())
            oldPoint = oldPoint.applying(layer.affineTransform())

            var position = layer.position

            position.x -= oldPoint.x
            position.x += newPoint.x

            position.y -= oldPoint.y
            position.y += newPoint.y

            layer.position = position
            layer.anchorPoint = anchorPoint
        }
    }
	
	func setupShadow(_ enabled: Bool, _ shadowRadius: CGFloat) {
		if(enabled) {
			shadow = NSShadow()
			wantsLayer = true
			superview?.wantsLayer = true
			layer?.shadowOpacity = 1
			layer?.shadowColor = .black
			layer?.shadowOffset = NSMakeSize(0, 0)
			layer?.shadowRadius = shadowRadius
		} else {
			shadow = nil
		}
	}
	
	class func fromNib(name: String) -> NSView? {
		var views: NSArray?
		if Bundle.main.loadNibNamed(name, owner: nil, topLevelObjects: &views) {
			if views?.firstObject is NSView {
				return (views?.firstObject as! NSView)
			} else {
				return (views?[1] as! NSView)
			}
		}
		return nil
		
    }
}

extension NSSegmentedControl {
	func getBarState() -> [Bool] {
		var states: [Bool] = []
		for i in 0..<segmentCount {
			states.append(isSelected(forSegment: i))
		}
		return states
	}
	
	func setBarState(values: [Bool]) throws {
		guard values.count == segmentCount else {
			throw ParameterError(message: "values.count must correspond to SegmentControl.segmentCount")
		}
		
		for i in 0..<segmentCount {
			setSelected(values[i], forSegment: i)
		}
	}
}

struct ParameterError: Error {
	let message: String
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

