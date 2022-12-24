//
//  About.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

class AboutViewController: NSViewController {

    @IBOutlet weak var versionOutlet: NSTextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        versionOutlet.stringValue = "Version \(version())"
    }

    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        // let build = dictionary["CFBundleVersion"] as! String
        return "\(version)" // + ".\(build)"
    }

    @IBAction func openRepository(_ sender: Any) {
        let url = URL(string: "https://github.com/AlexPerathoner/SlimHUD")!
        if NSWorkspace.shared.open(url) {
            NSLog("Repository opened successfully")
        }
    }

    @IBAction func openWebsite(_ sender: Any) {
        let url = URL(string: "https://alexperathoner.github.io/SlimHUD")!
        if NSWorkspace.shared.open(url) {
            NSLog("Website opened successfully")
        }
    }

}
