//
//  CustomView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

class CustomView: NSView {
    @IBInspectable var shadowColor: NSColor = .black
    
    @IBInspectable var backgroundColor: NSColor = .darkGray {
        didSet {
            layer?.backgroundColor = backgroundColor.cgColor
        }
    }
    
    @IBInspectable var shadowed: Bool = true
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    
    override func awakeFromNib() {
        setupShadow(shadowed, 2, shadowColor.cgColor)
        layer?.backgroundColor = backgroundColor.cgColor
        layer?.cornerRadius = cornerRadius
    }
}
