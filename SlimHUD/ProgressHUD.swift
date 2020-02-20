//
//  ProgressHUD.swift
//  ProgressHUD, https://github.com/massimobio/ProgressHUD-Mac
//
//  Created by Massimo Biolcati on 9/10/18.
//  Copyright © 2018 Massimo. All rights reserved.
//

import AppKit

/// The `ProgressHUD` color scheme
enum ProgressHUDStyle {
    /// `ProgressHUDStyle` with light background with *dark* text and progress indicator
    case light
    /// `ProgressHUDStyle` with dark background with *light* text and progress indicator
    case dark
    /// `ProgressHUDStyle` with custom foreground and background colors
    case custom(foreground: NSColor, backgroud: NSColor)

    fileprivate var backgroundColor: NSColor {
        switch self {
        case .light: return .white
        case .dark: return .black
        case let .custom(_, background): return background
        }
    }

    fileprivate var foregroundColor: NSColor {
        switch self {
        case .light: return .black
        case .dark: return .init(white: 0.95, alpha: 1)
        case let .custom(foreground, _): return foreground
        }
    }

}

/// Mask type for the view around of the `ProgressHUD`
enum ProgressHUDMaskType {
    /// Clear background `ProgressHUDMaskType` while allowing user interactions when HUD is displayed
    case none
    /// Clear background `ProgressHUDMaskType` while preventing user interactions when HUD is displayed
    case clear
    /// Translucent black background `ProgressHUDMaskType` while preventing user interactions when HUD is displayed
    case black
    /// Custom color background `ProgressHUDMaskType` while preventing user interactions when HUD is displayed
    case custom(color: NSColor)
}

/// `ProgressHUD` position inside the view
enum ProgressHUDPosition {
    /// Positions the `ProgressHUD` in the top third of the view
    case top
    /// Positions the `ProgressHUD` in the center of the view
    case center
    /// Positions the `ProgressHUD` in the lower third of the view
    case bottom
	//// Positions the hud in a custom point of the view
	case custom
}

// ProgressHUD operation mode
private enum ProgressHUDMode {
    case indeterminate // Progress is shown using an Spinning Progress Indicator and the status message
    case determinate // Progress is shown using a round, pie-chart like, progress view and the status message
    case info // Shows an info glyph and the status message
    case success // Shows a success glyph and the status message
    case error // Shows an error glyph and the status message
    case text // Shows only the status message
    case custom(view: NSView) // Shows a custom view and the status message
}

typealias ProgressHUDDismissCompletion = () -> Void

class ProgressHUD: NSView {

    // MARK: - Lifecycle

    static let shared = ProgressHUD()

    private override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        // setup view
        autoresizingMask = [.maxXMargin, .minXMargin, .maxYMargin, .minYMargin]
        alphaValue = 0.0
        isHidden = true

        // setup status message label
        statusLabel.font = font
        statusLabel.isEditable = false
        statusLabel.isSelectable = false
        statusLabel.alignment = .center
        statusLabel.backgroundColor = .clear
        addSubview(statusLabel)

        // setup window into which to display the HUD
        let screen = NSScreen.screens[0]
        let window = NSWindow(contentRect: screen.frame, styleMask: .borderless, backing: .buffered, defer: true, screen: screen)
        window.level = .floating
        window.backgroundColor = .clear
        windowController = NSWindowController(window: window)

    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Customization

    /// Set the `ProgressHUDStyle` color scheme (Default is .light)
    class func setDefaultStyle(_ style: ProgressHUDStyle) { ProgressHUD.shared.style = style }
    private var style: ProgressHUDStyle = .light

    /// Set the `ProgressHUDMaskType` (Default is .none)
    class func setDefaultMaskType(_ maskType: ProgressHUDMaskType) { ProgressHUD.shared.maskType = maskType }
    private var maskType: ProgressHUDMaskType = .none

    /// Set the `ProgressHUDPosition` position in the view (Default is .bottom)
    class func setDefaultPosition(_ position: ProgressHUDPosition) { ProgressHUD.shared.position = position }
    private var position: ProgressHUDPosition = .bottom

    /// Set the container view in which to display the `ProgressHUD`. If nil then the main screen will be used.
    class func setContainerView(_ view: NSView?) { ProgressHUD.shared.containerView = view }
    private var containerView: NSView?

