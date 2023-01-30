//
//  IconManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 13/01/23.
//

import Cocoa

class IconManager {
    private struct VolumeImageFileName {
        static let disable = "volume-no"
        static let zero = "volume-0"
        static let one = "volume-1"
        static let two = "volume-2"
        static let three = "volume-3"
    }
    private struct BrightnessImageFileName {
        static let zero = "sun-0"
        static let one = "sun-1"
        static let two = "sun-2"
        static let three = "sun-3"
    }
    private struct KeyboardImageFileName {
        static let zero = "key-0"
        static let one = "key-1"
        static let two = "key-2"
        static let three = "key-3"
    }
    private struct SettingsTabsIcons {
        static let config = "wrench.adjustable"
        static let style = "eyedropper"
        static let design = "square.stack.3d.down.dottedline"
        static let about = "info.circle"
    }
    private static let StatusIconFileName = "statusIcon"

    public static func getStatusIcon() -> NSImage {
        return NSImage(named: IconManager.StatusIconFileName)!
    }
    public static func getStandardVolumeIcon(isMuted: Bool) -> NSImage {
        return getVolumeIcon(for: 1.0, isMuted: isMuted)
    }
    public static func getStandardBrightnessIcon() -> NSImage {
        return getBrightnessIcon(for: 1.0)
    }
    public static func getStandardKeyboardIcon() -> NSImage {
        return getKeyboardIcon(for: 1.0)
    }

    private static func getVolumeIconName(for progress: Float, isMuted: Bool) -> String {
        if isMuted {
            return IconManager.VolumeImageFileName.disable
        }
        switch progress {
        case 0..<0.1:
            return IconManager.VolumeImageFileName.zero
        case 0.1..<0.4:
            return IconManager.VolumeImageFileName.one
        case 0.4..<0.7:
            return IconManager.VolumeImageFileName.two
        default:
            return IconManager.VolumeImageFileName.three
        }
    }
    static func getVolumeIcon(for progress: Float, isMuted: Bool) -> NSImage {
        return NSImage(named: getVolumeIconName(for: progress, isMuted: isMuted))!
    }

    private static func getKeyboardIconName(for progress: Float) -> String {
        switch progress {
        case 0..<0.1:
            return IconManager.KeyboardImageFileName.zero
        case 0.1..<0.4:
            return IconManager.KeyboardImageFileName.one
        case 0.4..<0.7:
            return IconManager.KeyboardImageFileName.two
        default:
            return IconManager.KeyboardImageFileName.three
        }
    }
    static func getKeyboardIcon(for progress: Float) -> NSImage {
        return NSImage(named: getKeyboardIconName(for: progress))!
    }

    private static func getBrightnessIconName(for progress: Float) -> String {
        switch progress {
        case 0..<0.1:
            return IconManager.BrightnessImageFileName.zero
        case 0.1..<0.4:
            return IconManager.BrightnessImageFileName.one
        case 0.4..<0.7:
            return IconManager.BrightnessImageFileName.two
        default:
            return IconManager.BrightnessImageFileName.three
        }
    }
    static func getBrightnessIcon(for progress: Float) -> NSImage {
        return NSImage(named: getBrightnessIconName(for: progress))!
    }

    static func getConfigIcon() -> NSImage {
        return NSImage(named: IconManager.SettingsTabsIcons.config)!
    }
    static func getStyleIcon() -> NSImage {
        return NSImage(named: IconManager.SettingsTabsIcons.style)!
    }
    static func getDesignIcon() -> NSImage {
        return NSImage(named: IconManager.SettingsTabsIcons.design)!
    }
    static func getAboutIcon() -> NSImage {
        return NSImage(named: IconManager.SettingsTabsIcons.about)!
    }
}
