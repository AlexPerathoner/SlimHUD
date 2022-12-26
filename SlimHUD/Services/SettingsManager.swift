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
    private static let ShouldUseAnimationKey = "shouldUseAnimation"
    private static let BarHeightKey = "barHeight"
    private static let BarThicknessKey = "barThickness"
    private static let PositionKey = "position"
    private static let EnabledBarsKey = "enabledBars"
    private static let MarginKey = "marginValue"

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
    var shouldShowShadows: Bool = true {
        didSet {
            UserDefaults.standard.set(shouldShowShadows, forKey: SettingsManager.ShouldShowShadowsKey)
        }
    }
    var shouldShowIcons: Bool = true {
        didSet {
            UserDefaults.standard.set(shouldShowIcons, forKey: SettingsManager.ShouldShowIconsKey)
        }
    }
    var shouldContinuouslyCheck: Bool = true {
        didSet {
            UserDefaults.standard.set(shouldContinuouslyCheck, forKey: SettingsManager.ShouldContinuouslyCheckKey)
        }
    }
    var shouldUseAnimation: Bool = true {
        didSet {
            UserDefaults.standard.set(shouldUseAnimation, forKey: SettingsManager.ShouldUseAnimationKey)
        }
    }

    var barHeight: Int = 218 {
        didSet {
            UserDefaults.standard.set(barHeight, forKey: SettingsManager.BarHeightKey)
        }
    }
    var barThickness: Int = 7 {
        didSet {
            UserDefaults.standard.set(barThickness, forKey: SettingsManager.BarThicknessKey)
        }
    }
    var position: Position = Position.left {
        didSet {
            UserDefaults.standard.set(position.rawValue, forKey: SettingsManager.PositionKey)
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

    var marginValue: Int = 10 {
        didSet {
            UserDefaults.standard.set(marginValue, forKey: SettingsManager.MarginKey)
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
        brightnessIconColor = UserDefaultsManager.getItem(for: SettingsManager.BrightnessColorKey, defaultValue: .white)
        keyboardIconColor = UserDefaultsManager.getItem(for: SettingsManager.KeyboardIconColorKey, defaultValue: .white)

        shouldShowShadows = UserDefaultsManager.getBool(for: SettingsManager.ShouldShowShadowsKey)
        shouldShowIcons = UserDefaultsManager.getBool(for: SettingsManager.ShouldShowIconsKey)
        barHeight = UserDefaultsManager.getInt(for: SettingsManager.BarHeightKey)
        barThickness = UserDefaultsManager.getInt(for: SettingsManager.BarThicknessKey)
        if let rawPosition = UserDefaultsManager.getString(for: SettingsManager.PositionKey) {
            position = Position(rawValue: rawPosition) ?? .left
        } else {
            position = .left
        }
        shouldContinuouslyCheck = UserDefaultsManager.getBool(for: SettingsManager.ShouldContinuouslyCheckKey)
        shouldUseAnimation = UserDefaultsManager.getBool(for: SettingsManager.ShouldUseAnimationKey)
        let enabledBarsRaw = UserDefaultsManager.getArr(for: SettingsManager.EnabledBarsKey, defaultValue: [true, true, true])
        let (volumeBarEnabled, brightnessBarEnabled, keyboardBarEnabled) =
            (enabledBarsRaw[EnabledBars.VolumeBarIndex],
             enabledBarsRaw[EnabledBars.BrightnessBarIndex],
             enabledBarsRaw[EnabledBars.KeyboardBarIndex])
        enabledBars = EnabledBars(volumeBar: volumeBarEnabled, brightnessBar: brightnessBarEnabled, keyboardBar: keyboardBarEnabled)
        marginValue = UserDefaultsManager.getInt(for: SettingsManager.MarginKey)
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
        UserDefaults.standard.set(shouldUseAnimation, forKey: SettingsManager.ShouldUseAnimationKey)
        UserDefaults.standard.set(shouldContinuouslyCheck, forKey: SettingsManager.ShouldContinuouslyCheckKey)
    }

    deinit {
        saveAllItems()
    }

}
