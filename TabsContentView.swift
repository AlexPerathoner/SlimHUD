//
//  TabsContentView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 25/01/23.
//

import Cocoa

class TabsContentView: NSView {
    
    var tabs: TabsView = TabsView(frame: .init(x: 0, y: 414, width: 400, height: 86))
    var contentViews: [NSView] = []
    var view: NSView?
    
    override func awakeFromNib() {
        addSubview(tabs)
        tabs.tabsContentView = self
        tabs.awakeFromNib()
        
        let storyboard = NSStoryboard(name: "Settings", bundle: nil)
        if let config = storyboard.instantiateController(withIdentifier: "config") as? ConfigViewController,
           let design = storyboard.instantiateController(withIdentifier: "design") as? DesignViewController,
           let style = storyboard.instantiateController(withIdentifier: "style") as? StyleViewController,
           let about = storyboard.instantiateController(withIdentifier: "about") as? AboutViewController {
            for view in [config.view, design.view, style.view, about.view] {
                contentViews.append(view)
                view.setFrameOrigin(.zero)
                addSubview(view)
            }

            selectItem(index: 0)
        }
        super.awakeFromNib()
    }
    
    func selectItem(index: Int) {
        for contentView in contentViews {
            contentView.isHidden = true
        }
        contentViews[index].isHidden = false
    }
}
