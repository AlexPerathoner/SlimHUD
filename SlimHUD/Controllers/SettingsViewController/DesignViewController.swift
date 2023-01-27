//
//  DesignViewController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 25/01/23.
//

import Cocoa

class DesignViewController: NSViewController {
    weak var delegate: HudsControllerInterface?
    var settingsManager = SettingsManager.getInstance()

    @IBOutlet weak var thicknessValue: NSTextField!
    @IBOutlet weak var sizeValue: NSTextField!
    
    @IBOutlet weak var thicknessSlider: NSSlider!
    @IBOutlet weak var sizeSlider: NSSlider!
    
    @IBAction func sizeSlider(_ sender: NSSlider) {
        sizeValue.stringValue = String(sender.integerValue)
        settingsManager.barHeight = sender.integerValue
        delegate?.setHeight(height: CGFloat(sender.integerValue))
    }

    @IBAction func thicknessSlider(_ sender: NSSlider) {
        thicknessValue.stringValue = String(sender.integerValue)
        settingsManager.barThickness = sender.integerValue
        delegate?.setThickness(thickness: CGFloat(sender.integerValue))
    }
    @IBAction func sizeText(_ sender: NSTextField) {
        if let newValue = Int(sender.stringValue) {
            sizeSlider.integerValue = newValue
            settingsManager.barHeight = sender.integerValue
            delegate?.setHeight(height: CGFloat(newValue))
        }
    }
    @IBAction func thicknessText(_ sender: NSTextField) {
        if let newValue = Int(sender.stringValue) {
            thicknessSlider.integerValue = newValue
            settingsManager.barThickness = sender.integerValue
            delegate?.setThickness(thickness: CGFloat(newValue))
        }
    }
}