    /// Set the font to use to display the HUD status message (Default is systemFontOfSize: 18)
    class func setFont(_ font: NSFont) { ProgressHUD.shared.font = font }
    private var font = NSFont.systemFont(ofSize: 18)

    /// The opacity of the HUD view (Default is 0.9)
    class func setOpacity(_ opacity: CGFloat) { ProgressHUD.shared.opacity = opacity }
    private var opacity: CGFloat = 0

    /// The size both horizontally and vertically of the progress spinner (Default is 60 points)
    class func setSpinnerSize(_ size: CGFloat) { ProgressHUD.shared.spinnerSize = size }
    private var spinnerSize: CGFloat = 60.0

    /// The amount of space between the HUD edge and the HUD elements (label, indicator or custom view)
    class func setMargin(_ margin: CGFloat) { ProgressHUD.shared.margin = margin }
    private var margin: CGFloat = 15.0

    /// The amount of space between the HUD elements (label, indicator or custom view)
    class func setPadding(_ padding: CGFloat) { ProgressHUD.shared.padding = padding }
    private var padding: CGFloat = 10.0

    /// The corner radius for th HUD
    class func setCornerRadius(_ radius: CGFloat) { ProgressHUD.shared.cornerRadius = radius }
    private var cornerRadius: CGFloat = 10.0

    /// Allow User to dismiss HUD manually by a tap event (Default is false)
    class func setDismissable(_ dismissable: Bool) { ProgressHUD.shared.dismissible = dismissable }
    private var dismissible = false

    // MARK: - Presentation

    /// Presents an indeterminate `ProgressHUD` with no status message
    class func show() {
        ProgressHUD.show(withStatus: "")
    }

    /// Presents an indeterminate `ProgressHUD` with a status message
    class func show(withStatus status: String) {
        ProgressHUD.shared.show(withStatus: status, mode: .indeterminate)
    }

    /// Presents a determinate (or updates already visible) `ProgressHUD` with a progress value
    class func show(progress: Double) {
        ProgressHUD.show(progress: progress, status: ProgressHUD.shared.statusLabel.string)
    }

    /// Presents a determinate (or updates already visible) `ProgressHUD` with a progress value and status message
    class func show(progress: Double, status: String) {
        ProgressHUD.shared.show(progress: progress, status: status)
    }

    /// Changes the `ProgressHUD` status message while it's showing
    class func setStatus(_ status: String) {
        if ProgressHUD.shared.isHidden {
            return
        }
        ProgressHUD.shared.setStatus(status)
    }

    /// Presents a HUD with an info glyph + status, and dismisses the HUD a little bit later
    class func showInfoWithStatus(_ status: String) {
        ProgressHUD.shared.show(withStatus: status, mode: .info)
        ProgressHUD.dismiss(delay: ProgressHUD.shared.displayDuration(for: status))
    }

    /// Presents a HUD with a success glyph + status, and dismisses the HUD a little bit later
    class func showSuccessWithStatus(_ status: String) {
        ProgressHUD.shared.show(withStatus: status, mode: .success)
        ProgressHUD.dismiss(delay: ProgressHUD.shared.displayDuration(for: status))
    }

    /// Presents a HUD with an error glyph + status, and dismisses the HUD a little bit later
    class func showErrorWithStatus(_ status: String) {
        ProgressHUD.shared.show(withStatus: status, mode: .error)
        ProgressHUD.dismiss(delay: ProgressHUD.shared.displayDuration(for: status))
    }

    /// Presents a HUD with the status message only, and dismisses the HUD a little bit later
    class func showTextWithStatus(_ status: String) {
        ProgressHUD.shared.show(withStatus: status, mode: .text)
        ProgressHUD.dismiss(delay: ProgressHUD.shared.displayDuration(for: status))
    }

    /// Presents a HUD with an image + status, and dismisses the HUD a little bit later
    class func showImage(_ image: NSImage, status: String) {
        let imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        imageView.image = image
        ProgressHUD.shared.show(withStatus: status, mode: .custom(view: imageView))
        ProgressHUD.dismiss(delay: ProgressHUD.shared.displayDuration(for: status))
    }
	
	class func showView(_ view: NSView) {
		ProgressHUD.shared.show(withStatus: "", mode: .custom(view: view))
	}

