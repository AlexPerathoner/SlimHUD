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
    
    override func awakeFromNib() {
        icon.wantsLayer = true
        icon.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    public func hideIcon(isHidden: Bool) {
        icon.isHidden = isHidden
    }

    @available(OSX 10.14, *)
    public func setIconTint(_ color: NSColor) {
        icon.contentTintColor = color
    }
    
    private func hasIconChanged(newIcon: NSImage) -> Bool {
        return icon.image != newIcon
    }

    public func setIconImage(icon: NSImage) {
        if hasIconChanged(newIcon: icon) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.1)
            
            let transition = CATransition()
            transition.type = CATransitionType.fade
            
            self.icon.layer?.add(transition, forKey: kCATransition)
            self.icon.image = icon
            
            CATransaction.commit()
        }
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
