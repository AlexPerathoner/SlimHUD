
//
//  JCGGProgressBar.swift
//  JCGGProgressBar
//
//  Created by Jacob Gold on 23/3/19.
//  Copyright © 2019 Jacob Gold. All rights reserved.
//
//	Modified by Alexander Perathoner on 19/2/20
//

import Cocoa

@IBDesignable
open class JCGGProgressBar: NSView {

	private var windowController: NSWindowController?
	
    static let shared = JCGGProgressBar()
	
    // Progress bar color
    @IBInspectable public var barColor: NSColor = NSColor.labelColor
	
    // Track color
    @IBInspectable public var trackColor: NSColor = NSColor.secondaryLabelColor
    
	
    public var barThickness: CGFloat = 8
    // Progress amount
    @IBInspectable public var progressValue: CGFloat = 0 {
        didSet {
            progressValue = min(max(progressValue, 0), 100)
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
        
		guard let context = NSGraphicsContext.current?.cgContext else {return}
		
		let radius: CGFloat = 5
		
        // Track Bar
		
		var rectWidth = barThickness
		var rectHeight = frame.size.height - radius / 2
		// Find center of actual frame to set rectangle in middle
		var xf:CGFloat = (self.frame.width  - rectWidth)  / 2
		var yf:CGFloat = (self.frame.height - rectHeight) / 2
		context.saveGState()
		var rect = CGRect(x: xf, y: yf, width: rectWidth, height: rectHeight)
		var clipPath: CGPath = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).cgPath

		context.addPath(clipPath)
		context.setFillColor(trackColor.cgColor)

		context.closePath()
		context.fillPath()
		context.restoreGState()
		
        // Progress Bar
		
		if(percentage() != 0) {
			rectWidth = barThickness
			rectHeight = (barThickness / 2) + percentage() + radius/2
			// Find center of actual frame to set rectangle in middle
			xf = (self.frame.width  - rectWidth)  / 2
			yf = 0
			context.saveGState()
			rect = CGRect(x: xf, y: yf, width: rectWidth, height: rectHeight)
			clipPath = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).cgPath

			context.addPath(clipPath)
			
			context.setFillColor(barColor.cgColor)
			context.closePath()
			context.fillPath()
			context.restoreGState()
		}
    }
    
    private func percentage() -> CGFloat {
        let screenWidth = frame.size.height - barThickness
        return ((progressValue / 100) * screenWidth)
    }
    
}

public extension NSBezierPath {

    var cgPath: CGPath {
        let path = CGMutablePath()
        var points = [CGPoint](repeating: .zero, count: 3)
        for i in 0 ..< self.elementCount {
            let type = self.element(at: i, associatedPoints: &points)
            switch type {
			case .moveTo: path.move(to: points[0])
			case .lineTo: path.addLine(to: points[0])
			case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
			case .closePath: path.closeSubpath()
			}
        }
        return path
    }

}
