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
        self.delegate = (NSApplication.shared.delegate as! AppDelegate).displayer
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
        setSize(sender.integerValue)
    }
    
    private func setSize(_ value: Int) {
        sizeValue.stringValue = String(value)
        settingsManager.barHeight = value
        delegate?.setHeight(height: CGFloat(value))
    }

    @IBAction func thicknessSlider(_ sender: NSSlider) {
        setThickness(sender.integerValue)
    }
    
    private func setThickness(_ value: Int) {
        thicknessValue.stringValue = String(value)
        settingsManager.barThickness = value
        delegate?.setThickness(thickness: CGFloat(value))
    }
    
    @IBAction func sizeText(_ sender: NSTextField) {
        if let newValue = Int(sender.stringValue) {
            if newValue > 0 {
                setSize(newValue)
            } else {
                sizeValue.stringValue = String(sizeSlider.integerValue)
            }
        }
    }
    @IBAction func thicknessText(_ sender: NSTextField) {
        if let newValue = Int(sender.stringValue) {
            if newValue > 0 {
                setThickness(newValue)
            } else {
                thicknessValue.stringValue = String(thicknessSlider.integerValue)
            }
        }
    }
    
    @IBAction func iconsClicked(_ sender: NSButton) {
        showIcons(sender.boolValue())
    }
    private func showIcons(_ value: Bool) {
        settingsManager.shouldShowIcons = value
        delegate?.hideIcon(isHidden: !value)
    }
    
    @IBAction func flatBarClicked(_ sender: NSButton) {
        useFlatBar(sender.boolValue())
    }
    private func useFlatBar(_ value: Bool) {
        settingsManager.flatBar = value
        delegate?.setThickness(thickness: CGFloat(settingsManager.barThickness))
    }
    
    @IBAction func shadowsClicked(_ sender: NSButton) {
        showShadows(sender.boolValue())
    }
    private func showShadows(_ value: Bool) {
        settingsManager.shouldShowShadows = value
        delegate?.updateShadows(enabled: value)
    }
    
    @IBAction func animationStyleClicked(_ sender: NSPopUpButton) {
        setAnimationStyle(AnimationStyle(from: sender.titleOfSelectedItem))
    }
    private func setAnimationStyle(_ value: AnimationStyle) {
        settingsManager.animationStyle = value
        delegate?.setAnimationStyle(animationStyle: value)
    }
    
    @IBAction func playAnimationStyle(_ sender: Any) {
        // TODO: implement this
    }
    
    @IBAction func resetDesignClicked(_ sender: Any) {
        setSize(210)
        setThickness(9)
        showIcons(true)
        useFlatBar(true)
        showShadows(true)
        setAnimationStyle(.Slide)
    }
}
