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
		AboutWindowController.hasIstance = true
		super.windowDidLoad()
		window?.delegate = self
	}

	func windowWillClose(_ notification: Notification) {
		
		SettingsWindowController.hasIstance = false
		
	}
	
}

