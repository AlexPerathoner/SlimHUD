//
//  BarView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 10/05/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class BarView: NSView {
	
	@IBOutlet weak var bar: ProgressBar!
	@IBOutlet var image: NSImageView!
	
	func setImage(img: String) {
		if let inputImage = NSImage(named: img) {
			image = NSImageView(image: inputImage)
			image.frame.size = inputImage.size
		}
	}
	
}
