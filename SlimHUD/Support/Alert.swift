//
//  Alert.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 04/01/23.
//

import Cocoa

func showAlert(question: String, text: String, buttonsTitle: [String]) -> NSApplication.ModalResponse {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    for button in buttonsTitle {
        alert.addButton(withTitle: button)
    }
    alert.alertStyle = .warning
    return alert.runModal()
}