    /// Dismisses the currently visible `ProgressHUD` if visible
    class func dismiss() {
        ProgressHUD.shared.hide(true)
    }

    /// Dismisses the currently visible `ProgressHUD` if visible and calls the completion closure
    class func dismiss(completion: ProgressHUDDismissCompletion?) {
        ProgressHUD.shared.hide(true)
    }

    /// Dismisses the currently visible `ProgressHUD` if visible, after a time interval. If the view is updated, the precedent dismiss is cancelled
    class func dismiss(delay: TimeInterval) {
		NSObject.cancelPreviousPerformRequests(withTarget: ProgressHUD.shared, selector: #selector(hideDelayed(_:)), object: 1)
        ProgressHUD.shared.perform(#selector(hideDelayed(_:)), with: 1, afterDelay: delay)
    }

    /// Dismisses the currently visible `ProgressHUD` if visible, after a time interval and calls the completion closure
    class func dismiss(delay: TimeInterval, completion: ProgressHUDDismissCompletion?) {
        ProgressHUD.shared.perform(#selector(hideDelayed(_:)), with: 1, afterDelay: delay)
    }

    /// Returns `true` is a `ProgressHUD` is currently being shown
    class func isVisible() -> Bool {
        return !ProgressHUD.shared.isHidden
    }

    // MARK: - Private Properties

    private var mode: ProgressHUDMode = .indeterminate
    private var indicator: NSView?
    private var progressIndicator: ProgressIndicatorLayer!
    private var size: CGSize = .zero
    private var useAnimation = true
    private let statusLabel = NSText(frame: .zero)
    private var completionHandler: ProgressHUDDismissCompletion?
    private var progress: Double = 0.0 {
        didSet {
            needsLayout = true
            needsDisplay = true
        }
    }
    private var yOffset: CGFloat {
        switch position {
        case .top: return -bounds.size.height / 5
        case .center: return 0
        case .bottom: return bounds.size.height / 5
		case .custom: return 0
        }
    }
	private var xOffset: CGFloat = 20.0
	
    private var hudView: NSView? {
        if let view = containerView {
            windowController?.close()
            return view
        }
        windowController?.showWindow(self)
        return windowController?.window?.contentView
    }
    private let minimumDismissTimeInterval: TimeInterval = 2
    private let maximumDismissTimeInterval: TimeInterval = 5
    private var windowController: NSWindowController?

    // MARK: - Private Show & Hide methods

    private func show(withStatus status: String, mode: ProgressHUDMode) {
        guard let view = hudView else { return }
        self.mode = mode
        if isHidden {
            frame = view.frame
            progressIndicator = ProgressIndicatorLayer(size: ProgressHUD.shared.spinnerSize, color: ProgressHUD.shared.style.foregroundColor)
            view.addSubview(self)
        }
        setupProgressIndicator()
        //setStatus(status)
        show(true)
    }

	
	// Modified by Alexander Perathoner on 19/02/20 to add slide animation
    private func show(_ animated: Bool) {
        NotificationCenter.default.post(name: ProgressHUD.willAppear, object: self)
        useAnimation = animated
        needsDisplay = true
        isHidden = false
        if animated {
            // Fade in
            animator().alphaValue = 0.5
			animator().setBoundsOrigin(.init(x: 10, y: 0))
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 0.20
            NSAnimationContext.current.completionHandler = {
                NotificationCenter.default.post(name: ProgressHUD.didAppear, object: self)
            }
			animator().setBoundsOrigin(.init(x: 0, y: 0))
			
            animator().alphaValue = 1.0
            NSAnimationContext.endGrouping()
        } else {
            alphaValue = 1.0
            NotificationCenter.default.post(name: ProgressHUD.didAppear, object: self)
        }
    }
	
	func slideAnimation() -> CATransition? {
		let transition = CATransition()
		transition.type = .moveIn
		transition.subtype = .fromRight
		return transition
	}


    private func hide(_ animated: Bool) {
        NotificationCenter.default.post(name: ProgressHUD.willDisappear, object: self)
        useAnimation = animated
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if animated {
            // Fade out

			animator().setBoundsOrigin(.init(x: 0, y: 0))
            NSAnimationContext.beginGrouping()
            NSAnimationContext.current.duration = 0.20
            NSAnimationContext.current.completionHandler = {
                self.done()
            }
            animator().alphaValue = 0

			animator().setBoundsOrigin(.init(x: 10, y: 0))
            NSAnimationContext.endGrouping()
        } else {
            alphaValue = 0.0
            done()
        }
    }

    private func show(progress: Double, status: String) {
        show(withStatus: status, mode: .determinate)
        self.progress = progress
    }

    private func done() {
        progressIndicator.stopProgressAnimation()
        alphaValue = 0.0
        isHidden = true
        removeFromSuperview()
        completionHandler?()
        indicator?.removeFromSuperview()
        indicator = nil
        statusLabel.string = ""
        windowController?.close()
        NotificationCenter.default.post(name: ProgressHUD.didDisappear, object: self)
    }

    private func setStatus(_ status: String) {
        statusLabel.textColor = style.foregroundColor
        statusLabel.font = font
        statusLabel.string = status
        statusLabel.sizeToFit()
    }
	
	

    override func mouseDown(with theEvent: NSEvent) {

        NotificationCenter.default.post(name: ProgressHUD.didReceiveMouseDownEvent, object: self)

        switch maskType {
        case .none: super.mouseDown(with: theEvent)
        default: break
        }
        if dismissible {
            DispatchQueue.main.async {
                self.hide(self.useAnimation)
            }
        }
    }

    private func setupProgressIndicator() {

        switch mode {

        case .indeterminate:
            indicator?.removeFromSuperview()
            let view = NSView(frame: NSRect(x: 0, y: 0, width: spinnerSize, height: spinnerSize))
            view.wantsLayer = true
            progressIndicator.startProgressAnimation()
            view.layer?.addSublayer(progressIndicator)
            indicator = view
            addSubview(indicator!)

        case .determinate, .info, .success, .error, .text:
            indicator?.removeFromSuperview()
            indicator = nil

        case let .custom(view):
            indicator?.removeFromSuperview()
            indicator = view
            addSubview(indicator!)

        }
    }

    @objc private func hideDelayed(_ animated: NSNumber?) {
        hide((animated != 0))
    }

    private func displayDuration(for string: String) -> TimeInterval {
        let minimum = max(TimeInterval(string.count) * 0.06 + 0.5, minimumDismissTimeInterval)
        return min(minimum, maximumDismissTimeInterval)
    }

    // MARK: - Layout & Drawing

    func layoutSubviews() {

        // Entirely cover the parent view
        frame = superview?.bounds ?? .zero

        // Determine the total width and height needed
        let maxWidth = bounds.size.width - margin * 4
        var totalSize = CGSize.zero
        var indicatorFrame = indicator?.bounds ?? .zero
        switch mode {
        case .determinate, .info, .success, .error: indicatorFrame.size.height = spinnerSize
        default: break
        }
        indicatorFrame.size.width = min(indicatorFrame.size.width, maxWidth)
        totalSize.width = max(totalSize.width, indicatorFrame.size.width)
        totalSize.height += indicatorFrame.size.height
        if indicatorFrame.size.height > 0.0 {
            totalSize.height += padding
        }

        var statusLabelSize: CGSize = statusLabel.string.count > 0 ? statusLabel.string.size(withAttributes: [NSAttributedString.Key.font: statusLabel.font!]) : CGSize.zero
        if statusLabelSize.width > 0.0 {
            statusLabelSize.width += 10.0
        }
        statusLabelSize.width = min(statusLabelSize.width, maxWidth)
        totalSize.width = max(totalSize.width, statusLabelSize.width)
        totalSize.height += statusLabelSize.height
        if statusLabelSize.height > 0.0 && indicatorFrame.size.height > 0.0 {
            totalSize.height += padding
        }
        totalSize.width += margin * 2
        totalSize.height += margin * 2

        // Position elements
        var yPos = round((bounds.size.height - totalSize.height) / 2) + margin - yOffset
        if indicatorFrame.size.height > 0.0 {
            yPos += padding
        }
        if statusLabelSize.height > 0.0 && indicatorFrame.size.height > 0.0 {
            yPos += padding + statusLabelSize.height
        }
		let xPos: CGFloat = -bounds.size.width / 2 + xOffset
        indicatorFrame.origin.y = yPos
        indicatorFrame.origin.x = round((bounds.size.width - indicatorFrame.size.width) / 2) + xPos
        indicator?.frame = indicatorFrame

        if indicatorFrame.size.height > 0.0 {
            yPos -= padding * 2
        }

        if statusLabelSize.height > 0.0 && indicatorFrame.size.height > 0.0 {
            yPos -= padding + statusLabelSize.height
        }
        var statusLabelFrame = CGRect.zero
        statusLabelFrame.origin.y = yPos
        statusLabelFrame.origin.x = round((bounds.size.width - statusLabelSize.width) / 2) + xPos
        statusLabelFrame.size = statusLabelSize
        statusLabel.frame = statusLabelFrame

        size = totalSize
    }

    override func draw(_ rect: NSRect) {
        layoutSubviews()
        NSGraphicsContext.saveGraphicsState()
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        switch maskType {
        case .black:
            context.setFillColor(NSColor.black.withAlphaComponent(0.6).cgColor)
            rect.fill()
        case let .custom(color):
            context.setFillColor(color.cgColor)
            rect.fill()
        default:
            break
        }

        // Set background rect color
        context.setFillColor(style.backgroundColor.withAlphaComponent(opacity).cgColor)

        // Center HUD
        let allRect = bounds

        // Draw rounded HUD backgroud rect
		let xPosition: CGFloat = 40.0
        let boxRect = CGRect(x: xPosition,
                             y: round((allRect.size.height - size.height) / 2) - yOffset,
                             width: size.width, height: size.height)
        let radius = cornerRadius
        context.beginPath()
        context.move(to: CGPoint(x: boxRect.minX + radius, y: boxRect.minY))
        context.addArc(center: CGPoint(x: boxRect.maxX - radius, y: boxRect.minY + radius), radius: radius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.maxX - radius, y: boxRect.maxY - radius), radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.minX + radius, y: boxRect.maxY - radius), radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: false)
        context.addArc(center: CGPoint(x: boxRect.minX + radius, y: boxRect.minY + radius), radius: radius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: false)
        context.closePath()
        context.fillPath()

        let center = CGPoint(x: xPosition, y: boxRect.origin.y + boxRect.size.height - spinnerSize * 0.9)
        switch mode {
        case .determinate:

            // Draw determinate progress
            let lineWidth: CGFloat = 4.0
            let processBackgroundPath = NSBezierPath()
            processBackgroundPath.lineWidth = lineWidth
            processBackgroundPath.lineCapStyle = .round

            let radius = spinnerSize / 2
            let startAngle: CGFloat = 90
            var endAngle = startAngle - 360 * CGFloat(progress)
            processBackgroundPath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            context.setStrokeColor(style.foregroundColor.cgColor)
            processBackgroundPath.stroke()
            let processPath = NSBezierPath()
            processPath.lineCapStyle = .round
            processPath.lineWidth = lineWidth
            endAngle = startAngle - .pi * 2
            processPath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            context.setFillColor(style.foregroundColor.cgColor)
            processPath.stroke()

        case .info:
            drawInfoSymbol(frame: NSRect(x: center.x - spinnerSize / 2, y: center.y - spinnerSize / 2, width: spinnerSize, height: spinnerSize))

        case .success:
            drawSuccessSymbol(frame: NSRect(x: center.x - spinnerSize / 2, y: center.y - spinnerSize / 2, width: spinnerSize, height: spinnerSize))

        case .error:
            drawErrorSymbol(frame: NSRect(x: center.x - spinnerSize / 2, y: center.y - spinnerSize / 2, width: spinnerSize, height: spinnerSize))

        default:
            break
        }

        NSGraphicsContext.restoreGraphicsState()
    }

