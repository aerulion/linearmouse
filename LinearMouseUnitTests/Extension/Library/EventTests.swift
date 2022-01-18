//
//  EventTests.swift
//  LinearMouseUnitTests
//
//  Created by Jiahao Lu on 2022/1/7.
//

import XCTest
@testable import LinearMouse

class EventTests: XCTestCase {
    func testEvent() throws {
        let context = JSContext()!
        Assert().registerInContext(context)
        Event().registerInContext(context)
        context.evaluateScript("""
            let fired;
            const target = new EventTarget();
            target.addEventListener('mousedown', (e) => {
                e.preventDefault();
                fired = true;
            });
            const event = new Event('mousedown', { cancelable: true });
            assert(!target.dispatchEvent(event));
            assert(fired);
        """)
        XCTAssertNil(context.exception)
    }
}
