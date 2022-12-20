//
//  ProgressBar.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
/*
 @IBDesignable
 open class ProgressBar: NSView {

 private var windowController: NSWindowController?

 static let shared = ProgressBar()

 // Progress bar color
 @IBInspectable public var barColor: NSColor = blue

 // Track color
 @IBInspectable public var trackColor: NSColor = .init(white: 0.29, alpha: 0.56)


 // Progress amount
 @IBInspectable public var progressValue: Int = 0 {
 didSet {
 needsDisplay = true
 }
 }

 public override init(frame: CGRect) {
 super.init(frame: frame)
 }

 public required init?(coder aDecoder: NSCoder) {
 super.init(coder: aDecoder)
 }

 override open func draw(_ rect: CGRect) {

 super.draw(rect)
 let track = NSBezierPath(roundedRect: .init(x: 0, y: 0, width: rect.width, height: rect.height), xRadius: rect.width/2, yRadius: rect.width/2)
 trackColor.set()
 track.fill()

 let bar = NSBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: CGFloat(progressValue)/100*rect.height), xRadius: rect.width/2, yRadius: rect.width/2)
 barColor.set()
 bar.fill()
 }
 }*/
/*
 open class ProgressBar: NSView {
 override public init(frame frameRect: NSRect) {
 super.init(frame: frameRect)
 self.configureLayers()
 }

 required public init?(coder: NSCoder) {
 super.init(coder: coder)
 self.configureLayers()
 }


 @IBInspectable open var background: NSColor = .init(white: 0.29, alpha: 0.56) {
 didSet {
 self.notifyViewRedesigned()
 }
 }

 @IBInspectable open var foreground: NSColor = blue {
 didSet {
 self.notifyViewRedesigned()
 }
 }

 @IBInspectable open var cornerRadius: CGFloat = 5.0 {
 didSet {
 self.notifyViewRedesigned()
 }
 }


 @IBInspectable open var animated: Bool = true

 /// Value of progress now. Range 0..1
 @IBInspectable open var progress: CGFloat = 0 {
 didSet {
 updateProgress()
 }
 }


 open var borderLayer = CAShapeLayer()
 open var progressLayer = CAShapeLayer()

 @IBInspectable open var borderColor: NSColor = .black {
 didSet {
 notifyViewRedesigned()
 }
 }

 func notifyViewRedesigned() {
 self.layer?.cornerRadius = self.frame.height / 2
 borderLayer.borderColor = borderColor.cgColor
 progressLayer.backgroundColor = foreground.cgColor
 }

 func configureLayers() {

 borderLayer.frame = self.bounds
 borderLayer.cornerRadius = borderLayer.frame.height / 2
 borderLayer.borderWidth = 1.0
 self.layer?.addSublayer(borderLayer)

 progressLayer.frame = NSInsetRect(borderLayer.bounds, 3, 3)
 progressLayer.frame.size.width = (borderLayer.bounds.width - 6)
 progressLayer.cornerRadius = progressLayer.frame.height / 2
 progressLayer.backgroundColor = foreground.cgColor
 borderLayer.addSublayer(progressLayer)

 }

 func updateProgress() {
 CATransaction.begin()
 if animated {
 CATransaction.setAnimationDuration(0.1)
 } else {
 CATransaction.setDisableActions(true)
 }
 let timing = CAMediaTimingFunction(name: .easeOut)
 CATransaction.setAnimationTimingFunction(timing)
 progressLayer.frame.size.width = (borderLayer.bounds.width - 6) * progress
 CATransaction.commit()
 }
 }*/

extension NSView {
    func rotate(_ n: CGFloat) {
        if let layer = self.layer, let animatorLayer = self.animator().layer {
            layer.position = CGPoint(x: layer.frame.midX, y: layer.frame.midY)
            layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.allowsImplicitAnimation = true
            animatorLayer.transform = CATransform3DMakeRotation(n*CGFloat.pi / 2, 0, 0, 1)
            NSAnimationContext.endGrouping()
        }
    }
}
