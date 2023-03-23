//
//  CALayer.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/03/23.
//

import Cocoa

extension CALayer {

    /// from https://stackoverflow.com/questions/75662388/how-to-combine-nest-calayer-masks
    func flatten() -> CALayer {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
              let ctx = CGContext(data: nil, width: Int(bounds.width), height: Int(bounds.height), bitsPerComponent: 8, bytesPerRow: 4*Int(bounds.width), space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return CALayer() }

        ctx.translateBy(x: 0, y: bounds.height)
        ctx.scaleBy(x: 1.0, y: -1.0)

        render(in: ctx)
        let image = ctx.makeImage()

        let flattenedLayer = CALayer()
        flattenedLayer.frame = frame
        flattenedLayer.contents = image

        return flattenedLayer
    }
}