    private func drawInfoSymbol(frame: NSRect) {
        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }

        //// Oval Drawing
        let ovalPath = NSBezierPath(ovalIn: NSRect(x: frame.minX + fastFloor((frame.width - 58) * 0.50000 + 0.5), y: frame.minY + fastFloor((frame.height - 58) * 0.50000 + 0.5), width: 58, height: 58))
        style.foregroundColor.setStroke()
        ovalPath.lineWidth = 2
        ovalPath.stroke()

        //// Text Drawing
        let textPath = NSBezierPath()
        textPath.move(to: NSPoint(x: frame.minX + 30.31, y: frame.maxY - 10.28))
        textPath.curve(to: NSPoint(x: frame.minX + 32.05, y: frame.maxY - 11), controlPoint1: NSPoint(x: frame.minX + 30.99, y: frame.maxY - 10.28), controlPoint2: NSPoint(x: frame.minX + 31.57, y: frame.maxY - 10.52))
        textPath.curve(to: NSPoint(x: frame.minX + 32.77, y: frame.maxY - 12.75), controlPoint1: NSPoint(x: frame.minX + 32.53, y: frame.maxY - 11.48), controlPoint2: NSPoint(x: frame.minX + 32.77, y: frame.maxY - 12.07))
        textPath.curve(to: NSPoint(x: frame.minX + 32.05, y: frame.maxY - 14.51), controlPoint1: NSPoint(x: frame.minX + 32.77, y: frame.maxY - 13.43), controlPoint2: NSPoint(x: frame.minX + 32.53, y: frame.maxY - 14.02))
        textPath.curve(to: NSPoint(x: frame.minX + 30.31, y: frame.maxY - 15.24), controlPoint1: NSPoint(x: frame.minX + 31.57, y: frame.maxY - 15), controlPoint2: NSPoint(x: frame.minX + 30.99, y: frame.maxY - 15.24))
        textPath.curve(to: NSPoint(x: frame.minX + 28.55, y: frame.maxY - 14.51), controlPoint1: NSPoint(x: frame.minX + 29.62, y: frame.maxY - 15.24), controlPoint2: NSPoint(x: frame.minX + 29.04, y: frame.maxY - 15))
        textPath.curve(to: NSPoint(x: frame.minX + 27.81, y: frame.maxY - 12.75), controlPoint1: NSPoint(x: frame.minX + 28.06, y: frame.maxY - 14.02), controlPoint2: NSPoint(x: frame.minX + 27.81, y: frame.maxY - 13.43))
        textPath.curve(to: NSPoint(x: frame.minX + 28.54, y: frame.maxY - 11), controlPoint1: NSPoint(x: frame.minX + 27.81, y: frame.maxY - 12.07), controlPoint2: NSPoint(x: frame.minX + 28.06, y: frame.maxY - 11.48))
        textPath.curve(to: NSPoint(x: frame.minX + 30.31, y: frame.maxY - 10.28), controlPoint1: NSPoint(x: frame.minX + 29.02, y: frame.maxY - 10.52), controlPoint2: NSPoint(x: frame.minX + 29.61, y: frame.maxY - 10.28))
        textPath.close()
        textPath.move(to: NSPoint(x: frame.minX + 32.33, y: frame.maxY - 21.98))
        textPath.line(to: NSPoint(x: frame.minX + 32.33, y: frame.maxY - 39.95))
        textPath.curve(to: NSPoint(x: frame.minX + 32.64, y: frame.maxY - 42.74), controlPoint1: NSPoint(x: frame.minX + 32.33, y: frame.maxY - 41.35), controlPoint2: NSPoint(x: frame.minX + 32.43, y: frame.maxY - 42.28))
        textPath.curve(to: NSPoint(x: frame.minX + 33.54, y: frame.maxY - 43.78), controlPoint1: NSPoint(x: frame.minX + 32.84, y: frame.maxY - 43.21), controlPoint2: NSPoint(x: frame.minX + 33.14, y: frame.maxY - 43.55))
        textPath.curve(to: NSPoint(x: frame.minX + 35.73, y: frame.maxY - 44.12), controlPoint1: NSPoint(x: frame.minX + 33.94, y: frame.maxY - 44.01), controlPoint2: NSPoint(x: frame.minX + 34.67, y: frame.maxY - 44.12))
        textPath.line(to: NSPoint(x: frame.minX + 35.73, y: frame.maxY - 45))
        textPath.line(to: NSPoint(x: frame.minX + 24.86, y: frame.maxY - 45))
        textPath.line(to: NSPoint(x: frame.minX + 24.86, y: frame.maxY - 44.12))
        textPath.curve(to: NSPoint(x: frame.minX + 27.06, y: frame.maxY - 43.8), controlPoint1: NSPoint(x: frame.minX + 25.95, y: frame.maxY - 44.12), controlPoint2: NSPoint(x: frame.minX + 26.68, y: frame.maxY - 44.02))
        textPath.curve(to: NSPoint(x: frame.minX + 27.95, y: frame.maxY - 42.75), controlPoint1: NSPoint(x: frame.minX + 27.43, y: frame.maxY - 43.59), controlPoint2: NSPoint(x: frame.minX + 27.73, y: frame.maxY - 43.24))
        textPath.curve(to: NSPoint(x: frame.minX + 28.28, y: frame.maxY - 39.95), controlPoint1: NSPoint(x: frame.minX + 28.17, y: frame.maxY - 42.27), controlPoint2: NSPoint(x: frame.minX + 28.28, y: frame.maxY - 41.33))
        textPath.line(to: NSPoint(x: frame.minX + 28.28, y: frame.maxY - 31.33))
        textPath.curve(to: NSPoint(x: frame.minX + 28.06, y: frame.maxY - 26.62), controlPoint1: NSPoint(x: frame.minX + 28.28, y: frame.maxY - 28.9), controlPoint2: NSPoint(x: frame.minX + 28.21, y: frame.maxY - 27.33))
        textPath.curve(to: NSPoint(x: frame.minX + 27.52, y: frame.maxY - 25.53), controlPoint1: NSPoint(x: frame.minX + 27.95, y: frame.maxY - 26.1), controlPoint2: NSPoint(x: frame.minX + 27.77, y: frame.maxY - 25.73))
        textPath.curve(to: NSPoint(x: frame.minX + 26.52, y: frame.maxY - 25.22), controlPoint1: NSPoint(x: frame.minX + 27.28, y: frame.maxY - 25.33), controlPoint2: NSPoint(x: frame.minX + 26.94, y: frame.maxY - 25.22))
        textPath.curve(to: NSPoint(x: frame.minX + 24.86, y: frame.maxY - 25.59), controlPoint1: NSPoint(x: frame.minX + 26.07, y: frame.maxY - 25.22), controlPoint2: NSPoint(x: frame.minX + 25.51, y: frame.maxY - 25.35))
        textPath.line(to: NSPoint(x: frame.minX + 24.52, y: frame.maxY - 24.71))
        textPath.line(to: NSPoint(x: frame.minX + 31.26, y: frame.maxY - 21.98))
        textPath.line(to: NSPoint(x: frame.minX + 32.33, y: frame.maxY - 21.98))
        textPath.close()
        style.foregroundColor.setFill()
        textPath.fill()
    }

