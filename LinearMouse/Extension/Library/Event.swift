//
//  Event.swift
//  LinearMouse
//
//  Created by Jiahao Lu on 2022/1/7.
//

import Foundation

// TODO: Fully implement EventTarget?
private let eventTargetScript = """
(function () {
    'use strict';

    const $ = new WeakMap();

    // https://dom.spec.whatwg.org/#event
    globalThis.Event = class Event {
        constructor(type) {
            $.set(this, {
                type: String(type),
                stopPropagationFlag: false,
                stopImmediatePropagationFlag: false,
                canceledFlag: false,
                timeStamp: Date.now(),
            });
        }

        get type() {
            return $.get(this).type;
        }

        stopPropagation() {
            $.get(this).stopPropagationFlag = true;
        }

        stopImmediatePropagation() {
            $.get(this).stopPropagationFlag = true;
            $.get(this).stopImmediatePropagationFlag = true;
        }

        preventDefault() {
            $.get(this).canceledFlag = true;
        }

        get defaultPrevented() {
            return $.get(this).canceledFlag;
        }

        get timeStamp() {
            return $.get(this).timeStamp;
        }
    };

    // https://dom.spec.whatwg.org/#eventtarget
    globalThis.EventTarget = class EventTarget {
        addEventListener(type, callback) {

        }

        removeEventListener(type, callback) {

        }

        dispatchEvent(event) {

        }
    };

    return {
        getInternalData(event) {
            return $.get(event);
        }
    };
})();
"""

class Event: Library {
    var getInternalDataFunction: JSValue? = nil

    func registerToContext(_ context: JSContext) {
        assert(getInternalDataFunction == nil)
        let privateMethods = context.evaluateScript(eventTargetScript)
        assert(context.exception == nil, String(describing: context.exception))
        getInternalDataFunction = privateMethods!.forProperty("getInternalData")
    }

    private func getInternalData(event: JSValue) -> JSValue {
        assert(getInternalDataFunction != nil)
        return getInternalDataFunction!.call(withArguments: [event])
    }

    func propagationStopped(event: JSValue) -> Bool {
        let value = getInternalData(event: event).forProperty("stopPropagationFlag")!
        assert(value.isBoolean)
        return value.toBool()
    }

    func immediatePropagationStopped(event: JSValue) -> Bool {
        let value = getInternalData(event: event).forProperty("stopImmediatePropagationFlag")!
        assert(value.isBoolean)
        return value.toBool()
    }

    func defaultPrevented(event: JSValue) -> Bool {
        let value = getInternalData(event: event).forProperty("canceledFlag")!
        assert(value.isBoolean)
        return value.toBool()
    }
}
