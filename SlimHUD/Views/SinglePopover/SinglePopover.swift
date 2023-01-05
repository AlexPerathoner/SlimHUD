//
//  SinglePopover.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 05/01/23.
//

import Cocoa

class SinglePopover: NSViewController {
    var isVisible = false
    override func viewWillAppear() {
        isVisible = true
    }
    override func viewWillDisappear() {
        isVisible = false
    }
}
