//
//  AboutViewController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 28/04/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa


class AboutViewController: NSViewController {
	
	
	@IBOutlet weak var versionOutlet: NSTextField!
	override func awakeFromNib() {
		versionOutlet.stringValue = "Version \(version())"
		
	}
	func version() -> String {
		let dictionary = Bundle.main.infoDictionary!
		let version = dictionary["CFBundleShortVersionString"] as! String
		let build = dictionary["CFBundleVersion"] as! String
		return "\(version).\(build)"
	}
	
}
