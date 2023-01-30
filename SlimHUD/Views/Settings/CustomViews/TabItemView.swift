//
//  TabItemView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

class TabItemView: CustomView {
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
    
    var index = 0
    
    override func awakeFromNib() {
        textField = createLabel()
        imageView = createImageView()
        addSubview(imageView!)
        addSubview(textField!)
        self.cornerRadius = 5
        backgroundColorName = "SelectionColor"
        updateSelectionStyle()
        super.awakeFromNib()
    }
    
    private func createLabel() -> NSTextField {
        let newTextField = NSTextField(string: title)
        newTextField.alignment = .center
        newTextField.setFrameSize(NSSize(width: 70, height: 16))
        newTextField.setFrameOrigin(.init(x: 0, y: 2))
        newTextField.font = NSFont.init(name: "SF Pro", size: 10)
        newTextField.isEditable = false
        newTextField.isSelectable = false
        newTextField.isBordered = false
        newTextField.isBezeled = false
        newTextField.drawsBackground = false
        return newTextField
    }
    
    private func createImageView() -> NSImageView {
        let newImageView = NSImageView(image: image)
        newImageView.alignment = .center
        newImageView.setFrameSize(NSSize(width: 70, height: 20))
        newImageView.setFrameOrigin(.init(x: 0, y: 20))
        newImageView.isEditable = false
        newImageView.imageScaling = .scaleProportionallyUpOrDown
        return newImageView
    }
    
    private func updateSelectionStyle() {
        updateBackgroundColor()
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
        setupShadow(enabled: selected, shadowRadius: 2, color: .init(gray: 0, alpha: 0.13), offset: NSSize(width: -2, height: 2))
    }

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
        updateBackgroundColor()
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
    
    override func updateBackgroundColor() {
        if selected {
            self.layer?.backgroundColor = NSColor(named: backgroundColorName)?.cgColor
        } else {
            self.layer?.backgroundColor = .init(gray: 0, alpha: 0)
        }
    }
}
