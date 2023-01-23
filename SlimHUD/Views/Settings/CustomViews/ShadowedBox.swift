//
//  ShadowedBox.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

@IBDesignable
class ShadowedBox: NSView {
    @IBInspectable var shadowColor: NSColor = .black
    
    @IBInspectable var backgroundColor: NSColor = .white
    
    @IBInspectable var shadowed: Bool = true
    
    override func awakeFromNib() {
        setupShadow(shadowed, 2, shadowColor.cgColor)
        layer?.backgroundColor = backgroundColor.cgColor
    }
}
