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
        Assert().registerToContext(context)
        Event().registerToContext(context)
        let event = context.evaluateScript("""
            const event = new Event('mousedown');
            assert(event.type === 'mousedown', 'event.type should be "mousedown"');
            event;
        """)!
        XCTAssertNil(context.exception)
        XCTAssertFalse(Event.propagationStopped(context: context, event: event))
        XCTAssertFalse(Event.immediatePropagationStopped(context: context, event: event))
        XCTAssertFalse(Event.defaultPrevented(context: context, event: event))
        context.evaluateScript("""
            event.stopPropagation();
            event.stopImmediatePropagation();
            assert(event.defaultPrevented === false, 'event.defaultPrevented should be false');
            event.preventDefault();
            assert(event.defaultPrevented === true, 'event.defaultPrevented should be true');
        """)
        XCTAssertNil(context.exception)
        XCTAssertTrue(Event.propagationStopped(context: context, event: event))
        XCTAssertTrue(Event.immediatePropagationStopped(context: context, event: event))
        XCTAssertTrue(Event.defaultPrevented(context: context, event: event))

        for _ in 0..<100 {
            autoreleasepool {
                let context = JSContext()!
                Event().registerToContext(context)
            }
        }
        XCTAssertLessThan(Event.numOfRegistrations(), 101)
    }
}
