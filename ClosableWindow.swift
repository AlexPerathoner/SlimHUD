//
//  ClosableWindow.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 11/05/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class ClosableWindow: NSWindowController {
	private var commandDown = false
	
	
	override func keyDown(with event: NSEvent) {
		super.keyDown(with: event)
		if commandDown && event.keyCode == 13 {
			window?.close()
		}
	}
	
	override func flagsChanged(with event: NSEvent) {
		super.flagsChanged(with: event)
		commandDown = (event.keyCode == 55)
	}
	
	
}
