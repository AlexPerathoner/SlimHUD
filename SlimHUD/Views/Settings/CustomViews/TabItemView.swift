//
//  TabItemView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

@IBDesignable
class TabItemView: NSView {
    @IBInspectable var image: NSImage!
    @IBInspectable var title: String = "About"
    @IBInspectable var selected: Bool = false {
        didSet {
            updateSelectionStyle()
        }
    }
    
    private static let selectedColor = NSColor(red:0, green:0.4784, blue:1, alpha:1.0)
    private static let unselectedColor = NSColor(red:0.494, green:0.494, blue:0.494, alpha:1.0)
    
    private var textField: NSTextField?
    private var imageView: NSImageView?
    
    weak var delegate: TabsView?
    
    override func awakeFromNib() {
        textField = createLabel()
        imageView = createImageView()
        addSubview(imageView!)
        addSubview(textField!)
        setupBorder()
        updateSelectionStyle()
    }
    
    private func createLabel() -> NSTextField {
        let textField = NSTextField(string: title)
        textField.alignment = .center
        textField.setFrameSize(NSSize(width: 70, height: 16))
        textField.setFrameOrigin(.init(x: 0, y: 2))
        textField.font = NSFont.systemFont(ofSize: 11)
        textField.isEditable = false
        textField.isSelectable = false
        textField.isBordered = false
        textField.isBezeled = false
        textField.drawsBackground = false
        return textField
    }
    
    private func createImageView() -> NSImageView {
        let imageView = NSImageView(image: image)
        imageView.alignment = .center
        imageView.setFrameSize(NSSize(width: 70, height: 23))
        imageView.setFrameOrigin(.init(x: 0, y: 18))
        imageView.isEditable = false
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
    }
    
    private func setupBorder() {
        self.wantsLayer = true
        self.layer?.cornerRadius = 5
    }
    
    private func updateSelectionStyle() {
        if selected {
            self.layer?.backgroundColor = .init(gray: 0, alpha: 0.05)
        } else {
            self.layer?.backgroundColor = .init(gray: 0, alpha: 0)
        }
        if selected {
            textField?.textColor = TabItemView.selectedColor
        } else {
            textField?.textColor = TabItemView.unselectedColor
        }
        if #available(macOS 10.14, *) {
            if selected {
                imageView?.contentTintColor = TabItemView.selectedColor
            } else {
                imageView?.contentTintColor = TabItemView.unselectedColor
            }
        }
        setupShadow(selected, 2, .init(gray: 0, alpha: 0.13), offset: NSSize(width: -2, height: 2))
    }
    
    // TODO: widnow title of settings not visible
    
    
    // TODO: add method to select, add delegate, which should change view
    
    // TODO: add tabView manager, which shows all the items, does all the stuff

    override func mouseUp(with event: NSEvent) {
        selected = true
        updateSelectionStyle()
        delegate?.selectItem(item: self)
    }
    
    override func mouseDown(with event: NSEvent) {
        self.layer?.backgroundColor = .init(gray: 0, alpha: 0.2)
    }
    
    override func mouseEntered(with event: NSEvent) {
        self.layer?.backgroundColor = .init(gray: 0, alpha: 0.1)
    }
    
    override func mouseExited(with event: NSEvent) {
        if selected {
            self.layer?.backgroundColor = .init(gray: 0, alpha: 0.05)
        } else {
            self.layer?.backgroundColor = .init(gray: 0, alpha: 0)
        }
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if !self.trackingAreas.isEmpty {
            for trackingArea in trackingAreas {
                self.removeTrackingArea(trackingArea)
            }
        }

        let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
        let trackingArea = NSTrackingArea(rect: self.bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
}
