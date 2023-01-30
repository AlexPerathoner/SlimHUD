//
//  CustomView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

class CustomView: NSView {
    @IBInspectable var shadowColor: NSColor = .black
    
    @IBInspectable var backgroundColorName: String = "" {
        didSet {
            updateBackgroundColor()
        }
    }
    
    @IBInspectable var shadowed: Bool = true
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    
    override func awakeFromNib() {
        setupShadow(enabled: shadowed, shadowRadius: 2, color: shadowColor.cgColor)
        layer?.backgroundColor = NSColor(named: backgroundColorName)?.cgColor
        layer?.cornerRadius = cornerRadius
        DistributedNotificationCenter.default.addObserver(self, selector: #selector(updateBackgroundColor), name: NSNotification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
    }
    
    @objc func updateBackgroundColor() {
        layer?.backgroundColor = NSColor(named: backgroundColorName)?.cgColor
    }
}
