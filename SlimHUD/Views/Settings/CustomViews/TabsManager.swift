//
//  TabsContentView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 25/01/23.
//

import Cocoa

class TabsManager: NSView {
    static private let TabsViewHeight = 86
    var tabs: TabsView = TabsView(frame: .init(x: 0, y: 0, width: 400, height: TabsViewHeight))
    var contentViews: [NSView] = []
    var view: NSView?

    var configVC: ConfigViewController?
    var designVC: DesignViewController?
    var styleVC: StyleViewController?
    var aboutVC: AboutViewController?

    public func setWindowController(_ windowController: SettingsWindowController) {
        styleVC?.windowController = windowController
        designVC?.windowController = windowController
    }

    override func awakeFromNib() {
        // swiftlint:disable:next force_cast
        (NSApplication.shared.delegate as! AppDelegate).settingsViewTabsManager = self
        if configVC == nil {
            addSubview(tabs)
            tabs.tabsContentView = self
            tabs.awakeFromNib()

            let storyboard = NSStoryboard(name: "Settings", bundle: nil)
            if let config = storyboard.instantiateController(withIdentifier: "config") as? ConfigViewController,
               let style = storyboard.instantiateController(withIdentifier: "style") as? StyleViewController,
               let design = storyboard.instantiateController(withIdentifier: "design") as? DesignViewController,
               let about = storyboard.instantiateController(withIdentifier: "about") as? AboutViewController {
                for viewControllerView in [config.view, style.view, design.view, about.view] {
                    contentViews.append(viewControllerView)
                    viewControllerView.setFrameOrigin(.zero)
                    addSubview(viewControllerView)
                }
                configVC = config
                designVC = design
                styleVC = style
                aboutVC = about

                selectItem(index: 0)
            }
        }
        super.awakeFromNib()
    }

    func selectItem(index: Int) {
        tabs.selectItem(index: index)
        showItem(index: index)
    }

    func showItem(index: Int) {
        for contentView in contentViews {
            contentView.isHidden = true
        }
        let innerViewToShow = contentViews[index]
        innerViewToShow.isHidden = false
        let newContainerSize = NSSize(width: self.frame.width, height: innerViewToShow.frame.height + CGFloat(TabsManager.TabsViewHeight))
        self.setFrameSize(newContainerSize)
        tabs.setFrameOrigin(.init(x: 0, y: innerViewToShow.frame.height))
        setWindowFrameSize(newSize: newContainerSize)
    }

    private func setWindowFrameSize(newSize: NSSize) {
        if let window = window {
            let oldFrame = window.frame
            // window should be resized while keeping the top edge fixed
            let newOrigin = CGPoint(x: oldFrame.origin.x,
                                    y: oldFrame.origin.y + (oldFrame.height - newSize.height))
            window.setFrame(NSRect(origin: newOrigin, size: newSize), display: true)
        }
    }

}
