//
//  BarView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 10/05/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class BarView: NSView {
	
	@IBOutlet var view: BarView!
	@IBOutlet weak var bar: ProgressBar!
	@IBOutlet weak var image: NSImageView!
	
	func setImage(img: String) -> Bool {
		if let inputImage = NSImage(named: img) {
			image = NSImageView(image: inputImage)
			return true
		}
		return false
	}
	
}
