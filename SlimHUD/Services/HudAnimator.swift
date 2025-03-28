//
//  HudAnimator.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/01/23.
//

import Cocoa

class HudAnimator {
    private static let GrowShrinkFactor: CGFloat = 1.6
    private static let GrowFactorComplementary: CGFloat = (1-GrowShrinkFactor) / 2
    private static let ShrinkFactorComplementary: CGFloat = (1-1/GrowShrinkFactor) / 2

    public static func popIn(barView: BarView) {
        barView.alphaValue = 1
    }
    public static func popOut(barView: BarView, completion: @escaping (() -> Void)) {
        barView.alphaValue = 0
        completion()
    }
    public static func slideIn(barView: BarView, originPosition: CGPoint) {
        barView.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 1
            barView.animator().setFrameOrigin(originPosition)
        })
    }
    public static func slideOut(barView: BarView, originPosition: CGPoint, screenEdge: Position, completion: @escaping (() -> Void)) {
        barView.alphaValue = 1
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 0
            barView.animator().setFrameOrigin(getAnimationFrameOrigin(originPosition: originPosition, screenEdge: screenEdge))
        }, completionHandler: completion)
    }

    public static func fadeIn(barView: BarView) {
        barView.alphaValue = 0
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 1
        })
    }
    public static func fadeOut(barView: BarView, completion: @escaping (() -> Void)) {
        barView.alphaValue = 1
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 0
        }, completionHandler: completion)
    }

    public static func growIn(barView: BarView) {
        barView.alphaValue = 0
        let originalBounds = barView.bounds
        barView.bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                            y: originalBounds.height * GrowFactorComplementary,
                                            width: originalBounds.width * GrowShrinkFactor,
                                            height: originalBounds.height * GrowShrinkFactor)

        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 1
            barView.animator().bounds = originalBounds
        }, completionHandler: {
            barView.bounds = originalBounds
        })
    }
    public static func growOut(barView: BarView, completion: @escaping (() -> Void)) {
        barView.alphaValue = 1
        let originalBounds = barView.bounds

        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 0
            barView.animator().bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                                y: originalBounds.height * GrowFactorComplementary,
                                                width: originalBounds.width * GrowShrinkFactor,
                                                height: originalBounds.height * GrowShrinkFactor)
        }, completionHandler: {
            barView.bounds = originalBounds
            completion()
        })
    }

    public static func shrinkIn(barView: BarView) {
        barView.alphaValue = 0
        let originalBounds = barView.bounds
        barView.bounds = NSRect(x: originalBounds.width * ShrinkFactorComplementary,
                                y: originalBounds.height * ShrinkFactorComplementary,
                                width: originalBounds.width / GrowShrinkFactor,
                                height: originalBounds.height / GrowShrinkFactor)
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 1
            barView.animator().bounds = originalBounds
        }, completionHandler: {
            barView.bounds = originalBounds
        })
    }
    public static func shrinkOut(barView: BarView, completion: @escaping (() -> Void)) {
        barView.alphaValue = 1
        let originalBounds = barView.bounds
        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 0
            barView.animator().bounds = NSRect(x: originalBounds.width * ShrinkFactorComplementary,
                                               y: originalBounds.height * ShrinkFactorComplementary,
                                               width: originalBounds.width / GrowShrinkFactor,
                                               height: originalBounds.height / GrowShrinkFactor)
        }, completionHandler: {
            barView.bounds = originalBounds
            completion()
        })
    }

    public static func sideGrowIn(barView: BarView, originPosition: CGPoint) {
        barView.alphaValue = 0

        let originalBounds = barView.bounds
        barView.bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                            y: originalBounds.height * GrowFactorComplementary,
                                            width: originalBounds.width * GrowShrinkFactor,
                                            height: originalBounds.height * GrowShrinkFactor)

        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 1
            barView.animator().setFrameOrigin(originPosition)
            barView.animator().bounds = originalBounds
        }, completionHandler: {
            barView.bounds = originalBounds
        })
    }
    public static func sideGrowOut(barView: BarView, originPosition: CGPoint, screenEdge: Position, completion: @escaping (() -> Void)) {
        barView.alphaValue = 1
        let originalBounds = barView.bounds

        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration
            barView.animator().alphaValue = 0
            barView.animator().setFrameOrigin(getAnimationFrameOrigin(originPosition: originPosition, screenEdge: screenEdge))
            barView.animator().bounds = NSRect(x: originalBounds.width * GrowFactorComplementary,
                                                y: originalBounds.height * GrowFactorComplementary,
                                                width: originalBounds.width * GrowShrinkFactor,
                                                height: originalBounds.height * GrowShrinkFactor)
        }, completionHandler: {
            barView.bounds = originalBounds
            completion()
        })
    }

    public static func getAnimationFrameOrigin(originPosition: CGPoint, screenEdge: Position) -> CGPoint {
        switch screenEdge {
        case .left:
            return CGPoint(x: originPosition.x - Constants.Animation.Movement, y: originPosition.y)
        case .right:
            return CGPoint(x: originPosition.x + Constants.Animation.Movement, y: originPosition.y)
        case .top:
            return CGPoint(x: originPosition.x, y: originPosition.y + Constants.Animation.Movement)
        case .bottom:
            return CGPoint(x: originPosition.x, y: originPosition.y - Constants.Animation.Movement)
        }
    }
}
