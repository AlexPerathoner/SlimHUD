//
//  StandardLabel.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

@IBDesignable
class StandardLabel: NSTextField {
    
    @IBInspectable var fontSize: CGFloat = 11
    @IBInspectable var lineSpacing: CGFloat = 5
    @IBInspectable var bold: Bool = true
    
    override func awakeFromNib() {
        if bold {
            font = NSFont.init(name: "SF Pro Semibold", size: fontSize)
        } else {
            font = NSFont.init(name: "SF Pro", size: fontSize)
        }
        
        
        isEditable = false
        isSelectable = false
        isBordered = false
        isBezeled = false
        drawsBackground = false
        
        updateSpacing()
    }
    
    func updateSpacing() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.maximumLineHeight = fontSize
        paragraphStyle.alignment = alignment

        let attrString = NSMutableAttributedString(string: self.stringValue)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        self.attributedStringValue = attrString
    }
}
