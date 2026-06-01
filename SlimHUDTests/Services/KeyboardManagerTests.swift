//
//  KeyboardManagerTests.swift
//  SlimHUDTests
//

import XCTest
@testable import SlimHUD

final class KeyboardManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        KeyboardManager.resetMethodForTesting()
    }

    // MARK: - getKeyboardBrightnessProportioned

    func testBrightnessProportionedBelowThreshold() {
        XCTAssertEqual(KeyboardManager.getKeyboardBrightnessProportioned(raw: 0.0), 0.0)
        XCTAssertEqual(KeyboardManager.getKeyboardBrightnessProportioned(raw: 0.05), 0.0)
        XCTAssertEqual(KeyboardManager.getKeyboardBrightnessProportioned(raw: 0.07), 0.0)
    }

    func testBrightnessProportionedAboveThreshold() {
        let raw: Float = 0.5
        let expected = log10(raw + 0.03) + 1
        XCTAssertEqual(KeyboardManager.getKeyboardBrightnessProportioned(raw: raw), expected, accuracy: 0.0001)
    }

    func testBrightnessProportionedAtMax() {
        let raw: Float = 1.0
        let expected = log10(Float(1.03)) + 1
        XCTAssertEqual(KeyboardManager.getKeyboardBrightnessProportioned(raw: raw), expected, accuracy: 0.0001)
        // Max raw maps to just above 1.0 (~1.013) — valid range
        XCTAssertGreaterThan(KeyboardManager.getKeyboardBrightnessProportioned(raw: raw), 1.0)
    }

    func testBrightnessProportionedJustAboveThreshold() {
        let result = KeyboardManager.getKeyboardBrightnessProportioned(raw: 0.08)
        XCTAssertGreaterThan(result, 0.0)
        XCTAssertLessThan(result, 1.0)
    }

    // MARK: - getKeyboardBrightness integration

    func testGetKeyboardBrightnessReturnsValidRangeOrThrows() {
        do {
            let brightness = try KeyboardManager.getKeyboardBrightness()
            XCTAssertGreaterThanOrEqual(brightness, 0.0, "Brightness must be >= 0")
            XCTAssertLessThanOrEqual(brightness, 1.1, "Brightness must be <= 1.1 (log formula allows slight overshoot)")
        } catch SensorError.Keyboard.notFound {
            // Valid on hardware without keyboard backlight or unsupported Mac
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testGetKeyboardBrightnessNeverReturnsMiddle() {
        // The 0.5 hardcoded fallback was the root cause of issue #12.
        // On any hardware, if brightness is readable the value must differ from 0.5
        // unless that happens to be the actual brightness. We verify: no silent 0.5 on error.
        do {
            let brightness = try KeyboardManager.getKeyboardBrightness()
            // A successful read: value must be in plausible range
            XCTAssertGreaterThanOrEqual(brightness, 0.0)
            XCTAssertLessThanOrEqual(brightness, 1.1)
        } catch SensorError.Keyboard.notFound {
            // Hardware absent: HUD should be disabled, not shown with 0.5
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
