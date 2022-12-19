//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 27/04/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController, NSWindowDelegate {
	
	private var previewTimer: Timer?
    
    var displayer = (NSApplication.shared.delegate as! AppDelegate).displayer
	
	override func windowDidLoad() {
		super.windowDidLoad()
		window?.delegate = self
		
		if previewTimer == nil { //windowDidLoad() could be called multiple times
			//sends a notification every second causing the bar to appear and be kept visible
			previewTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) { (t) in
                self.displayer.showVolumeHUD()
			}
			RunLoop.current.add(previewTimer!, forMode: .eventTracking)
		}
		
		NSApp.activate(ignoringOtherApps: true)
	}
	
	func windowWillClose(_ notification: Notification) {
		previewTimer?.invalidate()
	}
	
}
