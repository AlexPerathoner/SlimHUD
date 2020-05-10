//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 27/04/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController, NSWindowDelegate {
	
	var previewTimer: Timer?
	func showingPreviewHUD(_ value: Bool) {
		if(value) {
			//send notification every second causing the bar to appear and be kept visible
			previewTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
				NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
			}
			RunLoop.current.add(previewTimer!, forMode: .eventTracking)
		} else {
			previewTimer?.invalidate()
			previewTimer = nil
		}
	}
	
	override func windowDidLoad() {
		super.windowDidLoad()
		showingPreviewHUD(true)
		window?.delegate = self
	}
	
	
	func windowWillClose(_ notification: Notification) {
		
		showingPreviewHUD(false)
		
	}
	
}
