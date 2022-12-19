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
    func getBarState() -> [Bool] {
        var states: [Bool] = []
        for i in 0..<segmentCount {
            states.append(isSelected(forSegment: i))
        }
        return states
    }
    
    func setBarState(values: [Bool]) throws {
        guard values.count == segmentCount else {
            throw ParameterError(message: "values.count must correspond to SegmentControl.segmentCount")
        }
        
        for i in 0..<segmentCount {
            setSelected(values[i], forSegment: i)
        }
    }
}