    private func drawSuccessSymbol(frame: NSRect) {
        let bezierPath = NSBezierPath()
        bezierPath.move(to: NSPoint(x: frame.minX + 0.05833 * frame.width, y: frame.minY + 0.48377 * frame.height))
        bezierPath.line(to: NSPoint(x: frame.minX + 0.31429 * frame.width, y: frame.minY + 0.19167 * frame.height))
        bezierPath.line(to: NSPoint(x: frame.minX + 0.93333 * frame.width, y: frame.minY + 0.80833 * frame.height))
        style.foregroundColor.setStroke()
        bezierPath.lineWidth = 4
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()
    }

    private func drawErrorSymbol(frame: NSRect) {
        let bezier3Path = NSBezierPath()
        bezier3Path.move(to: NSPoint(x: frame.minX + 8, y: frame.maxY - 52))
        bezier3Path.line(to: NSPoint(x: frame.minX + 52, y: frame.maxY - 8))
        bezier3Path.move(to: NSPoint(x: frame.minX + 52, y: frame.maxY - 52))
        bezier3Path.line(to: NSPoint(x: frame.minX + 8, y: frame.maxY - 8))
        style.foregroundColor.setStroke()
        bezier3Path.lineWidth = 4
        bezier3Path.stroke()
    }

    // MARK: - Notifications

