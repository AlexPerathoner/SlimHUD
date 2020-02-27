


import Cocoa


class ObserverApplication: NSApplication {
	
	static let volumeChanged = Notification.Name("SlimHUD.volumeChanged")
	static let brightnessChanged = Notification.Name("SlimHUD.brightnessChanged")
	
	override func sendEvent(_ event: NSEvent) {
		if (event.type == .systemDefined && event.subtype.rawValue == 8) {
            let keyCode = ((event.data1 & 0xFFFF0000) >> 16)
            let keyFlags = (event.data1 & 0x0000FFFF)
            // Get the key state. 0xA is KeyDown, OxB is KeyUp
            let keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA
			let keyRepeat = keyFlags & 0x1
			mediaKeyEvent(key: Int32(keyCode), state: keyState, keyRepeat: Bool(truncating: keyRepeat as NSNumber))
        }
        
        super.sendEvent(event)
    }
    
    func mediaKeyEvent(key: Int32, state: Bool, keyRepeat: Bool) {
        // Only send events on KeyDown. Without this check, these events will happen twice
        if (state) {
            switch(key) {
            case NX_KEYTYPE_SOUND_DOWN, NX_KEYTYPE_SOUND_UP, NX_KEYTYPE_MUTE:
				NotificationCenter.default.post(name: ObserverApplication.volumeChanged, object: self)
                break
			case NX_KEYTYPE_BRIGHTNESS_UP, NX_KEYTYPE_BRIGHTNESS_DOWN:
				NotificationCenter.default.post(name: ObserverApplication.brightnessChanged, object: self)
				break
            default:
                break
            }
        }
    }
}

