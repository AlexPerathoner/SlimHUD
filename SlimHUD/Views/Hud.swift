//
//  Hud.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import AppKit

class Hud: NSView {

    private var animationDuration: TimeInterval = 0.3
    private var animationMovement: CGFloat = 20 // TODO: remove this
    private var animationStyle = AnimationStyle.Slide

    /// The NSView that is going to be displayed when show() is called
    private var barView: BarView = NSView.fromNib(name: BarView.BarViewNibFileName) as! BarView // swiftlint:disable:this force_cast
    private var originPosition: CGPoint
    private var screenEdge: Position = .left

    private var hudView: NSView! { // TODO: check why not using self
        return windowController?.window?.contentView
    }

    private var windowController: NSWindowController?

    private override init(frame frameRect: NSRect) {
        originPosition = .zero
        super.init(frame: frameRect)
        setup()
    }

    init(position: CGPoint) {
        self.originPosition = position
        super.init(frame: .zero)
        setFrameOrigin(position)
        setup()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() { // TOOD: should be in awakeFromNib
        isHidden = true
        let window = NSWindow(contentRect: DisplayManager.getScreenFrame(),
                              styleMask: .borderless, backing: .buffered, defer: true,
                              screen: DisplayManager.getZeroScreen())
        window.level = .floating
        window.backgroundColor = .clear
        window.animationBehavior = .none
        windowController = NSWindowController(window: window)
    }

    func setBarView(barView: BarView) {
        self.barView = barView
    }

    func show() {
        if isHidden {
            guard let hudView = hudView else { return }
            windowController?.showWindow(self)
            frame = hudView.frame // TODO: check if this necessary
            if !hudView.subviews.isEmpty { // TODO: this too
                hudView.subviews = []
            }
            hudView.addSubview(barView)

            // animation only if not yet visible
            
            self.isHidden = false
            
            switch animationStyle {
            case .None: Animator.popIn(hudView: hudView, originPosition: originPosition)
            case .Slide: Animator.slideIn(hudView: hudView, originPosition: originPosition, screenEdge: screenEdge)
            case .PopInFadeOut: Animator.popIn(hudView: hudView, originPosition: originPosition)
            case .Fade: Animator.fade(hudView: hudView, originPosition: originPosition, screenEdge: screenEdge)
            case .GrowBlur: Animator.growBlur(hudView: hudView, originPosition: originPosition, screenEdge: screenEdge)
//            case .SideGrow: Animator.sideGrowIn(hudView: hudView, originPosition: originPosition, screenEdge: screenEdge)
            default: Animator.popIn(hudView: hudView, originPosition: originPosition)
            }
        }
    }
    

    func hide(animated: Bool) {
        if !isHidden {
            guard let view = hudView else { return }
//            if animationStyle != .None { // TODO: update for different animations
//                NSAnimationContext.runAnimationGroup({ (context) in
//                    // slide + fade out animation
//                    context.duration = animationDuration
//                    view.animator().alphaValue = 0
//
//                    switch screenEdge {
//                    case .left:
//                        view.animator().setFrameOrigin(.init(x: originPosition.x - animationMovement, y: originPosition.y))
//                    case .right:
//                        view.animator().setFrameOrigin(.init(x: originPosition.x + animationMovement, y: originPosition.y))
//                    case .top:
//                        view.animator().setFrameOrigin(.init(x: originPosition.x, y: originPosition.y + animationMovement))
//                    case .bottom:
//                        view.animator().setFrameOrigin(.init(x: originPosition.x, y: originPosition.y - animationMovement))
//                    }
//                }, completionHandler: {
//                    self.isHidden = true
//                    self.removeFromSuperview()
//                    self.windowController?.close()
//                })
//            } else {
                view.setFrameOrigin(originPosition)
                view.alphaValue = 0
                isHidden = true
                removeFromSuperview()
                windowController?.close()
//            }
        }
    }

    @objc private func hideDelayed(_ animated: NSNumber?) {
        hide(animated: animated != 0)
    }

    public func dismiss(delay: TimeInterval) {
        if !isHidden {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideDelayed(_:)), object: animationStyle)
        }
        self.perform(#selector(hideDelayed(_:)), with: animationStyle, afterDelay: delay) // TODO: check if it should be passed as int to obj func
    }

    public func hideIcon(isHidden: Bool) {
        barView.hideIcon(isHidden: isHidden)
    }

    @available(macOS 10.14, *)
    public func setIconTint(_ color: NSColor) {
        barView.setIconTint(color)
    }

    public func setIconImage(icon: NSImage) {
        barView.setIconImage(icon: icon)
    }

    public func setShadow(_ enabled: Bool, _ shadowRadius: CGFloat) {
        barView.setupShadow(enabled, shadowRadius)
    }

    public func setHeight(height: CGFloat) {
        barView.setFrameSize(NSSize(width: barView.frame.width, height: height + Constants.ShadowRadius * 3))
    }

    public func setThickness(thickness: CGFloat, flatBar: Bool) {
        barView.setFrameSize(NSSize(width: thickness + Constants.ShadowRadius * 2, height: barView.frame.height))
        barView.bar.progressLayer.frame.size.width = thickness // setting up inner layer
        if flatBar {
            barView.bar.progressLayer.cornerRadius = 0
        } else {
            barView.bar.progressLayer.cornerRadius = thickness/2
        }
        barView.bar.layer?.cornerRadius = thickness/2 // setting up outer layer
        barView.bar.frame.size.width = thickness
    }

    public func getFrame() -> NSRect {
        return barView.frame
    }

    public func setOrientation(isHorizontal: Bool, position: Position) {
        let barViewFrame = barView.frame
        barView.layer?.anchorPoint = CGPoint(x: 0, y: 0)
        if isHorizontal {
            barView.frameCenterRotation = -90
            barView.setFrameOrigin(.init(x: 0, y: barViewFrame.width))
        } else {
            barView.frameCenterRotation = 0
            barView.setFrameOrigin(.init(x: 0, y: 0))
        }

        // needs a bit more space for displaying shadows...
        if position == .right {
            barView.setFrameOrigin(.init(x: Constants.ShadowRadius, y: 0))
        }
        if position == .top {
            barView.setFrameOrigin(.init(x: 0, y: Constants.ShadowRadius + barViewFrame.width))
        }

        barView.setIconRotation(isHorizontal: isHorizontal)
    }

    public func setProgress(progress: Float) {
        barView.bar.progress = progress
    }

    public func setAnimationStyle(_ animationStyle: AnimationStyle) {
        self.animationStyle = animationStyle
        barView.bar.setupAnimationStyle(animationStyle: animationStyle)
    }

    public func setForegroundColor(color: NSColor) {
        barView.bar.foreground = color
    }

    // TODO: find better way for this. Perhaps subclass to VolumeHUD and add a second color "disabled"? ~ could also handle double icon
    public func setForegroundColor(color1: NSColor, color2: NSColor, basedOn useFirst: Bool) {
        if useFirst {
            setForegroundColor(color: color1)
        } else {
            setForegroundColor(color: color2)
        }
    }
    public func setBackgroundColor(color: NSColor) {
        barView.bar.background = color
    }

    public func setPosition(originPosition: CGPoint, screenEdge: Position) {
        self.originPosition = originPosition
        self.screenEdge = screenEdge
    }
}
