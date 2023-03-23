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
    private var shadowColor: NSColor = .black
    private var shadowRadius: Int = 0
    private var shadowInset: Int = 5
    private var shadowEnabled: Bool = false

    override func awakeFromNib() {
        if let icon = icon { // not set in
            icon.wantsLayer = true
            icon.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        }
    }

    public func hideIcon(isHidden: Bool) {
        icon.isHidden = isHidden
        updateShadowView()
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

    public func setupShadowAsView(enabled: Bool, radius: Int, color: NSColor = .black, inset: Int = 5) {
        shadowColor = color
        shadowEnabled = enabled
        shadowInset = inset
        shadowRadius = radius
        updateShadowView()
    }
    
    public func updateShadowView() {
        if shadowView != nil {
            shadowView.removeFromSuperview()
            shadowView = nil
        }
        if shadowEnabled {
            shadowView = NSView(frame: calculateShadowFrame())
            shadowView.wantsLayer = true
            shadowView.layer?.cornerRadius = (min(self.frame.height, self.frame.width) - CGFloat(shadowInset * 2)) / 2.2 // rounded rectangle
            // todo use CGFloat(shadowRadius) https://stackoverflow.com/questions/36490270/how-to-make-a-uiview-have-an-effect-of-transparent-gradient
            shadowView.layer?.backgroundColor = shadowColor.cgColor
            self.addSubview(shadowView, positioned: .below, relativeTo: icon.isHidden ? bar : self)
        }
    }
    
    private func calculateShadowFrame() -> NSRect {
        if icon.isHidden {
            return bar.frame.insetBy(dx: CGFloat(-20+(shadowInset)), dy: CGFloat(-20+shadowInset))
        } else {
            let size = self.frame.insetBy(dx: CGFloat(shadowInset), dy: CGFloat(shadowInset)).size
            let origin = NSPoint(x: CGFloat((shadowInset)), y: CGFloat((shadowInset)))
            return NSRect(origin: origin, size: size)
        }
    }
}
