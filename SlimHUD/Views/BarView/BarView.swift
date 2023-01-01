//
//  BarView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

class BarView: NSView {

    static let BarViewNibFileName = "BarView"

    @IBOutlet weak var bar: ProgressBar!
    @IBOutlet var image: NSImageView!
    
    public func setIconRotation(isHorizontal: Bool) {
        if isHorizontal {
            while image.boundsRotation.truncatingRemainder(dividingBy: 360) != 90 {
                image.rotate(byDegrees: 90)
            }
        } else {
            while image.boundsRotation.truncatingRemainder(dividingBy: 360) != 0 {
                image.rotate(byDegrees: 90)
            }
        }
    }

}
