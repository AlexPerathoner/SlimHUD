//
//  BaseView.swift
//  ProgressKit
//
//  Created by Kauntey Suryawanshi on 04/10/15.
//  Copyright (c) 2015 Kauntey Suryawanshi. All rights reserved.
//
//	Modified by Alexander Perathoner on 29/02/20
//

import AppKit

@IBDesignable
open class BaseView : NSView {

    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.configureLayers()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureLayers()
    }

    /// Configure the Layers
    func configureLayers() {
        self.wantsLayer = true
        notifyViewRedesigned()
    }

	@IBInspectable open var background: NSColor = NSColor(red: 0.34, green: 0.4, blue: 0.46, alpha: 1) {
        didSet {
            self.notifyViewRedesigned()
        }
    }

	@IBInspectable open var foreground: NSColor = NSColor(red: 0.26, green: 0.67, blue: 0.41, alpha: 1.0) {
        didSet {
            self.notifyViewRedesigned()
        }
    }

    @IBInspectable open var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.notifyViewRedesigned()
        }
    }

    /// Call when any IBInspectable variable is changed
    func notifyViewRedesigned() {
        self.layer?.backgroundColor = background.cgColor
        self.layer?.cornerRadius = cornerRadius
    }
}

