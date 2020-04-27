//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 27/04/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class SettingsWindowController: NSWindowController {
	// MARK: - Preview
	
	@objc func windowWillClose() {
		NotificationCenter.default.removeObserver(self, name: .init("NSWindowWillCloseNotification"), object: window)
		previewTimer?.invalidate()
		previewTimer = nil
	}
	
	
	var previewTimer: Timer?
	func showPreviewHUD() {
		previewTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (t) in
			NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
		}
		RunLoop.current.add(previewTimer!, forMode: .eventTracking)
	}
	
	override func showWindow(_ sender: Any?) {
		NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose), name: .init("NSWindowWillCloseNotification"), object: window)
		showPreviewHUD()
		super.showWindow(sender)
	}
	
	
	
}
