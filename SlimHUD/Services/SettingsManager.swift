//
//  SettingsManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Cocoa

class SettingsManager {

    // MARK: - Keys

    private static let VolumeBackgroundColorKey = "volumeBackgroundColor"
    private static let BrightnessBackgroundColorKey = "brightnessBackgroundColor"
    private static let KeyboardBackgroundColorKey = "keyboardBackgroundColor"
    private static let VolumeEnabledColorKey = "volumeEnabledColor"
    private static let VolumeDisabledColorKey = "volumeDisabledColor"
    private static let BrightnessColorKey = "brightnessColor"
    private static let KeyboardColorKey = "keyboardColor"
    private static let VolumeIconColorKey = "volumeIconColor"
    private static let BrightnessIconColorKey = "brightnessIconColor"
    private static let KeyboardIconColorKey = "keyboardIconColor"
    private static let ShouldShowIconsKey = "shouldShowIcons"
    private static let ShouldShowShadowsKey = "shouldShowShadows"
    private static let ShadowColorKey = "shadowColor"
    private static let ShadowTypeKey = "shadowType"
    private static let ShadowInsetKey = "shadowInset"
    private static let ShadowRadiusKey = "shadowRadius"
    private static let ShouldContinuouslyCheckKey = "shouldContinuouslyCheck"
    private static let AnimationStyleKey = "animationStyle"
    private static let BarHeightKey = "barHeight"
    private static let BarThicknessKey = "barThickness"
    private static let PositionKey = "position"
    private static let EnabledBarsKey = "enabledBars"
    private static let MarginKey = "marginValue"
    private static let FlatBarKey = "flatBar"
    private static let ShouldHideMenuBarIconKey = "shouldHideMenuBarIcon"

