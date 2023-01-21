//
//  LoginItemList.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation
class LoginItemsList: NSObject {

    let loginItemsList: LSSharedFileList = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil)!.takeRetainedValue()

    func addLoginItem() -> Bool {
        let path = LoginItemsList.appPath()
        if getLoginItem() != nil {
            NSLog("Login Item has already been added to the list.")
            return true
        }
        NSLog("Path adding to Login Item list is: \(path)")

        // add new Login Item at the end of Login Items list
        if let loginItem = LSSharedFileListInsertItemURL(loginItemsList,
                                                         getLastLoginItemInList(),
                                                         nil, nil,
                                                         path,
                                                         nil, nil) {
            NSLog("Added login item is: \(loginItem)")
            return true
        }

        return false
    }

    func removeLoginItem() -> Bool {
        // remove Login Item from the Login Items list
        if let oldLoginItem = getLoginItem() {
            NSLog("Old login item is: \(oldLoginItem)")
            if LSSharedFileListItemRemove(loginItemsList, oldLoginItem) == noErr {
                return true
            }
            return false
        }
        NSLog("Login Item for given path not found in the list.")
        return true
    }

    func getLoginItem() -> LSSharedFileListItem! {
        let path = LoginItemsList.appPath()

        // Copy all login items in the list
        let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsList, nil)!.takeRetainedValue()

        var foundLoginItem: LSSharedFileListItem?
        var nextItemUrl: Unmanaged<CFURL>?

        // Iterate through login items to find one for given path
        NSLog("App URL: \(path)")
        for index in (0..<loginItems.count)  // CFArrayGetCount(loginItems)
        {

            // swiftlint:disable:next force_cast
            let nextLoginItem: LSSharedFileListItem = loginItems.object(at: index) as! LSSharedFileListItem

            if LSSharedFileListItemResolve(nextLoginItem, 0, &nextItemUrl, nil) == noErr {

                NSLog("Next login item URL: \(nextItemUrl!.takeUnretainedValue())")
                // compare searched item URL passed in argument with next item URL
                if nextItemUrl!.takeRetainedValue() == path {
                    foundLoginItem = nextLoginItem
                }
            }
        }

        return foundLoginItem
    }

    func getLastLoginItemInList() -> LSSharedFileListItem! {

        // Copy all login items in the list
        let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsList, nil)!.takeRetainedValue() as NSArray
        if loginItems.count > 0 {
            // swiftlint:disable:next force_cast
            let lastLoginItem = loginItems.lastObject as! LSSharedFileListItem

            NSLog("Last login item is: \(lastLoginItem)")
            return lastLoginItem
        }

        return kLSSharedFileListItemBeforeFirst.takeRetainedValue()
    }

    func isLoginItemInList() -> Bool {

        if getLoginItem() != nil {
            return true
        }

        return false
    }

    static func appPath() -> CFURL {

        return NSURL.fileURL(withPath: Bundle.main.bundlePath) as CFURL
    }

}
