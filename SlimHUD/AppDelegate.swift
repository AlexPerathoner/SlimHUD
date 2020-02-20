//
//  AppDelegate.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 16/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	
	@IBOutlet var statusMenu: NSMenu!
	
	@IBAction func quitCliked(_ sender: Any) {
		NSApplication.shared.terminate(self)
	}
	@IBOutlet weak var bar: JCGGProgressBar!
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		NotificationCenter.default.addObserver(self, selector: #selector(showHUD(_:)), name: MediaApplication.volumeChanged, object: nil)
		DistributedNotificationCenter.default.addObserver(self, selector: #selector(showHUD(_:)), name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"), object: nil)
		print("Now listening")
		print(bar)
	}
	
	@objc func showHUD(_ sender: Any) {
		reloadBar()
		ProgressHUD.setDefaultStyle(.custom(foreground: .init(white: 0, alpha: 0), backgroud: .init(white: 0, alpha: 0)))
		ProgressHUD.setDefaultPosition(.center)
		
		ProgressHUD.setContainerView(nil)
		ProgressHUD.setDismissable(true)
		ProgressHUD.showView(bar)
		print("showing")
		ProgressHUD.dismiss(delay: 2)
	}
	
	func reloadBar() {
		bar.setColor(enabled: isMuted())
		bar.progressValue = CGFloat(getOutputVolume())
	}
	
	
	
	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

extension JCGGProgressBar {
	
	func setColor(enabled: Bool) {
		if(enabled) {
			self.barColor = JCGGProgressBar.blue
		}
		self.barColor = JCGGProgressBar.gray
		
	}
	
	
}
