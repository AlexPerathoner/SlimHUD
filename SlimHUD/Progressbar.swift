
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
        
		let background = NSBezierPath(roundedRect: .init(x: 0, y: 0, width: rect.width, height: rect.height), xRadius: rect.width/2, yRadius: rect.width/2)
		trackColor.set()
		background.fill()
		
		let bar = NSBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rect.width, height: CGFloat(progressValue)/100*rect.height), xRadius: rect.width/2, yRadius: rect.width/2)
		barColor?.set()
		bar.fill()
		
		
	}
    
    
}
