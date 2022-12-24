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

    func setupShadow(_ enabled: Bool, _ shadowRadius: CGFloat) {
        if enabled {
            shadow = NSShadow()
            wantsLayer = true
            superview?.wantsLayer = true
            layer?.shadowOpacity = 1
            layer?.shadowColor = .black
            layer?.shadowOffset = NSSize(width: 0, height: 0)
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
