//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 27/04/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class SettingsWindowController: ClosableWindow, NSWindowDelegate {
	
	var previewTimer: Timer?
	
	override func windowDidLoad() {
		super.windowDidLoad()
		window?.delegate = self
		
		//send notification every second causing the bar to appear and be kept visible
		previewTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { (t) in
			NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
		}
		RunLoop.current.add(previewTimer!, forMode: .eventTracking)
		NSApp.activate(ignoringOtherApps: true)
	}
	
	
	func windowWillClose(_ notification: Notification) {
		previewTimer?.invalidate()
		previewTimer = nil
	}
	
}