    static let didReceiveMouseDownEvent = Notification.Name("ProgressHUD.didReceiveMouseDownEvent")
    static let willDisappear = Notification.Name("ProgressHUD.willDisappear")
    static let didDisappear = Notification.Name("ProgressHUD.didDisappear")
    static let willAppear = Notification.Name("ProgressHUD.willAppear")
    static let didAppear = Notification.Name("ProgressHUD.didAppear")

}

// MARK: -

private class ProgressIndicatorLayer: CALayer {

    private(set) var isRunning = false

    private var color: NSColor

    private var finBoundsForCurrentBounds: CGRect {
        let size: CGSize = bounds.size
        let minSide: CGFloat = size.width > size.height ? size.height : size.width
        let width: CGFloat = minSide * 0.095
        let height: CGFloat = minSide * 0.30
        return CGRect(x: 0, y: 0, width: width, height: height)
    }

    private var finAnchorPointForCurrentBounds: CGPoint {
        let size: CGSize = bounds.size
        let minSide: CGFloat = size.width > size.height ? size.height : size.width
        let height: CGFloat = minSide * 0.30
        return CGPoint(x: 0.5, y: -0.9 * (minSide - height) / minSide)
    }

    private var animationTimer: Timer?
    private var fposition = 0
    private var fadeDownOpacity: CGFloat = 0.0
    private var numFins = 12
    private var finLayers = [CALayer]()

