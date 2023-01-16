//
//  SettingsViewController.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa
import Sparkle

class SettingsViewController: NSViewController, SPUUpdaterDelegate {
    let loginItemsList = LoginItemsList()

    var settingsManager: SettingsManager = SettingsManager.getInstance()
    @IBOutlet weak var preview: SettingsController!
    weak var delegate: HudsControllerInterface?
    @IBOutlet var spuStandardUpdaterController: SPUStandardUpdaterController!
    @IBOutlet var updaterDelegate: UpdaterDelegate!

    override func awakeFromNib() {
        super.awakeFromNib()
        // swiftlint:disable:next force_cast
        self.delegate = (NSApplication.shared.delegate as! AppDelegate).displayer
        do {
            try enabledBarsOutlet.setBarState(enabledBars: settingsManager.enabledBars)
        } catch {
            NSLog("Enabled bars saved in UserDefaults not valid")
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy - HH:mm"
        if let lastCheckDate = spuStandardUpdaterController.updater.lastUpdateCheckDate {
            lastCheckForUpdatesOutlet.stringValue = formatter.string(from: lastCheckDate)
        } else {
            lastCheckForUpdatesOutlet.stringValue = " - "
        }

        marginValueOutlet.stringValue = String(settingsManager.marginValue) + "%"
        marginStepperOutlet.integerValue = (settingsManager.marginValue * 100)
        launchAtLoginOutlet.state = loginItemsList.isLoginItemInList().toStateValue()
        iconOutlet.state = settingsManager.shouldShowIcons.toStateValue()
        shadowOutlet.state = settingsManager.shouldShowShadows.toStateValue()
        continuousCheckOutlet.state = settingsManager.shouldContinuouslyCheck.toStateValue()
        animationStyleOutlet.selectItem(at: settingsManager.animationStyle.intValue())
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
    }

    var volumeColorHelpVC: SinglePopover?
    @IBAction func displayVolumeColorHelp(_ sender: Any) {
        if !(volumeColorHelpVC?.isVisible ?? false) {
            let storyboard = NSStoryboard(name: "Settings", bundle: nil)
            let viewController = storyboard.instantiateController(
                // swiftlint:disable:next force_cast
                withIdentifier: "volumeColorHelp") as! SinglePopover
            volumeColorHelpVC = viewController
            self.present(viewController, asPopoverRelativeTo: .zero, of: volumeColorHelpBtn, preferredEdge: .maxY, behavior: .transient)
        }
    }
    var marginHelpVC: SinglePopover?
    @IBAction func displayMarginHelp(_ sender: Any) {
        if !(marginHelpVC?.isVisible ?? false) {
            let storyboard = NSStoryboard(name: "Settings", bundle: nil)
            let viewController = storyboard.instantiateController(
                // swiftlint:disable:next force_cast
                withIdentifier: "marginHelp") as! SinglePopover
            marginHelpVC = viewController
            self.present(viewController, asPopoverRelativeTo: .zero, of: marginHelpBtn, preferredEdge: .maxY, behavior: .transient)
        }
    }
    var continuousCheckHelpVC: SinglePopover?
    @IBAction func displayContinuousCheckHelp(_ sender: Any) {
        if !(continuousCheckHelpVC?.isVisible ?? false) {
            let storyboard = NSStoryboard(name: "Settings", bundle: nil)
            let viewController = storyboard.instantiateController(
                // swiftlint:disable:next force_cast
                withIdentifier: "continuousCheckHelp") as! SinglePopover
            continuousCheckHelpVC = viewController
            self.present(viewController, asPopoverRelativeTo: .zero, of: continuousCheckHelpBtn, preferredEdge: .maxY, behavior: .transient)
        }
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

    // MARK: Style tab
    @IBOutlet weak var iconsBox: NSBox!
    @IBOutlet weak var barsBox: NSBox!
    @IBOutlet weak var changedColorOfOutlet: NSPopUpButton!
    @IBOutlet weak var chagedColorOfLabel: NSTextField!

    @IBOutlet weak var iconOutlet: NSButton!
    @IBOutlet weak var shadowOutlet: NSButton!
    @IBOutlet weak var animationStyleOutlet: NSPopUpButton!
    
    @IBOutlet weak var backgroundColorOutlet: NSColorWell!
    @IBOutlet weak var volumeEnabledColorOutlet: NSColorWell!
    @IBOutlet weak var volumeDisabledColorOutlet: NSColorWell!
    @IBOutlet weak var brightnessColorOutlet: NSColorWell!
    @IBOutlet weak var keyboardColorOutlet: NSColorWell!

    @IBOutlet weak var volumeIconColorOutlet: NSColorWell!
    @IBOutlet weak var brightnessIconColorOutlet: NSColorWell!
    @IBOutlet weak var keyboardIconColorOutlet: NSColorWell!

    // MARK: Help buttons
    @IBOutlet weak var volumeColorHelpBtn: NSButton!
    @IBOutlet weak var marginHelpBtn: NSButton!
    @IBOutlet weak var continuousCheckHelpBtn: NSButton!

}
