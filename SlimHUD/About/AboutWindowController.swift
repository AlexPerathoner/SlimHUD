//
//  AboutWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 02/05/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa


class AboutWindowController: NSWindowController, NSWindowDelegate {
	static var hasIstance = false
	
	override func windowDidLoad() {
		super.windowDidLoad()
		window?.delegate = self
		AboutWindowController.hasIstance = true
	}
	
	//FIXME: not being called
	func windowWillClose(_ notification: Notification) {
		AboutWindowController.hasIstance = false
	}
	
}

