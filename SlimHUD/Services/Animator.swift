//
//  Animator.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/01/23.
//

import Cocoa

class Animator {
    
    private static var AnimationMovement: CGFloat = 20
    
    public static func popIn(hudView: NSView, originPosition: CGPoint) {
        hudView.setFrameOrigin(originPosition)
        hudView.alphaValue = 1
    }
    public static func slideIn(hudView: NSView, originPosition: CGPoint, screenEdge: Position) {
        hudView.alphaValue = 1
        switch screenEdge {
        case .left:
            hudView.setFrameOrigin(.init(x: originPosition.x - AnimationMovement, y: originPosition.y))
        case .right:
            hudView.setFrameOrigin(.init(x: originPosition.x + AnimationMovement, y: originPosition.y))
        case .top:
            hudView.setFrameOrigin(.init(x: originPosition.x, y: originPosition.y + AnimationMovement))
        case .bottom:
            hudView.setFrameOrigin(.init(x: originPosition.x, y: originPosition.y - AnimationMovement))
        }
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration
//            hudView.animator().alphaValue = 1 // TODO: decide if slide in should also fade
            hudView.animator().setFrameOrigin(originPosition)
        })
    }
    
    public static func fade(hudView: NSView, originPosition: CGPoint, screenEdge: Position) {
        hudView.alphaValue = 0
        hudView.setFrameOrigin(originPosition)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration
            hudView.animator().alphaValue = 1
        })
    }
    
    public static func growBlur(hudView: NSView, originPosition: CGPoint, screenEdge: Position) {
        // FIXME: not working for right and bottom edge
        hudView.alphaValue = 0
        let originalBounds = hudView.subviews[0].bounds
        hudView.setFrameOrigin(originPosition)
        switch screenEdge {
        case .left:
            hudView.setFrameOrigin(.init(x: originPosition.x - AnimationMovement, y: originPosition.y))
        case .right:
            hudView.setFrameOrigin(.init(x: originPosition.x + AnimationMovement, y: originPosition.y))
        case .top:
            hudView.setFrameOrigin(.init(x: originPosition.x, y: originPosition.y + AnimationMovement))
        case .bottom:
            hudView.setFrameOrigin(.init(x: originPosition.x, y: originPosition.y - AnimationMovement))
        }
        print(originPosition)
        print(hudView.frame.origin)
        switch screenEdge {
        case .left, .top:
            hudView.subviews[0].bounds = NSRect(x: 0,
                                                y: -(originalBounds.height / 4),
                                                width: originalBounds.width * 2,
                                                height: originalBounds.height * 2)
        case .bottom, .right:
            hudView.subviews[0].bounds = NSRect(x: 0,
                                                y: -(originalBounds.width / 4),
                                                width: originalBounds.width * 2,
                                                height: originalBounds.height * 2)
        }
        
        hudView.subviews[0].needsDisplay = true
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration * 3
            hudView.animator().setFrameOrigin(originPosition)
            hudView.animator().alphaValue = 1
            hudView.animator().subviews[0].bounds = originalBounds
        })
    }
}
