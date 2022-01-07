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
        let eventLibrary = Event()
        eventLibrary.registerToContext(context)
        let event = context.evaluateScript("""
            const event = new Event('mousedown');
            assert(event.type === 'mousedown', 'event.type should be "mousedown"');
            event;
        """)!
        XCTAssertNil(context.exception)
        XCTAssertFalse(eventLibrary.propagationStopped(event: event))
        XCTAssertFalse(eventLibrary.immediatePropagationStopped(event: event))
        XCTAssertFalse(eventLibrary.defaultPrevented(event: event))
        context.evaluateScript("""
            event.stopPropagation();
            event.stopImmediatePropagation();
            assert(event.defaultPrevented === false, 'event.defaultPrevented should be false');
            event.preventDefault();
            assert(event.defaultPrevented === true, 'event.defaultPrevented should be true');
        """)
        XCTAssertNil(context.exception)
        XCTAssertTrue(eventLibrary.propagationStopped(event: event))
        XCTAssertTrue(eventLibrary.immediatePropagationStopped(event: event))
        XCTAssertTrue(eventLibrary.defaultPrevented(event: event))
    }
}
