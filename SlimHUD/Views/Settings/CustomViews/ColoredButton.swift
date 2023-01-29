//
//  ColoredButton.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 29/01/23.
//

import Cocoa

class ColoredButton: NSButton {
    @IBInspectable open var textColor: NSColor = NSColor.black
    @IBInspectable open var textSize: CGFloat = 10

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = alignment

        let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: textColor, .font: NSFont.systemFont(ofSize: textSize), .paragraphStyle: titleParagraphStyle]
        self.attributedTitle = NSMutableAttributedString(string: self.title, attributes: attributes)
    }
}
