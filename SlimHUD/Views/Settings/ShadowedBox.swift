//
//  ShadowedBox.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

@IBDesignable
class ShadowedBox: NSBox {
    @IBInspectable var shadowColor: NSColor = .black {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 3, height: 3) {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 15.0 {
        didSet {
            self.updateView()
        }
    }

    //Apply params
    func updateView() {
        self.layer?.shadowColor = self.shadowColor.cgColor
        self.layer?.shadowOpacity = self.shadowOpacity
        self.layer?.shadowOffset = self.shadowOffset
        self.layer?.shadowRadius = self.shadowRadius
    }
}
