//
//  TabsContentView.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 25/01/23.
//

import Cocoa

class TabsManager: NSView {
    var tabs: TabsView = TabsView(frame: .init(x: 0, y: 414, width: 400, height: 86))
    var contentViews: [NSView] = []
    var view: NSView?
    
    var configVC: ConfigViewController?
    var designVC: DesignViewController?
    var styleVC: StyleViewController?
    var aboutVC: AboutViewController?
    
    public func setWindowController(_ windowController: SettingsWindowController) {
        styleVC?.windowController = windowController
    }

    override func awakeFromNib() {
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
        contentViews[index].isHidden = false
    }
    
}
