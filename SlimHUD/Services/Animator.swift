//
//  Animator.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/01/23.
//

import Cocoa

class Animator {
    private static let GrowShrinkFactor: CGFloat = 1.6
    private static let GrowFactorComplementary: CGFloat = (1-GrowShrinkFactor) / 2
    private static let ShrinkFactorComplementary: CGFloat = (1-1/GrowShrinkFactor) / 2
    
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
            hudView.setFrameOrigin(.init(x: originPosition.x - Constants.Animation.Movement, y: originPosition.y))
        case .right:
            hudView.setFrameOrigin(.init(x: originPosition.x + Constants.Animation.Movement, y: originPosition.y))
        case .top:
            hudView.setFrameOrigin(.init(x: originPosition.x, y: originPosition.y + Constants.Animation.Movement))
        case .bottom:
            hudView.setFrameOrigin(.init(x: originPosition.x, y: originPosition.y - Constants.Animation.Movement))
        }
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            hudView.animator().alphaValue = 1
            hudView.animator().setFrameOrigin(originPosition)
        })
    }
    public static func slideOut(hudView: NSView, originPosition: CGPoint, screenEdge: Position, completion: @escaping (() -> Void)) {
        hudView.alphaValue = 1
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            hudView.animator().alphaValue = 0
            switch screenEdge {
            case .left:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x - Constants.Animation.Movement, y: originPosition.y))
            case .right:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x + Constants.Animation.Movement, y: originPosition.y))
            case .top:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x, y: originPosition.y + Constants.Animation.Movement))
            case .bottom:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x, y: originPosition.y - Constants.Animation.Movement))
            }
        }, completionHandler: completion)
    }
    
    public static func fadeIn(hudView: NSView, originPosition: CGPoint) {
        hudView.alphaValue = 0
        hudView.setFrameOrigin(originPosition)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            hudView.animator().alphaValue = 1
        })
    }
    public static func fadeOut(hudView: NSView, originPosition: CGPoint, completion: @escaping (() -> Void)) {
        hudView.alphaValue = 1
        hudView.setFrameOrigin(originPosition)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            hudView.animator().alphaValue = 0
        }, completionHandler: completion)
    }
    
    public static func growIn(hudView: NSView, originPosition: CGPoint) {
        hudView.alphaValue = 0
        let originalBounds = hudView.subviews[0].bounds // TODO: find better way to access this
        hudView.setFrameOrigin(originPosition)
        hudView.subviews[0].bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                            y: originalBounds.height * GrowFactorComplementary,
                                            width: originalBounds.width * GrowShrinkFactor,
                                            height: originalBounds.height * GrowShrinkFactor)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            hudView.animator().alphaValue = 1
            hudView.animator().subviews[0].bounds = originalBounds
        })
    }
    public static func growOut(hudView: NSView, originPosition: CGPoint, completion: @escaping (() -> Void)) {
        hudView.alphaValue = 1
        let originalBounds = hudView.subviews[0].bounds // TODO: find better way to access this
        hudView.setFrameOrigin(originPosition)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            hudView.animator().alphaValue = 0
            hudView.animator().subviews[0].bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                                y: originalBounds.height * GrowFactorComplementary,
                                                width: originalBounds.width * GrowShrinkFactor,
                                                height: originalBounds.height * GrowShrinkFactor)
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
                                            width: originalBounds.width / GrowShrinkFactor,
                                            height: originalBounds.height / GrowShrinkFactor)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
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
            context.duration = Constants.Animation.Duration
            hudView.animator().alphaValue = 0
            hudView.animator().subviews[0].bounds = NSRect(x: originalBounds.width * ShrinkFactorComplementary,
                                                y: originalBounds.height * ShrinkFactorComplementary,
                                                width: originalBounds.width / GrowShrinkFactor,
                                                height: originalBounds.height / GrowShrinkFactor)
        }, completionHandler: {
            hudView.subviews[0].bounds = originalBounds
            completion()
        })
    }
    
    public static func sideGrowIn(hudView: NSView, originPosition: CGPoint, screenEdge: Position) {
        hudView.alphaValue = 0
        switch screenEdge {
        case .left:
            hudView.setFrameOrigin(.init(x: originPosition.x - Constants.Animation.Movement, y: originPosition.y))
        case .right:
            hudView.setFrameOrigin(.init(x: originPosition.x + Constants.Animation.Movement, y: originPosition.y))
        case .top:
            hudView.setFrameOrigin(.init(x: originPosition.x, y: originPosition.y + Constants.Animation.Movement))
        case .bottom:
            hudView.setFrameOrigin(.init(x: originPosition.x, y: originPosition.y - Constants.Animation.Movement))
        }
        
        let originalBounds = hudView.subviews[0].bounds // TODO: find better way to access this
        hudView.subviews[0].bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                            y: originalBounds.height * GrowFactorComplementary,
                                            width: originalBounds.width * GrowShrinkFactor,
                                            height: originalBounds.height * GrowShrinkFactor)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            hudView.animator().alphaValue = 1
            hudView.animator().setFrameOrigin(originPosition)
            hudView.animator().subviews[0].bounds = originalBounds
        })
    }
    public static func sideGrowOut(hudView: NSView, originPosition: CGPoint, screenEdge: Position, completion: @escaping (() -> Void)) {
        hudView.alphaValue = 1
        let originalBounds = hudView.subviews[0].bounds // TODO: find better way to access this
        hudView.setFrameOrigin(originPosition)
        
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            hudView.animator().alphaValue = 0
            switch screenEdge {
            case .left:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x - Constants.Animation.Movement, y: originPosition.y))
            case .right:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x + Constants.Animation.Movement, y: originPosition.y))
            case .top:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x, y: originPosition.y + Constants.Animation.Movement))
            case .bottom:
                hudView.animator().setFrameOrigin(.init(x: originPosition.x, y: originPosition.y - Constants.Animation.Movement))
            }
            hudView.animator().subviews[0].bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                                y: originalBounds.height * GrowFactorComplementary,
                                                width: originalBounds.width * GrowShrinkFactor,
                                                height: originalBounds.height * GrowShrinkFactor)
        }, completionHandler: {
            hudView.subviews[0].bounds = originalBounds
            completion()
        })
    }
}
