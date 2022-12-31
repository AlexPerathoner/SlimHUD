//
//  NSSegmentedControlExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
import Cocoa

extension NSSegmentedControl {
    func getBarState() -> EnabledBars {
        return EnabledBars(volumeBar: isSelected(forSegment: EnabledBars.VolumeBarIndex),
                           brightnessBar: isSelected(forSegment: EnabledBars.BrightnessBarIndex),
                           keyboardBar: isSelected(forSegment: EnabledBars.KeyboardBarIndex))
    }

    func setBarState(enabledBars: EnabledBars) throws {
        setSelected(enabledBars.volumeBar, forSegment: EnabledBars.VolumeBarIndex)
        setSelected(enabledBars.brightnessBar, forSegment: EnabledBars.BrightnessBarIndex)
        setSelected(enabledBars.keyboardBar, forSegment: EnabledBars.KeyboardBarIndex)
    }
}
