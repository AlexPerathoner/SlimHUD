//
//  Hud.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 26/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import AppKit

class Hud: NSView {
	
	private var animationDuration: TimeInterval = 0.2
	private var animationMovement: CGFloat = 10
	var animated = true
	
	///The NSView that is going to be displayed when show() is called
	var view: NSView = .init()
	
	var position: CGPoint
	
	private var hudView: NSView? {
		windowController?.showWindow(self)
		return windowController?.window?.contentView
	}
	
	private var windowController: NSWindowController?
	
	private override init(frame frameRect: NSRect) {
		position = .zero
		super.init(frame: frameRect)
		setup()
	}
	
	init(position: CGPoint) {
		self.position = position
		super.init(frame: .zero)
		setFrameOrigin(position)
		setup()
	}
	
	func setup() {
		isHidden = true
		let screen = NSScreen.screens[0]
        let window = NSWindow(contentRect: screen.frame, styleMask: .borderless, backing: .buffered, defer: true, screen: screen)
		window.level = .floating
		window.backgroundColor = .clear
		window.animationBehavior = .none
        windowController = NSWindowController(window: window)
	}
	
	func traslate(_ newOrigin: NSPoint) {
		position = newOrigin
		hudView?.setFrameOrigin(position)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func show() {
		guard let view = hudView else { return }
		frame = view.frame
		view.addSubview(self.view)
		
		//animation only if not yet visible
		if(isHidden) {
			if(animated) {
				NSAnimationContext.runAnimationGroup({ (context) in
					//slide + fade in animation
					context.duration = animationDuration
					view.animator().alphaValue = 1
					view.animator().setFrameOrigin(position)
				}) {
					self.isHidden = false
					
				}
			} else {
				self.isHidden = false
				view.alphaValue = 1
			}
		}
	}
	
	
	
	func hide(animated: Bool) {
		guard let view = hudView else { return }
		if(animated) {
			NSAnimationContext.runAnimationGroup({ (context) in
				//slide + fade out animation
				context.duration = animationDuration
				view.animator().alphaValue = 0
				view.animator().setFrameOrigin(.init(x: position.x - animationMovement, y: position.y))
			}) {
				self.isHidden = true
				self.removeFromSuperview()
				self.windowController?.close()
			}
		} else {
			view.alphaValue = 0
			isHidden = true
			removeFromSuperview()
			windowController?.close()
		}
    }
	
	
	@objc private func hideDelayed(_ animated: NSNumber?) {
        hide(animated: animated != 0)
    }
	
	func dismiss(delay: TimeInterval) {
		if(!isHidden) {
			NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideDelayed(_:)), object: 1)
		}
		self.perform(#selector(hideDelayed(_:)), with: 1, afterDelay: delay)
    }
	
}
