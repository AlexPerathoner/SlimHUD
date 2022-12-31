//
//  SettingsWindowController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 03/03/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa
import Sparkle

class SettingsViewController: NSViewController {
    let loginItemsList = LoginItemsList()

    var settingsManager: SettingsManager = SettingsManager.getInstance()
    @IBOutlet weak var preview: SettingsController!
    weak var delegate: HudsControllerInterface?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = (NSApplication.shared.delegate as! AppDelegate).displayer
        do {
            try enabledBarsOutlet.setBarState(enabledBars: settingsManager.enabledBars)
        } catch {
            NSLog("Enabled bars saved in UserDefaults not valid")
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy - HH:mm"
        lastCheckForUpdatesOutlet.stringValue = formatter.string(from: SUUpdater.shared()?.lastUpdateCheckDate ?? Date())

        marginValueOutlet.stringValue = String(settingsManager.marginValue) + "%"
        marginStepperOutlet.integerValue = (settingsManager.marginValue * 100)
        launchAtLoginOutlet.state = loginItemsList.isLoginItemInList().toStateValue()
        iconOutlet.state = settingsManager.shouldShowIcons.toStateValue()
        shadowOutlet.state = settingsManager.shouldShowShadows.toStateValue()
        continuousCheckOutlet.state = settingsManager.shouldContinuouslyCheck.toStateValue()
        animationsOutlet.state = settingsManager.shouldUseAnimation.toStateValue()
        backgroundColorOutlet.color = settingsManager.backgroundColor
        volumeEnabledColorOutlet.color = settingsManager.volumeEnabledColor
        volumeDisabledColorOutlet.color = settingsManager.volumeDisabledColor
        brightnessColorOutlet.color = settingsManager.brightnessColor
        keyboardColorOutlet.color = settingsManager.keyboardColor
        heightValue.stringValue = String(settingsManager.barHeight)
        heightSliderOutlet.integerValue = settingsManager.barHeight
        thicknessValue.stringValue = String(settingsManager.barThickness)
        thicknessSlider.integerValue = settingsManager.barThickness
        switch settingsManager.position {
        case .left:
            positionOutlet.selectItem(at: 0)
        case .bottom:
            positionOutlet.selectItem(at: 1)
        case .top:
            positionOutlet.selectItem(at: 2)
        case .right:
            positionOutlet.selectItem(at: 3)
        }
        if #available(OSX 10.14, *) {
            volumeIconColorOutlet.color = settingsManager.volumeIconColor
            brightnessIconColorOutlet.color = settingsManager.brightnessIconColor
            keyboardIconColorOutlet.color = settingsManager.keyboardIconColor
        } else {
            changedColorOfOutlet.isHidden = true
            chagedColorOfLabel.stringValue = "Changing colors of bars"
        }

        preview.settingsManager = settingsManager
        preview.setup()

    }

    // MARK: - Outlets

    // MARK: General tab
    @IBOutlet weak var launchAtLoginOutlet: NSButton!
    @IBOutlet weak var continuousCheckOutlet: NSButton!
    @IBOutlet weak var enabledBarsOutlet: NSSegmentedControl!

    @IBOutlet weak var marginValueOutlet: NSTextField!
    @IBOutlet weak var marginStepperOutlet: NSStepper!

    @IBOutlet weak var lastCheckForUpdatesOutlet: NSTextField!
    // check for updates button sends action directly to SUUpdater object in storyboard

    // MARK: Position tab
    @IBOutlet weak var heightValue: NSTextField!
    @IBOutlet weak var heightSliderOutlet: NSSlider!

    @IBOutlet weak var thicknessSlider: NSSlider!
    @IBOutlet weak var thicknessValue: NSTextField!

    @IBOutlet weak var positionOutlet: NSPopUpButton!

    @IBOutlet weak var restartOutlet: NSButton!

    @IBOutlet weak var positionButtonConstraint: NSLayoutConstraint!

    // MARK: Style tab
    @IBOutlet weak var iconsBox: NSBox!
    @IBOutlet weak var barsBox: NSBox!
    @IBOutlet weak var changedColorOfOutlet: NSPopUpButton!
    @IBOutlet weak var chagedColorOfLabel: NSTextField!

    @IBOutlet weak var iconOutlet: NSButton!
    @IBOutlet weak var shadowOutlet: NSButton!
    @IBOutlet weak var animationsOutlet: NSButton!

    @IBOutlet weak var backgroundColorOutlet: NSColorWell!
    @IBOutlet weak var volumeEnabledColorOutlet: NSColorWell!
    @IBOutlet weak var volumeDisabledColorOutlet: NSColorWell!
    @IBOutlet weak var brightnessColorOutlet: NSColorWell!
    @IBOutlet weak var keyboardColorOutlet: NSColorWell!

    @IBOutlet weak var volumeIconColorOutlet: NSColorWell!
    @IBOutlet weak var brightnessIconColorOutlet: NSColorWell!
    @IBOutlet weak var keyboardIconColorOutlet: NSColorWell!

}
