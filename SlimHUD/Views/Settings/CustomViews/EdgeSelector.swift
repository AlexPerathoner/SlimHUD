//
//  EdgeSelector.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/01/23.
//

import Cocoa

class EdgeSelector: NSView {
    private var edge: Position = .left
    weak var delegate: ConfigViewController?
    
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
    }
    
    // used by the delegate to update the buttons' states
    func setEdge(edge: Position) {
        buttonTop.state = .off
        buttonLeft.state = .off
        buttonRight.state = .off
        buttonBottom.state = .off
        switch edge {
        case .bottom:
            buttonBottom.state = .on
        case .right:
            buttonRight.state = .on
        case .left:
            buttonLeft.state = .on
        case .top:
            buttonTop.state = .on
        }
    }
    
    // used by the children buttons
    func setEdge(item: RadioEdgeSelector) {
        edge = item.edge
        
        buttonTop.state = .off
        buttonLeft.state = .off
        buttonRight.state = .off
        buttonBottom.state = .off
        
        item.state = .on
        delegate?.setPosition(edge: edge)
    }
    
    private static let Width = 163.0
    private static let Height = 92.0
    private static let ViewRatio = Height / Width
    private static let Origin = NSPoint(x: 200, y: 284)
    override func mouseDown(with event: NSEvent) {
        let normalizedX = Double(event.locationInWindow.x - EdgeSelector.Origin.x) * EdgeSelector.ViewRatio
        let y = Double(event.locationInWindow.y - EdgeSelector.Origin.y)
        let invertedY = EdgeSelector.Height - y

        var clickedEdge: Position = .right
        if normalizedX < y {
            if normalizedX < invertedY {
                clickedEdge = .left
            } else {
                clickedEdge = .top
            }
        } else {
            if normalizedX < invertedY {
                clickedEdge = .bottom
            } else {
                clickedEdge = .right
            }
        }
        setEdge(edge: clickedEdge)
        delegate?.setPosition(edge: clickedEdge)
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
