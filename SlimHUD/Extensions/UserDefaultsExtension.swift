//
//  UserDefaultsExtension.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 27/12/22.
//

import Foundation

extension UserDefaults {
    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }
}
