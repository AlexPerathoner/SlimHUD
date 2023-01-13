//
//  BarView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

class BarView: NSView {

    static let BarViewNibFileName = "BarView"

    @IBOutlet weak var bar: ProgressBar!
    @IBOutlet private var icon: NSImageView!

    public func setupIconAnchorPointAndLayer() {
        icon.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        icon.wantsLayer = true
    }

    public func hideIcon(isHidden: Bool) {
        icon.isHidden = isHidden
    }

    @available(OSX 10.14, *)
    public func setIconTint(_ color: NSColor) {
        icon.contentTintColor = color
    }

    public func setIconImage(icon: NSImage) {
        self.icon.image = icon
    }
    public func setIconImageView(icon: NSImageView) {
        self.icon = icon
    }
    public func setBar(bar: ProgressBar) {
        self.bar = bar
    }

    public func setIconRotation(isHorizontal: Bool) {
        if isHorizontal {
            while icon.boundsRotation.truncatingRemainder(dividingBy: 360) != 90 {
                icon.rotate(byDegrees: 90)
            }
        } else {
            while icon.boundsRotation.truncatingRemainder(dividingBy: 360) != 0 {
                icon.rotate(byDegrees: 90)
            }
        }
    }

}
