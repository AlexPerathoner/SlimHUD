//
//  SettingsManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

class SettingsManager {

    // MARK: - Keys

    private static let BackgroundColorKey = "backgroundColor"
    private static let VolumeEnabledColorKey = "volumeEnabledColor"
    private static let VolumeDisabledColorKey = "volumeDisabledColor"
    private static let BrightnessColorKey = "brightnessColor"
    private static let KeyboardColorKey = "keyboardColor"
    private static let VolumeIconColorKey = "volumeIconColor"
    private static let BrightnessIconColorKey = "brightnessIconColor"
    private static let KeyboardIconColorKey = "keyboardIconColor"
    private static let ShouldShowIconsKey = "shouldShowIcons"
    private static let ShouldShowShadowsKey = "shouldShowShadows"
    private static let ShouldContinuouslyCheckKey = "shouldContinuouslyCheck"
    private static let AnimationStyleKey = "animationStyle"
    private static let BarHeightKey = "barHeight"
    private static let BarThicknessKey = "barThickness"
    private static let PositionKey = "position"
    private static let EnabledBarsKey = "enabledBars"
    private static let MarginKey = "marginValue"
    private static let ShowQuitAlertKey = "showQuitAlert"
    private static let FlatBarKey = "flatBar"

    // MARK: - Bars colors
    var backgroundColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(backgroundColor, for: SettingsManager.BackgroundColorKey)
        }
    }
    var volumeEnabledColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(volumeEnabledColor, for: SettingsManager.VolumeEnabledColorKey)
        }
    }
    var volumeDisabledColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(volumeDisabledColor, for: SettingsManager.VolumeDisabledColorKey)
        }
    }
    var brightnessColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(brightnessColor, for: SettingsManager.BrightnessColorKey)
        }
    }
    var keyboardColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(keyboardColor, for: SettingsManager.KeyboardColorKey)
        }
    }
    // MARK: - Icons colors
    var volumeIconColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(volumeIconColor, for: SettingsManager.VolumeIconColorKey)
        }
    }
    var brightnessIconColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(brightnessIconColor, for: SettingsManager.BrightnessIconColorKey)
        }
    }
    var keyboardIconColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(keyboardIconColor, for: SettingsManager.KeyboardIconColorKey)
        }
    }

    // MARK: - Effects colors
    var shouldShowShadows: Bool {
        didSet {
            UserDefaults.standard.set(shouldShowShadows, forKey: SettingsManager.ShouldShowShadowsKey)
        }
    }
    var shouldShowIcons: Bool {
        didSet {
            UserDefaults.standard.set(shouldShowIcons, forKey: SettingsManager.ShouldShowIconsKey)
        }
    }
    var shouldContinuouslyCheck: Bool {
        didSet {
            UserDefaults.standard.set(shouldContinuouslyCheck, forKey: SettingsManager.ShouldContinuouslyCheckKey)
        }
    }
    var animationStyle: AnimationStyle {
        didSet {
            UserDefaults.standard.set(animationStyle.rawValue, forKey: SettingsManager.AnimationStyleKey)
        }
    }

    var barHeight: Int {
        didSet {
            UserDefaults.standard.set(barHeight, forKey: SettingsManager.BarHeightKey)
        }
    }
    var barThickness: Int {
        didSet {
            UserDefaults.standard.set(barThickness, forKey: SettingsManager.BarThicknessKey)
        }
    }
    var position: Position = Position.left {
        didSet {
            UserDefaults.standard.set(position.rawValue, forKey: SettingsManager.PositionKey)
        }
    }

    var flatBar: Bool {
        didSet {
            UserDefaults.standard.set(flatBar, forKey: SettingsManager.FlatBarKey)
        }
    }

    // MARK: - General
    var enabledBars: EnabledBars {
        didSet {
            let enabledBarsRaw = [enabledBars.volumeBar,
                                  enabledBars.brightnessBar,
                                  enabledBars.keyboardBar]
            UserDefaults.standard.set(enabledBarsRaw, forKey: SettingsManager.EnabledBarsKey)
        }
    }

    var marginValue: Int {
        didSet {
            UserDefaults.standard.set(marginValue, forKey: SettingsManager.MarginKey)
        }
    }

    var showQuitAlert: Bool {
        didSet {
            UserDefaults.standard.set(showQuitAlert, forKey: SettingsManager.ShowQuitAlertKey)
        }
    }

    // MARK: - Class methods

    static private let singletonSettingsController = SettingsManager()
    public static func getInstance() -> SettingsManager {
        return singletonSettingsController
    }

    private init() {
        backgroundColor = UserDefaultsManager.getItem(for: SettingsManager.BackgroundColorKey, defaultValue: DefaultColors.DarkGray)
        volumeEnabledColor = UserDefaultsManager.getItem(for: SettingsManager.VolumeEnabledColorKey, defaultValue: DefaultColors.Blue)
        volumeDisabledColor = UserDefaultsManager.getItem(for: SettingsManager.VolumeDisabledColorKey, defaultValue: DefaultColors.Gray)
        brightnessColor = UserDefaultsManager.getItem(for: SettingsManager.BrightnessColorKey, defaultValue: DefaultColors.Yellow)
        keyboardColor = UserDefaultsManager.getItem(for: SettingsManager.KeyboardColorKey, defaultValue: DefaultColors.Azure)

        volumeIconColor = UserDefaultsManager.getItem(for: SettingsManager.VolumeIconColorKey, defaultValue: .white)
        brightnessIconColor = UserDefaultsManager.getItem(for: SettingsManager.BrightnessIconColorKey, defaultValue: .white)
        keyboardIconColor = UserDefaultsManager.getItem(for: SettingsManager.KeyboardIconColorKey, defaultValue: .white)

        shouldShowShadows = UserDefaultsManager.getBool(for: SettingsManager.ShouldShowShadowsKey, defaultValue: true)
        shouldShowIcons = UserDefaultsManager.getBool(for: SettingsManager.ShouldShowIconsKey, defaultValue: true)
        barHeight = UserDefaultsManager.getInt(for: SettingsManager.BarHeightKey, defaultValue: 218)
        barThickness = UserDefaultsManager.getInt(for: SettingsManager.BarThicknessKey, defaultValue: 7)
        let rawPosition = UserDefaultsManager.getString(for: SettingsManager.PositionKey, defaultValue: "left")
        position = Position(rawValue: rawPosition) ?? .left
        shouldContinuouslyCheck = CommandLine.arguments.contains(SettingsManager.ShouldContinuouslyCheckKey) ?
            true : UserDefaultsManager.getBool(for: SettingsManager.ShouldContinuouslyCheckKey, defaultValue: false)
        animationStyle = AnimationStyle(from: UserDefaultsManager.getString(for: SettingsManager.AnimationStyleKey, defaultValue: ""))
        let enabledBarsRaw = UserDefaultsManager.getArr(for: SettingsManager.EnabledBarsKey, defaultValue: [true, true, true])
        let (volumeBarEnabled, brightnessBarEnabled, keyboardBarEnabled) =
            (enabledBarsRaw[EnabledBars.VolumeBarIndex],
             enabledBarsRaw[EnabledBars.BrightnessBarIndex],
             enabledBarsRaw[EnabledBars.KeyboardBarIndex])
        enabledBars = EnabledBars(volumeBar: volumeBarEnabled, brightnessBar: brightnessBarEnabled, keyboardBar: keyboardBarEnabled)
        marginValue = UserDefaultsManager.getInt(for: SettingsManager.MarginKey, defaultValue: 10)
        if CommandLine.arguments.contains("showQuitAlert") {
            let indexOfValue = CommandLine.arguments.firstIndex(of: "showQuitAlert")! + 1
            UserDefaults.standard.set(CommandLine.arguments[indexOfValue], forKey: SettingsManager.ShowQuitAlertKey)
        }
        showQuitAlert = UserDefaultsManager.getBool(for: SettingsManager.ShowQuitAlertKey, defaultValue: true)
        flatBar = UserDefaultsManager.getBool(for: SettingsManager.FlatBarKey, defaultValue: false)
    }

    func resetDefaultBarsColors() {
        backgroundColor = DefaultColors.DarkGray
        volumeEnabledColor = DefaultColors.Blue
        volumeDisabledColor = DefaultColors.Gray
        brightnessColor = DefaultColors.Yellow
        keyboardColor = DefaultColors.Azure
    }

    func resetDefaultIconsColors() {
        volumeIconColor = .white
        brightnessIconColor = .white
        keyboardIconColor = .white
    }

    func saveAllItems() {
        UserDefaultsManager.setItem(backgroundColor, for: SettingsManager.BackgroundColorKey)
        UserDefaultsManager.setItem(volumeEnabledColor, for: SettingsManager.VolumeEnabledColorKey)
        UserDefaultsManager.setItem(volumeDisabledColor, for: SettingsManager.VolumeDisabledColorKey)
        UserDefaultsManager.setItem(brightnessColor, for: SettingsManager.BrightnessColorKey)
        UserDefaultsManager.setItem(keyboardColor, for: SettingsManager.KeyboardColorKey)

        UserDefaultsManager.setItem(volumeIconColor, for: SettingsManager.VolumeIconColorKey)
        UserDefaultsManager.setItem(brightnessIconColor, for: SettingsManager.BrightnessIconColorKey)
        UserDefaultsManager.setItem(keyboardIconColor, for: SettingsManager.KeyboardIconColorKey)

        UserDefaults.standard.set(barHeight, forKey: SettingsManager.BarHeightKey)
        UserDefaults.standard.set(barThickness, forKey: SettingsManager.BarThicknessKey)
        UserDefaults.standard.set(shouldShowIcons, forKey: SettingsManager.ShouldShowIconsKey)
        UserDefaults.standard.set(shouldShowShadows, forKey: SettingsManager.ShouldShowShadowsKey)

        UserDefaults.standard.set(marginValue, forKey: SettingsManager.MarginKey)
        let enabledBarsRaw = [enabledBars.volumeBar,
                              enabledBars.brightnessBar,
                              enabledBars.keyboardBar]
        UserDefaults.standard.set(enabledBarsRaw, forKey: SettingsManager.EnabledBarsKey)
        UserDefaults.standard.set(position.rawValue, forKey: SettingsManager.PositionKey)
        UserDefaults.standard.set(animationStyle.rawValue, forKey: SettingsManager.AnimationStyleKey)
        UserDefaults.standard.set(shouldContinuouslyCheck, forKey: SettingsManager.ShouldContinuouslyCheckKey)
        UserDefaults.standard.set(flatBar, forKey: SettingsManager.FlatBarKey)
    }

    deinit {
        saveAllItems()
    }

}
