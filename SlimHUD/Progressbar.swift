
//
//  ProgressBar.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

@IBDesignable
open class ProgressBar: NSView {

	private var windowController: NSWindowController?
	
    static let shared = ProgressBar()
	
    // Progress bar color
	@IBInspectable public var barColor: NSColor? = blue
	
    // Track color
    @IBInspectable public var trackColor: NSColor = NSColor.secondaryLabelColor
    
	
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
        
		guard let context = NSGraphicsContext.current?.cgContext else {return}
		
        // Track Bar
		
		var rectHeight = frame.size.height - 5 / 2
		// Find center of actual frame to set rectangle in middle
		var xf:CGFloat = (self.frame.width  - 8)  / 2
		var yf:CGFloat = (self.frame.height - rectHeight) / 2
		context.saveGState()
		var rect = CGRect(x: xf, y: yf, width: 8, height: rectHeight)
		var clipPath: CGPath = NSBezierPath(roundedRect: rect, xRadius: 5, yRadius: 5).cgPath

		context.addPath(clipPath)
		context.setFillColor(trackColor.cgColor)

		context.closePath()
		context.fillPath()
		context.restoreGState()
		
        // Progress Bar
		
		if(percentage() != 0) {
			
			rectHeight = 4 + percentage() + 5/2
			// Find center of actual frame to set rectangle in middle
			xf = (self.frame.width  - 8)  / 2
			yf = 0
			context.saveGState()
			rect = CGRect(x: xf, y: yf, width: 8, height: rectHeight)
			clipPath = NSBezierPath(roundedRect: rect, xRadius: 5, yRadius: 5).cgPath

			context.addPath(clipPath)
			
			context.setFillColor(barColor!.cgColor)
			context.closePath()
			context.fillPath()
			context.restoreGState()
		}
    }
    
    private func percentage() -> CGFloat {
        let screenWidth = frame.size.height - 8
        return (CGFloat(progressValue) / 100) * screenWidth
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
			@unknown default:
				NSLog("unknown case")
			}
        }
        return path
    }

}
