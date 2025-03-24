//
//  TestUtils.swift
//  SlimHUDUITests
//
//  Created by Alex Perathoner on 21/04/24.
//

import XCTest

final class TestUtils: UITestsUtils {

    func testH() {
        XCTAssertTrue(h(screenFrame: .init(x: 0, y: 0, width: 1600, height: 900), x: 0, y: 400)) // left
        XCTAssertTrue(h(screenFrame: .init(x: 0, y: 0, width: 1600, height: 900), x: 800, y: 0)) // bottom
        XCTAssertFalse(h(screenFrame: .init(x: 0, y: 0, width: 1600, height: 900), x: 1600, y: 400)) // right
        XCTAssertFalse(h(screenFrame: .init(x: 0, y: 0, width: 1600, height: 900), x: 800, y: 900)) // top
    }

    func testG() {
        XCTAssertTrue(g(screenFrame: .init(x: 0, y: 0, width: 1600, height: 900), x: 0, y: 400)) // left
        XCTAssertTrue(g(screenFrame: .init(x: 0, y: 0, width: 1600, height: 900), x: -50, y: 638)) // left
        XCTAssertFalse(g(screenFrame: .init(x: 0, y: 0, width: 1600, height: 900), x: 800, y: 0)) // bottom
        XCTAssertFalse(g(screenFrame: .init(x: 0, y: 0, width: 1600, height: 900), x: 1600, y: 400)) // right
        XCTAssertTrue(g(screenFrame: .init(x: 0, y: 0, width: 1600, height: 900), x: 800, y: 900)) // top
    }

}
