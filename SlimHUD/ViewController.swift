//
//  ViewController.swift
//  prova
//
//  Created by Alex Perathoner on 17/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import AppKit


class ViewController: NSViewController {
	
	@IBOutlet weak var bar: JCGGProgressBar!
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(showHUD(_:)), name: MediaApplication.volumeChanged, object: nil)
		DistributedNotificationCenter.default.addObserver(self, selector: #selector(showHUD(_:)), name: NSNotification.Name(rawValue: "com.apple.sound.settingsChangedNotification"), object: nil)
	}
	
	@objc func showHUD(_ sender: Any) {
		reloadBar()
		ProgressHUD.setDefaultStyle(.custom(foreground: .init(white: 0, alpha: 0), backgroud: .init(white: 0, alpha: 0)))
		ProgressHUD.setDefaultPosition(.center)
		
		ProgressHUD.setContainerView(nil)
		ProgressHUD.setDismissable(true)
		ProgressHUD.showView(bar)
		ProgressHUD.dismiss(delay: 2)
	}
	
	func reloadBar() {
		bar.barColor = getColor()
		bar.progressValue = CGFloat(getOutputVolume())
	}
	
	private let gray = NSColor.init(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
	private let blue = NSColor.init(red: 49/255.0, green: 130/255.0, blue: 247/255.0, alpha: 1)
	
	func getColor() -> NSColor {
		if(isMuted()) {
			return gray
		}
		return blue
	}
	
	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
	}


}
