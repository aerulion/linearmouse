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
    private static let getInternalDataMap = NSMapTable<JSContext, JSValue>(keyOptions: .weakMemory, valueOptions: .weakMemory)

    private var getInternalDataList: [JSValue] = []

    func registerInContext(_ context: JSContext) {
        let privateMethods = context.evaluateScript(eventTargetScript)
        assert(context.exception == nil, String(describing: context.exception))
        let getInternalData = privateMethods!.forProperty("getInternalData")!
        getInternalDataList.append(getInternalData)
        Self.getInternalDataMap.setObject(getInternalData, forKey: context)
    }

    private static func getInternalData(context: JSContext, event: JSValue) -> JSValue {
        let getInternalData = getInternalDataMap.object(forKey: context)
        assert(getInternalData != nil)
        return getInternalData!.call(withArguments: [event])
    }

    static func propagationStopped(context: JSContext, event: JSValue) -> Bool {
        let value = getInternalData(context: context, event: event).forProperty("stopPropagationFlag")!
        assert(value.isBoolean)
        return value.toBool()
    }

    static func immediatePropagationStopped(context: JSContext, event: JSValue) -> Bool {
        let value = getInternalData(context: context, event: event).forProperty("stopImmediatePropagationFlag")!
        assert(value.isBoolean)
        return value.toBool()
    }

    static func defaultPrevented(context: JSContext, event: JSValue) -> Bool {
        let value = getInternalData(context: context, event: event).forProperty("canceledFlag")!
        assert(value.isBoolean)
        return value.toBool()
    }

    static func numOfRegistrations() -> Int {
        getInternalDataMap.count
    }
}
