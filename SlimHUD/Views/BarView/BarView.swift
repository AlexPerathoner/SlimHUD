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
    private var shadowView: NSView!

    override func awakeFromNib() {
        if let icon = icon { // not set in
            icon.wantsLayer = true
            icon.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
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

    public func setIconImage(icon: NSImage, force: Bool = false) {
        var color: NSColor?
        if #available(macOS 10.14, *) {
            color = self.icon.contentTintColor
        }
        if force || hasIconChanged(newIcon: icon) {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.1)

            let transition = CATransition()
            transition.type = CATransitionType.fade

            let timingFunction = CAMediaTimingFunction(name: .easeOut)
            CATransaction.setAnimationTimingFunction(timingFunction)

            self.icon.layer?.add(transition, forKey: kCATransition)
            self.icon.image = icon
            if #available(macOS 10.14, *) {
                self.icon.contentTintColor = color
            }

            CATransaction.commit()
        }
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
    
    public func setupShadowView(enabled: Bool, shadowRadius: CGFloat, color: CGColor = .black) {
        if enabled {
            shadowView = NSView(frame: self.frame.insetBy(dx: 5, dy: 5)) //adjust size
            shadowView.wantsLayer = true
            shadowView.layer?.cornerRadius = shadowRadius
            shadowView.layer?.backgroundColor = color
            shadowView.layer?.opacity = 1 // todo update / retrieve from color / maybe not necessary
            self.addSubview(shadowView, positioned: .below, relativeTo: self)
        } else {
            shadowView.removeFromSuperview()
        }
    }
}
