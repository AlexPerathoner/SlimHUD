//
//  Hud.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 26/02/2020.
//  Copyright © 2020 Alex Perathoner. All rights reserved.
//

import AppKit

class Hud: NSView {
	
	private var animationDuration: TimeInterval = 0.3
	private var animationMovement: CGFloat = 20
	var animated = true
	
	///The NSView that is going to be displayed when show() is called
	var view: NSView = .init()
	var position: CGPoint
	var rotated: Position = .left
	
	private var hudView: NSView? {
		//windowController?.showWindow(self)
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
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func show() {
		if(isHidden) {
			guard let view = hudView else { return }
			windowController?.showWindow(self)
			frame = view.frame
			view.addSubview(self.view)
			
			//animation only if not yet visible

			switch rotated {
			case .left:
				view.setFrameOrigin(.init(x: position.x - animationMovement, y: position.y))
			case .right:
				view.setFrameOrigin(.init(x: position.x + animationMovement, y: position.y))
			case .top:
				view.setFrameOrigin(.init(x: position.x, y: position.y + animationMovement))
			case .bottom:
				view.setFrameOrigin(.init(x: position.x, y: position.y - animationMovement))
			}
			self.isHidden = false
			if(animated) {
				NSAnimationContext.runAnimationGroup({ (context) in
					//slide + fade in animation
					context.duration = animationDuration
					view.animator().alphaValue = 1
					view.animator().setFrameOrigin(position)
				}) {}
			} else {
				view.setFrameOrigin(position)
				view.alphaValue = 1
			}
		}
	}
	
	
	
	func hide(animated: Bool) {
		if(!isHidden) {
			guard let view = hudView else { return }
			if(animated) {
				NSAnimationContext.runAnimationGroup({ (context) in
					//slide + fade out animation
					context.duration = animationDuration
					view.animator().alphaValue = 0

					switch rotated {
					case .left:
						view.animator().setFrameOrigin(.init(x: position.x - animationMovement, y: position.y))
					case .right:
						view.animator().setFrameOrigin(.init(x: position.x + animationMovement, y: position.y))
					case .top:
						view.animator().setFrameOrigin(.init(x: position.x, y: position.y + animationMovement))
					case .bottom:
						view.animator().setFrameOrigin(.init(x: position.x, y: position.y - animationMovement))
					}
				}) {
					self.isHidden = true
					self.removeFromSuperview()
					self.windowController?.close()
				}
			} else {
				view.setFrameOrigin(position)
				view.alphaValue = 0
				isHidden = true
				removeFromSuperview()
				windowController?.close()
			}
		}
    }
	
	
	@objc private func hideDelayed(_ animated: NSNumber?) {
        hide(animated: animated != 0)
    }
	
	func dismiss(delay: TimeInterval) {
		if(!isHidden) {
			NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideDelayed(_:)), object: animated.toInt())
		}
		self.perform(#selector(hideDelayed(_:)), with: animated.toInt(), afterDelay: delay)
		
    }
	
}
