//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 27/04/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController, NSWindowDelegate {
	// MARK: - Preview
	
	@objc func windowWillClose() {
		showingPreviewHUD(false)
	}
	
	
	var previewTimer: Timer?
	func showingPreviewHUD(_ value: Bool) {
		if(value) {
			//send notification every second causing the bar to appear and be kept visible
			previewTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
				NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
			}
			RunLoop.current.add(previewTimer!, forMode: .eventTracking)
		} else {
			NotificationCenter.default.removeObserver(self, name: .init("NSWindowWillCloseNotification"), object: window)
			previewTimer?.invalidate()
			previewTimer = nil
		}
	}
	
	override func windowDidLoad() {
		NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose), name: .init("NSWindowWillCloseNotification"), object: window)
		showingPreviewHUD(true)
		super.windowDidLoad()
		self.window?.delegate = self
	}
	
	
	func windowShouldClose(_ sender: NSWindow) -> Bool {

		#if DEBUG
		let closingCtl = sender.contentViewController!
		let closingCtlClass = closingCtl.className
		print("\(closingCtlClass) is closing")
		#endif


		sender.contentViewController = nil // will force deinit.

		return true // allow to close.
	}
	
}
