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

    func getSelectedBar() throws -> SelectedHud {
        let enabledBars = getBarState()
        var selectedCount = 0
        var selected: SelectedHud = .volume
        if enabledBars.volumeBar {
            selected = .volume
            selectedCount += 1
        }
        if enabledBars.brightnessBar {
            selected = .brightness
            selectedCount += 1
        }
        if enabledBars.keyboardBar {
            selected = .keyboard
            selectedCount += 1
        }
        if selectedCount > 1 {
            throw LogicError.EnabledBarsConversion.MultipleBarsSelected
        }
        if selectedCount == 0 {
            throw LogicError.EnabledBarsConversion.NoBarsSelected
        }
        return selected
    }

    func setBarState(enabledBars: EnabledBars) throws {
        setSelected(enabledBars.volumeBar, forSegment: EnabledBars.VolumeBarIndex)
        setSelected(enabledBars.brightnessBar, forSegment: EnabledBars.BrightnessBarIndex)
        setSelected(enabledBars.keyboardBar, forSegment: EnabledBars.KeyboardBarIndex)
    }
}
