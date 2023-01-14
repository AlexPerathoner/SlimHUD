//
//  IconManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 13/01/23.
//

import Cocoa

class IconManager { // todo move to icon manager
    private static func getVolumeIconName(for progress: Float, isMuted: Bool) -> String {
        if isMuted {
            return NSImage.VolumeImageFileName.disable
        }
        switch progress {
        case 0..<0.1:
            return NSImage.VolumeImageFileName.zero
        case 0.1..<0.4:
            return NSImage.VolumeImageFileName.one
        case 0.4..<0.7:
            return NSImage.VolumeImageFileName.two
        default:
            return NSImage.VolumeImageFileName.three
        }
    }
    static func getVolumeIcon(for progress: Float, isMuted: Bool) -> NSImage {
        return NSImage(named: getVolumeIconName(for: progress, isMuted: isMuted))!
    }

    private static func getKeyboardIconName(for progress: Float) -> String {
        switch progress {
        case 0..<0.1:
            return NSImage.KeyboardImageFileName.zero
        case 0.1..<0.4:
            return NSImage.KeyboardImageFileName.one
        case 0.4..<0.7:
            return NSImage.KeyboardImageFileName.two
        default:
            return NSImage.KeyboardImageFileName.three
        }
    }
    static func getKeyboardIcon(for progress: Float) -> NSImage {
        return NSImage(named: getKeyboardIconName(for: progress))!
    }

    private static func getBrightnessIconName(for progress: Float) -> String {
        switch progress {
        case 0..<0.1:
            return NSImage.BrightnessImageFileName.zero
        case 0.1..<0.4:
            return NSImage.BrightnessImageFileName.one
        case 0.4..<0.7:
            return NSImage.BrightnessImageFileName.two
        default:
            return NSImage.BrightnessImageFileName.three
        }
    }
    static func getBrightnessIcon(for progress: Float) -> NSImage {
        return NSImage(named: getBrightnessIconName(for: progress))!
    }
}
