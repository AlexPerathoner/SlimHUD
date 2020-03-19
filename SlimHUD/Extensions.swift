//
//  Extensions.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

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
}
