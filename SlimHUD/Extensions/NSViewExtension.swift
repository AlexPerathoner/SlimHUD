//
//  NSViewExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import Cocoa

extension NSView {
    func getCenter() -> CGPoint {
        return CGPoint(x: (self.frame.origin.x + (self.frame.size.width / 2)), y:
                        (self.frame.origin.y + (self.frame.size.height / 2)))
    }

    func setAnchorPoint (anchorPoint: CGPoint) {
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

    func setupShadow(_ enabled: Bool, _ shadowRadius: CGFloat, _ color: CGColor = .black, offset: NSSize = .zero) { // TODO: remove _
        if enabled {
            shadow = NSShadow()
            wantsLayer = true
            superview?.wantsLayer = true
            layer?.shadowOpacity = 1
            layer?.shadowColor = color
            layer?.shadowOffset = offset
            layer?.shadowRadius = shadowRadius
        } else {
            shadow = nil
        }
    }

    class func fromNib<T: NSView>(name: String, type: T.Type) -> T {
        var views: NSArray?
        if Bundle.main.loadNibNamed(name, owner: nil, topLevelObjects: &views) {
            if views?.firstObject is NSView {
                // swiftlint:disable:next force_cast
                return (views?.firstObject as! T)
            } else {
                // swiftlint:disable:next force_cast
                return (views?[1] as! T)
            }
        }
        fatalError("Could not find needed xib")
    }
}
