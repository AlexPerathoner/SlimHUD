//
//  TabsView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

@IBDesignable
class TabsView: CustomView {
    private var totalWidth: Int = 400 //TODO: constants
    private var elementsWidth: Int = 70
    private var offset: Int = 40 // TODO: rename
    private var offsetInternal: Int = 12 // TODO: rename
    private var size: NSSize = .init(width: 71, height: 45)
    
    var tabs: [TabItemView] = []
    var contentViews: [NSView] = []
    
    private func calculateFrameForTabItem(index: Int) -> NSRect {
        let origin = NSPoint(x: offset+(Int(size.width)+offsetInternal)*index, y: 10) // Todo move to constants
        return NSRect.init(origin: origin, size: size)
    }
    
    override func awakeFromNib() {
        self.shadowed = true
        self.backgroundColor = NSColor(red:253/255.0, green:253/255.0, blue:253/255.0, alpha:1.0)
        self.shadowColor = .black
        
        let tabItem1 = TabItemView(frame: calculateFrameForTabItem(index: 0))
        let tabItem2 = TabItemView(frame: calculateFrameForTabItem(index: 1))
        let tabItem3 = TabItemView(frame: calculateFrameForTabItem(index: 2))
        let tabItem4 = TabItemView(frame: calculateFrameForTabItem(index: 3))
        
        tabItem1.selected = true
        
        tabItem1.title = "Config"
        tabItem2.title = "Style"
        tabItem3.title = "Design"
        tabItem4.title = "About"
        
        tabs.append(tabItem1)
        tabs.append(tabItem2)
        tabs.append(tabItem3)
        tabs.append(tabItem4)
        
        if #available(macOS 13.0, *) { // TODO: use icons
            tabItem1.image = NSImage.init(systemSymbolName: "wrench.adjustable", accessibilityDescription: nil)
            tabItem2.image = NSImage.init(systemSymbolName: "eyedropper", accessibilityDescription: nil)
            tabItem3.image = NSImage.init(systemSymbolName: "square.stack.3d.down.dottedline", accessibilityDescription: nil)
            tabItem4.image = NSImage.init(systemSymbolName: "info.circle", accessibilityDescription: nil)
        }
        
        for (index, tab) in tabs.enumerated() {
            addSubview(tab)
            tab.index = index
            tab.delegate = self
            tab.awakeFromNib()
        }
        super.awakeFromNib()
    }
    
    func selectItem(item: TabItemView) {
        for tab in tabs.filter({ tab in
            return tab != item
        }) {
            tab.selected = false
        }
        for contentView in contentViews {
            contentView.isHidden = true
        }
        contentViews[item.index].isHidden = false
    }
}
