//
//  ReverseScrollingTests.swift
//  LinearMouseUnitTests
//
//  Created by lujjjh on 2021/11/20.
//

import XCTest
@testable import LinearMouse

class ReverseScrollingTests: XCTestCase {
    func testReverseScrolling() throws {
        let transformer = ReverseScrolling()
        var event = CGEvent(scrollWheelEvent2Source: nil, units: .line, wheelCount: 2, wheel1: 1, wheel2: 2, wheel3: 0)!
        event = transformer.transform(event)!
        let view = ScrollWheelEventView(event)
        XCTAssertEqual(view.deltaX, 2)
        XCTAssertEqual(view.deltaY, -1)
    }
}
