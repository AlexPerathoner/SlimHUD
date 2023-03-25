//
//  DesignViewController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 25/01/23.
//

import Cocoa

class DesignViewController: NSViewController {
    weak var delegate: HudsControllerInterface?
    weak var windowController: SettingsWindowController?
    var settingsManager = SettingsManager.getInstance()

    @IBOutlet weak var thicknessValue: NSTextField!
    @IBOutlet weak var sizeValue: NSTextField!

    @IBOutlet weak var thicknessSlider: NSSlider!
    @IBOutlet weak var sizeSlider: NSSlider!

    @IBOutlet weak var iconsOutlet: NSButton!
    @IBOutlet weak var flatBarOutlet: NSButton!
    @IBOutlet weak var animationStyleOutlet: NSPopUpButton!
    @IBOutlet weak var shadowTypeOutlet: NSPopUpButton!

    override func viewDidLoad() {
        // swiftlint:disable:next force_cast
        self.delegate = (NSApplication.shared.delegate as! AppDelegate).displayer
        thicknessValue.stringValue = String(settingsManager.barThickness)
        sizeValue.stringValue = String(settingsManager.barHeight)

        thicknessSlider.integerValue = settingsManager.barThickness
        sizeSlider.integerValue = settingsManager.barHeight

        iconsOutlet.state = settingsManager.shouldShowIcons.toStateValue()
        flatBarOutlet.state = settingsManager.flatBar.toStateValue()
        animationStyleOutlet.selectItem(withTitle: settingsManager.animationStyle.rawValue)
        shadowTypeOutlet.selectItem(withTitle: settingsManager.shadowType.rawValue)
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
                sizeSlider.integerValue = newValue
            } else {
                sizeValue.stringValue = String(sizeSlider.integerValue)
            }
        }
    }
    @IBAction func thicknessText(_ sender: NSTextField) {
        if let newValue = Int(sender.stringValue) {
            if newValue > 0 {
                setThickness(newValue)
                thicknessSlider.integerValue = newValue
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
        delegate?.updateIconsVisibility()
    }

    @IBAction func flatBarClicked(_ sender: NSButton) {
        useFlatBar(sender.boolValue())
    }
    private func useFlatBar(_ value: Bool) {
        settingsManager.flatBar = value
        delegate?.setThickness(thickness: CGFloat(settingsManager.barThickness))
    }

    @IBAction func shadowTypeClicked(_ sender: NSPopUpButton) {
        let shadowType = ShadowType(from: sender.titleOfSelectedItem)
        setShadowType(shadowType)
        if shadowType == .view {
            let storyboard = NSStoryboard(name: "Settings", bundle: nil)
            if let shadowVC = storyboard.instantiateController(withIdentifier: "shadow") as? ShadowPopupViewController {
                self.present(shadowVC, asPopoverRelativeTo: sender.frame, of: sender, preferredEdge: .maxX, behavior: .transient)
            }
        }
    }
    private func setShadowType(_ value: ShadowType) {
        settingsManager.shadowType = value
        delegate?.updateShadows()
    }

    @IBAction func animationStyleClicked(_ sender: NSPopUpButton) {
        setAnimationStyle(AnimationStyle(from: sender.titleOfSelectedItem))
    }
    private func setAnimationStyle(_ value: AnimationStyle) {
        settingsManager.animationStyle = value
        delegate?.setAnimationStyle(animationStyle: value)
    }

    @IBAction func playAnimationStyle(_ sender: Any) {
        windowController?.restartPreviewHud()
    }

    @IBAction func resetDesignClicked(_ sender: Any) {
        setSize(210)
        setThickness(9)
        showIcons(true)
        useFlatBar(true)
        setAnimationStyle(.slide)
        setShadowType(.nsshadow)
    }
}
