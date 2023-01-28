//
//  AboutViewController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 25/01/23.
//

import Cocoa
import Sparkle

class AboutViewController: NSViewController {
    @IBOutlet weak var versionLabel: StandardLabel!
    @IBOutlet var spuStandardUpdaterController: SPUStandardUpdaterController!
    @IBOutlet var updaterDelegate: UpdaterDelegate!
    @IBOutlet weak var lastCheckForUpdatesOutlet: StandardLabel!
    
    override func viewDidLoad() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy - HH:mm"
        if let lastCheckDate = spuStandardUpdaterController.updater.lastUpdateCheckDate {
            lastCheckForUpdatesOutlet.stringValue = formatter.string(from: lastCheckDate)
        } else {
            lastCheckForUpdatesOutlet.stringValue = " - "
        }
        versionLabel.setStringValue(value: getVersion())
    }
    
    private func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        // swiftlint:disable:next force_cast
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "\(version)"
    }
    
    private func openWebsite(url: String) {
        if NSWorkspace.shared.open(URL(string: url)!) {
            NSLog("Website opened successfully")
        }
    }
    
    @IBAction func checkBetaUpdates(_ sender: Any) {
        updaterDelegate.checkBetaUpdates = true
        spuStandardUpdaterController.checkForUpdates(self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updaterDelegate.checkBetaUpdates = false
        }
    }
    
    @IBAction func clickedContributorsAlexPerathoner(_ sender: Any) {
        openWebsite(url: "https://github.com/AlexPerathoner")
    }
    @IBAction func clickedContributorsKaydenAnderson(_ sender: Any) {
        openWebsite(url: "https://github.com/kaydenanderson")
    }
    @IBAction func clickedContributorsGameParrot(_ sender: Any) {
        openWebsite(url: "https://github.com/GameParrot")
    }
    
    @IBAction func openRepo(_ sender: Any) {
        openWebsite(url: "https://github.com/AlexPerathoner/SlimHUD")
    }
}