    init(size: CGFloat, color: NSColor) {
        self.color = color
        super.init()
        bounds = CGRect(x: -(size / 2), y: -(size / 2), width: size, height: size)
        createFinLayers()
        if isRunning {
            setupAnimTimer()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        stopProgressAnimation()
        removeFinLayers()
    }

    func startProgressAnimation() {
        isHidden = false
        isRunning = true
        fposition = numFins - 1
        setNeedsDisplay()
        setupAnimTimer()
    }

    func stopProgressAnimation() {
        isRunning = false
        disposeAnimTimer()
        setNeedsDisplay()
    }

    // Animation
    @objc private func advancePosition() {
        fposition += 1
        if fposition >= numFins {
            fposition = 0
        }
        let fin = finLayers[fposition]
        // Set the next fin to full opacity, but do it immediately, without any animation
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        fin.opacity = 1.0
        CATransaction.commit()
        // Tell that fin to animate its opacity to transparent.
        fin.opacity = Float(fadeDownOpacity)
        setNeedsDisplay()
    }

    private func removeFinLayers() {
        for finLayer in finLayers {
            finLayer.removeFromSuperlayer()
        }
    }

    private func createFinLayers() {
        removeFinLayers()
        // Create new fin layers
        let finBounds: CGRect = finBoundsForCurrentBounds
        let finAnchorPoint: CGPoint = finAnchorPointForCurrentBounds
        let finPosition = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let finCornerRadius: CGFloat = finBounds.size.width / 2
        for i in 0..<numFins {
            let newFin = CALayer()
            newFin.bounds = finBounds
            newFin.anchorPoint = finAnchorPoint
            newFin.position = finPosition
            newFin.transform = CATransform3DMakeRotation(CGFloat(i) * (-6.282185 / CGFloat(numFins)), 0.0, 0.0, 1.0)
            newFin.cornerRadius = finCornerRadius
            newFin.backgroundColor = color.cgColor
            // Set the fin's initial opacity
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            newFin.opacity = Float(fadeDownOpacity)
            CATransaction.commit()
            // set the fin's fade-out time (for when it's animating)
            let anim = CABasicAnimation()
            anim.duration = 0.7
            let actions = ["opacity": anim]
            newFin.actions = actions
            addSublayer(newFin)
            finLayers.append(newFin)
        }
    }

    private func setupAnimTimer() {
        // Just to be safe kill any existing timer.
        disposeAnimTimer()
        // Why animate if not visible?  viewDidMoveToWindow will re-call this method when needed.
        animationTimer = Timer(timeInterval: TimeInterval(0.05), target: self, selector: #selector(ProgressIndicatorLayer.advancePosition), userInfo: nil, repeats: true)
        animationTimer?.fireDate = Date()
        if let aTimer = animationTimer {
            RunLoop.current.add(aTimer, forMode: .common)
        }
        if let aTimer = animationTimer {
            RunLoop.current.add(aTimer, forMode: .default)
        }
        if let aTimer = animationTimer {
            RunLoop.current.add(aTimer, forMode: .eventTracking)
        }
    }

    private func disposeAnimTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set(newBounds) {
            super.bounds = newBounds

            // Resize the fins
            let finBounds: CGRect = finBoundsForCurrentBounds
            let finAnchorPoint: CGPoint = finAnchorPointForCurrentBounds
            let finPosition = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let finCornerRadius: CGFloat = finBounds.size.width / 2

            // do the resizing all at once, immediately
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            for fin in finLayers {
                fin.bounds = finBounds
                fin.anchorPoint = finAnchorPoint
                fin.position = finPosition
                fin.cornerRadius = finCornerRadius
            }
            CATransaction.commit()

        }
    }

}
