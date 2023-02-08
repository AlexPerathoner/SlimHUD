//
//  TabsView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 23/01/23.
//

import Cocoa

class TabsView: CustomView {
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
        self.backgroundColorName = "PrimaryColor"
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

        if #available(macOS 13.0, *) {
            tabItem1.image = NSImage.init(systemSymbolName: "wrench.adjustable", accessibilityDescription: nil)
            tabItem2.image = NSImage.init(systemSymbolName: "eyedropper", accessibilityDescription: nil)
            tabItem3.image = NSImage.init(systemSymbolName: "square.stack.3d.down.dottedline", accessibilityDescription: nil)
            tabItem4.image = NSImage.init(systemSymbolName: "info.circle", accessibilityDescription: nil)
        } else {
            tabItem1.image = IconManager.getConfigIcon()
            tabItem2.image = IconManager.getStyleIcon()
            tabItem3.image = IconManager.getDesignIcon()
            tabItem4.image = IconManager.getAboutIcon()
        }

        for (index, tab) in tabs.enumerated() {
            addSubview(tab)
            tab.index = index
            tab.delegate = self
            tab.awakeFromNib()
        }

        super.awakeFromNib()
    }

    func selectItem(index: Int) {
        for tab in tabs {
            tab.selected = false
        }
        tabs[index].selected = true
    }

    func selectItem(item: TabItemView) {
        for tab in tabs.filter({ tab in
            return tab != item
        }) {
            tab.selected = false
        }
        tabsContentView?.selectItem(index: item.index)
    }

    // FIXME: way used in CustomView should work fine
    @objc override func updateBackgroundColor() {
        var newColor: NSColor = .white
        if #available(macOS 10.14, *) {
            if effectiveAppearance.name == NSAppearance.Name.aqua {
                newColor = NSColor(white: 0.196, alpha: 1)
            } else {
                newColor = NSColor(white: 0.925, alpha: 1)
            }
        }
        layer?.backgroundColor = newColor.cgColor
    }
}