    // MARK: - Bars colors
    var volumeBackgroundColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(volumeBackgroundColor, for: SettingsManager.VolumeBackgroundColorKey)
        }
    }
    var brightnessBackgroundColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(brightnessBackgroundColor, for: SettingsManager.BrightnessBackgroundColorKey)
        }
    }
    var keyboardBackgroundColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(keyboardBackgroundColor, for: SettingsManager.KeyboardBackgroundColorKey)
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
    var shadowColor: NSColor {
        didSet {
            UserDefaultsManager.setItem(shadowColor, for: SettingsManager.ShadowColorKey)
        }
    }
    var shadowType: ShadowType {
        didSet {
            UserDefaults.standard.set(shadowType.rawValue, forKey: SettingsManager.ShadowTypeKey)
        }
    }
    var shadowInset: Int {
        didSet {
            UserDefaults.standard.set(shadowInset, forKey: SettingsManager.ShadowInsetKey)
        }
    }
    var shadowRadius: Int {
        didSet {
            UserDefaults.standard.set(shadowRadius, forKey: SettingsManager.ShadowRadiusKey)
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

    var shouldHideMenuBarIcon: Bool {
        didSet {
            UserDefaults.standard.set(shouldHideMenuBarIcon, forKey: SettingsManager.ShouldHideMenuBarIconKey)
        }
    }

    // MARK: - Class methods

    static private let singletonSettingsController = SettingsManager()
    public static func getInstance() -> SettingsManager {
        return singletonSettingsController
    }

    private init() {
        volumeBackgroundColor = UserDefaultsManager.getItem(for: SettingsManager.VolumeBackgroundColorKey, defaultValue: DefaultColors.DarkGray)
        brightnessBackgroundColor = UserDefaultsManager.getItem(for: SettingsManager.BrightnessBackgroundColorKey, defaultValue: DefaultColors.DarkGray)
        keyboardBackgroundColor = UserDefaultsManager.getItem(for: SettingsManager.KeyboardBackgroundColorKey, defaultValue: DefaultColors.DarkGray)
        volumeEnabledColor = UserDefaultsManager.getItem(for: SettingsManager.VolumeEnabledColorKey, defaultValue: DefaultColors.Blue)
        volumeDisabledColor = UserDefaultsManager.getItem(for: SettingsManager.VolumeDisabledColorKey, defaultValue: DefaultColors.Gray)
        brightnessColor = UserDefaultsManager.getItem(for: SettingsManager.BrightnessColorKey, defaultValue: DefaultColors.Yellow)
        keyboardColor = UserDefaultsManager.getItem(for: SettingsManager.KeyboardColorKey, defaultValue: DefaultColors.Azure)

        volumeIconColor = UserDefaultsManager.getItem(for: SettingsManager.VolumeIconColorKey, defaultValue: .white)
        brightnessIconColor = UserDefaultsManager.getItem(for: SettingsManager.BrightnessIconColorKey, defaultValue: .white)
        keyboardIconColor = UserDefaultsManager.getItem(for: SettingsManager.KeyboardIconColorKey, defaultValue: .white)

        shouldShowShadows = UserDefaultsManager.getBool(for: SettingsManager.ShouldShowShadowsKey, defaultValue: true)
        shadowColor = UserDefaultsManager.getItem(for: SettingsManager.ShadowColorKey, defaultValue: NSColor.black)
        shadowType = ShadowType(rawValue: UserDefaultsManager.getString(for: SettingsManager.ShadowTypeKey, defaultValue: ShadowType.nsshadow.rawValue)) ?? ShadowType.nsshadow
        shadowInset = UserDefaultsManager.getInt(for: SettingsManager.ShadowColorKey, defaultValue: 5)
        shadowRadius = UserDefaultsManager.getInt(for: SettingsManager.ShadowColorKey, defaultValue: 10)
        
        shouldShowIcons = UserDefaultsManager.getBool(for: SettingsManager.ShouldShowIconsKey, defaultValue: true)
        barHeight = UserDefaultsManager.getInt(for: SettingsManager.BarHeightKey, defaultValue: 218)
        barThickness = UserDefaultsManager.getInt(for: SettingsManager.BarThicknessKey, defaultValue: 7)
        let rawPosition = UserDefaultsManager.getString(for: SettingsManager.PositionKey, defaultValue: "left")
        position = Position(rawValue: rawPosition) ?? .left
        shouldContinuouslyCheck = CommandLine.arguments.contains(SettingsManager.ShouldContinuouslyCheckKey) ?
            true : UserDefaultsManager.getBool(for: SettingsManager.ShouldContinuouslyCheckKey, defaultValue: false)
        shouldHideMenuBarIcon = UserDefaultsManager.getBool(for: SettingsManager.ShouldHideMenuBarIconKey, defaultValue: false)
        animationStyle = AnimationStyle(from: UserDefaultsManager.getString(for: SettingsManager.AnimationStyleKey, defaultValue: ""))
        let enabledBarsRaw = UserDefaultsManager.getArr(for: SettingsManager.EnabledBarsKey, defaultValue: [true, true, true])
        let (volumeBarEnabled, brightnessBarEnabled, keyboardBarEnabled) =
            (enabledBarsRaw[EnabledBars.VolumeBarIndex],
             enabledBarsRaw[EnabledBars.BrightnessBarIndex],
             enabledBarsRaw[EnabledBars.KeyboardBarIndex])
        enabledBars = EnabledBars(volumeBar: volumeBarEnabled, brightnessBar: brightnessBarEnabled, keyboardBar: keyboardBarEnabled)
        marginValue = UserDefaultsManager.getInt(for: SettingsManager.MarginKey, defaultValue: 10)
        flatBar = UserDefaultsManager.getBool(for: SettingsManager.FlatBarKey, defaultValue: false)
    }

    func resetDefaultBarsColors() {
        volumeBackgroundColor = DefaultColors.DarkGray
        brightnessBackgroundColor = DefaultColors.DarkGray
        keyboardBackgroundColor = DefaultColors.DarkGray
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
        // todo check if should add items for shadows, if not needed delete method
        UserDefaultsManager.setItem(volumeBackgroundColor, for: SettingsManager.VolumeBackgroundColorKey)
        UserDefaultsManager.setItem(brightnessBackgroundColor, for: SettingsManager.BrightnessBackgroundColorKey)
        UserDefaultsManager.setItem(keyboardBackgroundColor, for: SettingsManager.KeyboardBackgroundColorKey)
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
        UserDefaults.standard.set(shouldHideMenuBarIcon, forKey: SettingsManager.ShouldHideMenuBarIconKey)
        UserDefaults.standard.set(flatBar, forKey: SettingsManager.FlatBarKey)
    }

    deinit {
        saveAllItems()
    }

}
