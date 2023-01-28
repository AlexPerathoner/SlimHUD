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
    
    @IBOutlet weak var iconsOutlet: NSButton!
    @IBOutlet weak var flatBarOutlet: NSButton!
    @IBOutlet weak var shadowsOutlet: NSButton!
    @IBOutlet weak var animationStyleOutlet: NSPopUpButton!
    
    override func viewDidLoad() {
        thicknessValue.stringValue = String(settingsManager.barThickness)
        sizeValue.stringValue = String(settingsManager.barHeight)
        
        thicknessSlider.integerValue = settingsManager.barThickness
        sizeSlider.integerValue = settingsManager.barHeight
        
        iconsOutlet.state = settingsManager.shouldShowIcons.toStateValue()
        flatBarOutlet.state = settingsManager.flatBar.toStateValue()
        shadowsOutlet.state = settingsManager.shouldShowShadows.toStateValue()
        animationStyleOutlet.selectItem(withTitle: settingsManager.animationStyle.rawValue)
    }
    
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
            if newValue > 0 {
                sizeSlider.integerValue = newValue
                settingsManager.barHeight = sender.integerValue
                delegate?.setHeight(height: CGFloat(newValue))
            } else {
                sizeValue.stringValue = String(sizeSlider.integerValue)
            }
        }
    }
    @IBAction func thicknessText(_ sender: NSTextField) {
        if let newValue = Int(sender.stringValue) {
            if newValue > 0 {
                thicknessSlider.integerValue = newValue
                settingsManager.barThickness = sender.integerValue
                delegate?.setThickness(thickness: CGFloat(newValue))
            } else {
                thicknessValue.stringValue = String(thicknessSlider.integerValue)
            }
        }
    }
    
    @IBAction func iconsClicked(_ sender: NSButton) {
        let shouldShowIcons = sender.boolValue()
        settingsManager.shouldShowIcons = shouldShowIcons
        delegate?.hideIcon(isHidden: !shouldShowIcons)
    }
    
    @IBAction func flatBarClicked(_ sender: NSButton) {
        let shouldUseFlatBar = sender.boolValue()
        settingsManager.flatBar = shouldUseFlatBar
        delegate?.setThickness(thickness: CGFloat(settingsManager.barThickness))
    }
    
    @IBAction func shadowsClicked(_ sender: NSButton) {
        let shouldShowShadows = sender.boolValue()
        settingsManager.shouldShowShadows = shouldShowShadows
        delegate?.updateShadows(enabled: shouldShowShadows)
    }
    
    @IBAction func animationStyleClicked(_ sender: NSPopUpButton) {
        let animationStyle = AnimationStyle(from: sender.titleOfSelectedItem)
        settingsManager.animationStyle = animationStyle
        delegate?.setAnimationStyle(animationStyle: animationStyle)
    }
    
    @IBAction func playAnimationStyle(_ sender: Any) {
        
    }
    
    @IBAction func resetDesignClicked(_ sender: Any) {
        
    }
}
