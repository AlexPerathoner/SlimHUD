//
//  ShadowPopupViewController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/03/23.
//

import Cocoa

class ShadowPopupViewController: NSViewController {
    weak var delegate: HudsControllerInterface?
    var settingsManager = SettingsManager.getInstance()

    @IBOutlet weak var radiusValue: NSTextField!
    @IBOutlet weak var radiusSlider: NSSlider!

    @IBOutlet weak var insetValue: NSTextField!
    @IBOutlet weak var insetSlider: NSSlider!

    @IBOutlet weak var shadowColorOutlet: NSColorWell!

    override func viewDidLoad() {
        // swiftlint:disable:next force_cast
        self.delegate = (NSApplication.shared.delegate as! AppDelegate).displayer

        radiusValue.stringValue = String(settingsManager.shadowRadius)
        radiusSlider.integerValue = settingsManager.shadowRadius
        insetValue.stringValue = String(settingsManager.shadowInset)
        insetSlider.integerValue = settingsManager.shadowInset
        shadowColorOutlet.color = settingsManager.shadowColor
    }

    @IBAction func radiusSlider(_ sender: NSSlider) {
        setRadius(sender.integerValue)
    }

    private func setRadius(_ value: Int) {
        radiusValue.stringValue = String(value)
        settingsManager.shadowRadius = value
        delegate?.updateShadows()
    }

    @IBAction func radiusText(_ sender: NSTextField) {
        if let newValue = Int(sender.stringValue) {
            if newValue >= 0 {
                setRadius(newValue)
                radiusSlider.integerValue = newValue
            } else {
                radiusValue.stringValue = String(radiusSlider.integerValue)
            }
        }
    }
    @IBAction func insetSlider(_ sender: NSSlider) {
        setInset(sender.integerValue)
    }

    private func setInset(_ value: Int) {
        insetValue.stringValue = String(value)
        settingsManager.shadowInset = value
        delegate?.updateShadows()
    }

    @IBAction func insetText(_ sender: NSTextField) {
        if let newValue = Int(sender.stringValue) {
            setInset(newValue)
            insetSlider.integerValue = newValue
        }
    }

    @IBAction func setShadowColorClicked(_ sender: NSColorWell) {
        settingsManager.shadowColor = sender.color
        delegate?.updateShadows()
    }
}
