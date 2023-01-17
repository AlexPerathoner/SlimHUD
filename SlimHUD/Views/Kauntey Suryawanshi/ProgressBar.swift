//
//  ProgressBar.swift
//  ProgressKit
//
//  Created by Kauntey Suryawanshi on 04/10/15.
//  Copyright (c) 2015 Kauntey Suryawanshi. All rights reserved.
//
//    Modified by Alexander Perathoner on 29/02/20
//

import Foundation
import Cocoa

@IBDesignable
open class ProgressBar: DeterminateAnimation {

    open var progressLayer = CAShapeLayer()
    private var animationDuration: CFTimeInterval = Constants.Animation.Duration

    func setupAnimationStyle(animationStyle: AnimationStyle) {
        if animationStyle == .None || animationStyle == .PopInFadeOut {
            animationDuration = 0
        } else {
            animationDuration = Constants.Animation.Duration
        }
    }

    override func notifyViewRedesigned() {
        super.notifyViewRedesigned()
        layer?.cornerRadius = frame.width / 2
        progressLayer.backgroundColor = foreground.cgColor
    }

    override func configureLayers() {
        super.configureLayers()

        progressLayer.frame = bounds
        progressLayer.frame.size.height = bounds.height
        progressLayer.cornerRadius = progressLayer.frame.width / 2
        progressLayer.backgroundColor = foreground.cgColor
        layer?.addSublayer(progressLayer)
    }

    override func updateProgress() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(animationDuration)
        let timingFunction = CAMediaTimingFunction(name: .easeOut)
        CATransaction.setAnimationTimingFunction(timingFunction)
        progressLayer.frame.size.height = bounds.height * CGFloat(progress)
        CATransaction.commit()
    }
}
