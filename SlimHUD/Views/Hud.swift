//
//  Hud.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import AppKit

class Hud: NSView {

    private var animationStyle = AnimationStyle.slide

    /// The NSView that is going to be displayed when show() is called
    private var barView: BarView = NSView.fromNib(name: BarView.BarViewNibFileName, type: BarView.self)
    private var originPosition: CGPoint
    private var screenEdge: Position = .left

    private var hudView: NSView! { // TODO: check why not using self
        return windowController?.window?.contentView
    }

    private var windowController: NSWindowController?

    private override init(frame frameRect: NSRect) {
        originPosition = .zero
        super.init(frame: frameRect)
        commonInit()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
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
            self.isHidden = false
            guard let hudView = hudView else { return }
            if hudView.subviews.isEmpty {
                hudView.addSubview(barView)
            }
            windowController?.showWindow(self)

            if animationStyle.requiresInMovement() {
                barView.setFrameOrigin(HudAnimator.getAnimationFrameOrigin(originPosition: originPosition, screenEdge: screenEdge))
            } else {
                barView.setFrameOrigin(originPosition)
            }

            switch animationStyle {
            case .none: HudAnimator.popIn(barView: barView)
            case .slide: HudAnimator.slideIn(barView: barView, originPosition: originPosition)
            case .popInFadeOut: HudAnimator.popIn(barView: barView)
            case .fade: HudAnimator.fadeIn(barView: barView)
            case .grow: HudAnimator.growIn(barView: barView)
            case .shrink: HudAnimator.shrinkIn(barView: barView)
            case .sideGrow: HudAnimator.sideGrowIn(barView: barView, originPosition: originPosition)
            }
        }
    }

    func hide(animated: Bool) {
        if !isHidden {
            if animated {
                switch animationStyle {
                case .none: HudAnimator.popOut(barView: barView, completion: commonAnimationOutCompletion)
                case .slide: HudAnimator.slideOut(barView: barView, originPosition: originPosition, screenEdge: screenEdge, completion: commonAnimationOutCompletion)
                case .popInFadeOut: HudAnimator.fadeOut(barView: barView, completion: commonAnimationOutCompletion)
                case .fade: HudAnimator.fadeOut(barView: barView, completion: commonAnimationOutCompletion)
                case .grow: HudAnimator.growOut(barView: barView, completion: commonAnimationOutCompletion)
                case .shrink: HudAnimator.shrinkOut(barView: barView, completion: commonAnimationOutCompletion)
                case .sideGrow: HudAnimator.sideGrowOut(barView: barView,
                                                        originPosition: originPosition,
                                                        screenEdge: screenEdge,
                                                        completion: commonAnimationOutCompletion)
                }
            } else {
                HudAnimator.popOut(barView: barView, completion: commonAnimationOutCompletion)
            }
        }
    }
    private func commonAnimationOutCompletion() {
        self.isHidden = true
        self.windowController?.close()
    }

    @objc private func hideDelayed(_ animated: AnyObject?) {
        hide(animated: (animated as? AnimationStyle) != AnimationStyle.none)
    }

    public func dismiss(delay: TimeInterval) {
        if !isHidden {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideDelayed(_:)), object: animationStyle)
        }
        self.perform(#selector(hideDelayed(_:)), with: animationStyle, afterDelay: delay)
    }

    public func hideIcon(isHidden: Bool) {
        barView.hideIcon(isHidden: isHidden)
    }

    @available(macOS 10.14, *)
    public func setIconTint(_ color: NSColor) {
        barView.setIconTint(color)
    }

    public func setIconImage(icon: NSImage, force: Bool = false) {
        barView.setIconImage(icon: icon, force: force)
    }

    public func setShadow(shadowType: ShadowType, shadowRadius: Int, color: NSColor, inset: Int = 5) {
        if shadowType == .none { // FIXME: solve this in a better way
            barView.setupShadow(enabled: false, shadowRadius: Constants.ShadowRadius)
            barView.disableShadowView()
        } else if shadowType == .view {
            barView.setupShadowAsView(radius: shadowRadius, color: color, inset: inset)
            barView.setupShadow(enabled: false, shadowRadius: Constants.ShadowRadius)
        } else {
            barView.setupShadow(enabled: true, shadowRadius: Constants.ShadowRadius)
            barView.disableShadowView()
        }
    }

    public func setHeight(height: CGFloat) {
        barView.setFrameSize(NSSize(width: barView.frame.width, height: height + Constants.ShadowRadius * 3))
        barView.updateShadowView()
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
        barView.updateShadowView()
    }

    public func getFrame() -> NSRect {
        return barView.frame
    }

    public func setOrientation(isHorizontal: Bool, position: Position) {
        barView.layer?.anchorPoint = CGPoint(x: 0, y: 0)
        if isHorizontal {
            barView.frameCenterRotation = -90
        } else {
            barView.frameCenterRotation = 0
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

        NSAnimationContext.runAnimationGroup({ (context) in
            context.duration = Constants.Animation.Duration / 2
            if animationStyle.requiresInMovement() && hudView.isHidden {
                let adjustedOriginPosition = HudAnimator.getAnimationFrameOrigin(originPosition: originPosition, screenEdge: screenEdge)
                barView.animator().setFrameOrigin(adjustedOriginPosition)
            } else {
                barView.animator().setFrameOrigin(originPosition)
            }
        })
    }
}
