//
//  Animator.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/01/23.
//

import Cocoa

class Animator {
    
    private static var AnimationMovement: CGFloat = 20 // TODO: move to constants?
    private static var GrowFactor: CGFloat = 1.6 // TODO: Rename
    private static var GrowFactorComplementary: CGFloat = (1-GrowFactor) / 2
    private static var ShrinkFactorComplementary: CGFloat = (1-1/GrowFactor) / 2
    
    public static func popIn(hudView: NSView, originPosition: CGPoint) {
        hudView.setFrameOrigin(originPosition)
        hudView.alphaValue = 1
    }
    public static func popOut(hudView: NSView, originPosition: CGPoint, completion: @escaping (() -> Void)) {
        hudView.setFrameOrigin(originPosition)
        hudView.alphaValue = 0
        completion()
    }
    public static func slideIn(hudView: NSView, originPosition: CGPoint, screenEdge: Position) {
        hudView.alphaValue = 0
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
            hudView.animator().alphaValue = 1
            hudView.animator().setFrameOrigin(originPosition)
        })
    }
    public static func slideOut(hudView: NSView, originPosition: CGPoint, screenEdge: Position, completion: @escaping (() -> Void)) {
        hudView.alphaValue = 1
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration
            hudView.animator().alphaValue = 0
            switch screenEdge {
            case .left:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x - AnimationMovement, y: originPosition.y))
            case .right:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x + AnimationMovement, y: originPosition.y))
            case .top:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x, y: originPosition.y + AnimationMovement))
            case .bottom:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x, y: originPosition.y - AnimationMovement))
            }
        }, completionHandler: completion)
    }
    
    public static func fadeIn(hudView: NSView, originPosition: CGPoint) {
        hudView.alphaValue = 0
        hudView.setFrameOrigin(originPosition)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration
            hudView.animator().alphaValue = 1
        })
    }
    public static func fadeOut(hudView: NSView, originPosition: CGPoint, completion: @escaping (() -> Void)) {
        hudView.alphaValue = 1
        hudView.setFrameOrigin(originPosition)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration
            hudView.animator().alphaValue = 0
        }, completionHandler: completion)
    }
    
    public static func growIn(hudView: NSView, originPosition: CGPoint) {
        hudView.alphaValue = 0
        let originalBounds = hudView.subviews[0].bounds // TODO: find better way to access this
        hudView.setFrameOrigin(originPosition)
        hudView.subviews[0].bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                            y: originalBounds.height * GrowFactorComplementary,
                                            width: originalBounds.width * GrowFactor,
                                            height: originalBounds.height * GrowFactor)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration
            hudView.animator().alphaValue = 1
            hudView.animator().subviews[0].bounds = originalBounds
        })
    }
    public static func growOut(hudView: NSView, originPosition: CGPoint, completion: @escaping (() -> Void)) {
        hudView.alphaValue = 1
        let originalBounds = hudView.subviews[0].bounds // TODO: find better way to access this
        hudView.setFrameOrigin(originPosition)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration
            hudView.animator().alphaValue = 0
            hudView.animator().subviews[0].bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                                y: originalBounds.height * GrowFactorComplementary,
                                                width: originalBounds.width * GrowFactor,
                                                height: originalBounds.height * GrowFactor)
        }, completionHandler: {
            hudView.subviews[0].bounds = originalBounds
            completion()
        })
    }
    
    // TODO: shrink messes up with the container view -> update originPosition
    public static func shrinkIn(hudView: NSView, originPosition: CGPoint) { // TODO: Very similar to growIn / Out, refactor
        hudView.alphaValue = 0
        let originalBounds = hudView.subviews[0].bounds // TODO: find better way to access this
        hudView.setFrameOrigin(originPosition)
        print(originalBounds, GrowFactorComplementary)
        print(-originalBounds.width * ShrinkFactorComplementary)
        hudView.subviews[0].bounds = NSRect(x: originalBounds.width * ShrinkFactorComplementary,
                                            y: originalBounds.height * ShrinkFactorComplementary,
                                            width: originalBounds.width / GrowFactor,
                                            height: originalBounds.height / GrowFactor)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration * 5
            hudView.animator().alphaValue = 1
            hudView.animator().subviews[0].bounds = originalBounds
            print(originalBounds)
        })
    }
    
    public static func shrinkOut(hudView: NSView, originPosition: CGPoint, completion: @escaping (() -> Void)) {
        hudView.alphaValue = 1
        let originalBounds = hudView.subviews[0].bounds // TODO: find better way to access this
        hudView.setFrameOrigin(originPosition)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.AnimationDuration * 5
            hudView.animator().alphaValue = 0
            hudView.animator().subviews[0].bounds = NSRect(x: originalBounds.width * ShrinkFactorComplementary,
                                                y: originalBounds.height * ShrinkFactorComplementary,
                                                width: originalBounds.width / GrowFactor,
                                                height: originalBounds.height / GrowFactor)
        }, completionHandler: {
            hudView.subviews[0].bounds = originalBounds
            completion()
        })
    }
    
    // TODO: check all with all edges
}
