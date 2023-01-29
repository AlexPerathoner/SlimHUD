//
//  TabsView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

@IBDesignable
class TabsView: CustomView {
    private static let TotalWidth: Int = 400
    private static let ElementsWidth: Int = 70
    private static let Offset: Int = 40
    private static let OffsetInternal: Int = 12
    private static let Size: NSSize = .init(width: 71, height: 45)
    
    var tabs: [TabItemView] = []
    weak var tabsContentView: TabsManager?
    
    private func calculateFrameForTabItem(index: Int) -> NSRect {
        let origin = NSPoint(x: TabsView.Offset+(Int(TabsView.Size.width)+TabsView.OffsetInternal)*index, y: 9)
        return NSRect.init(origin: origin, size: TabsView.Size)
    }
    
    override func awakeFromNib() {
        self.shadowed = true
        self.backgroundColor = NSColor(named: "PrimaryColor")!
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
        tabsContentView?.selectItem(index: item.index)
    }
}
