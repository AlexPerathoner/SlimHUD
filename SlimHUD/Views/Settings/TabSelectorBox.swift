//
//  TabSelectorBox.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

@IBDesignable
class TabSelectorBox: ShadowedBox {
    @IBInspectable var tabTitle: String = ""
    @IBInspectable var image: NSImage?

    @IBOutlet weak var imageOutlet: NSImageView!
    @IBOutlet weak var titleOutlet: NSTextField!
    
    override func awakeFromNib() {
        titleOutlet.stringValue = tabTitle
        imageOutlet.image = image
    }
}
