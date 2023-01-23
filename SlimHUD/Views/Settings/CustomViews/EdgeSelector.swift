//
//  EdgeSelector.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/01/23.
//

import Cocoa

@IBDesignable
class EdgeSelector: NSView {
    var edge: Position = .left
    
    var buttonTop = RadioEdgeSelector(frame: .init(x: 72, y: 67, width: 18, height: 18))
    var buttonLeft = RadioEdgeSelector(frame: .init(x: 7, y: 37, width: 18, height: 18))
    var buttonRight = RadioEdgeSelector(frame: .init(x: 138, y: 37, width: 18, height: 18))
    var buttonBottom = RadioEdgeSelector(frame: .init(x: 72, y: 7, width: 18, height: 18))
    
    override func awakeFromNib() {
        for button in [buttonTop, buttonLeft, buttonRight, buttonBottom] {
            button.setButtonType(.radio)
            button.delegate = self
            addSubview(button)
        }
        
        buttonTop.edge = .top
        buttonLeft.edge = .left
        buttonRight.edge = .right
        buttonBottom.edge = .bottom
        
        buttonLeft.state = .on
    }
    
    func setEdge(item: RadioEdgeSelector) {
        edge = item.edge
        
        buttonTop.state = .off
        buttonLeft.state = .off
        buttonRight.state = .off
        buttonBottom.state = .off
        
        item.state = .on
        
        // TODO: update to delegate
    }
}

class RadioEdgeSelector: NSButton {
    weak var delegate: EdgeSelector?
    var edge: Position = .left
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        delegate?.setEdge(item: self)
    }
}
