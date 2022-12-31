//
//  ProgressBar.swift
//  ProgressKit
//
//  Created by Kauntey Suryawanshi on 04/10/15.
//  Copyright (c) 2015 Kauntey Suryawanshi. All rights reserved.
//
//	Modified by Alexander Perathoner on 29/02/20
//

import Foundation
import Cocoa

@IBDesignable
open class ProgressBar: DeterminateAnimation {

    open var progressLayer = CAShapeLayer()
    private var animationTime: CFTimeInterval = 0.36

    open func setupAnimation(animated: Bool) {
        if animated {
            animationTime = 0.36
        } else {
            animationTime = 0
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
        CATransaction.setAnimationDuration(animationTime)
        let timing = CAMediaTimingFunction(name: .easeOut)
        CATransaction.setAnimationTimingFunction(timing)
        progressLayer.frame.size.height = bounds.height * CGFloat(progress)
        CATransaction.commit()
    }
}
