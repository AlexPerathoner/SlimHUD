//
//  BarView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 10/05/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import Cocoa

class BarView: NSView {

    static let BAR_VIEW_NIB_FILE_NAME = "BarView"

    @IBOutlet weak var bar: ProgressBar!
    @IBOutlet var image: NSImageView!

}
