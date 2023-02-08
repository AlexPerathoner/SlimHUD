//
//  ConfigViewController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 25/01/23.
//

import Cocoa

class ConfigViewController: NSViewController {
    private let loginItemsList = LoginItemsList()
    weak var delegate: HudsControllerInterface?
    var settingsManager = SettingsManager.getInstance()

    @IBOutlet weak var edgeOutlet: EdgeSelector!
    @IBOutlet weak var marginOutlet: NSTextField!
    @IBOutlet weak var continuousCheckOutlet: NSButton!
    @IBOutlet weak var launchAtLoginOutlet: NSButton!
    @IBOutlet weak var enabledBarsOutlet: NSSegmentedControl!
    @IBOutlet weak var marginStepperOutlet: NSStepper!

    override func viewDidLoad() {
        // swiftlint:disable:next force_cast
        self.delegate = (NSApplication.shared.delegate as! AppDelegate).displayer

        edgeOutlet.delegate = self
        edgeOutlet.setEdge(edge: settingsManager.position)
        do {
            try enabledBarsOutlet.setBarState(enabledBars: settingsManager.enabledBars)
        } catch {
            NSLog("Enabled bars saved in UserDefaults not valid")
        }
        marginOutlet.stringValue = String(settingsManager.marginValue) + "%"
        marginStepperOutlet.integerValue = settingsManager.marginValue
        continuousCheckOutlet.state = settingsManager.shouldContinuouslyCheck.toStateValue()
        launchAtLoginOutlet.state = loginItemsList.isLoginItemInList().toStateValue()
    }

    func setPosition(edge: Position) {
        settingsManager.position = edge
        // as the settings window is the frontmost window, fullscreen is certainly false
        delegate?.positionManager.setupHUDsPosition(isFullscreen: false)
    }

    @IBAction func enabledBarsClicked(_ sender: NSSegmentedControl) {
        settingsManager.enabledBars = sender.getBarState()
    }

    @IBAction func launchAtLoginClicked(_ sender: NSButton) {
        if sender.boolValue() {
            if !loginItemsList.addLoginItem() {
                NSLog("Error while adding Login Item to the list.")
            }
        } else {
            if !loginItemsList.removeLoginItem() {
                NSLog("Error while removing Login Item from the list.")
            }
        }
    }

    @IBAction func continuousCheckClicked(_ sender: NSButton) {
        settingsManager.shouldContinuouslyCheck = sender.boolValue()
    }

    @IBAction func marginValueChanged(_ sender: NSStepper) {
        let marginValue = sender.integerValue
        settingsManager.marginValue = marginValue
        marginOutlet.stringValue = String(marginValue) + "%"
    }
}
