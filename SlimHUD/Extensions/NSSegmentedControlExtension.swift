//
//  NSSegmentedControlExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 19/12/2022.
//  Copyright © 2022 Alex Perathoner. All rights reserved.
//

import Foundation
import Cocoa

extension NSSegmentedControl {
    func getBarState() -> EnabledBars {
        return EnabledBars(volumeBar: isSelected(forSegment: EnabledBars.VOLUME_BAR_INDEX),
                           brightnessBar: isSelected(forSegment: EnabledBars.BRIGHTNESS_BAR_INDEX),
                           keyboardBar: isSelected(forSegment: EnabledBars.KEYBOARD_BAR_INDEX))
    }

    func setBarState(enabledBars: EnabledBars) throws {
        setSelected(enabledBars.volumeBar, forSegment: EnabledBars.VOLUME_BAR_INDEX)
        setSelected(enabledBars.brightnessBar, forSegment: EnabledBars.BRIGHTNESS_BAR_INDEX)
        setSelected(enabledBars.keyboardBar, forSegment: EnabledBars.KEYBOARD_BAR_INDEX)
    }
}
