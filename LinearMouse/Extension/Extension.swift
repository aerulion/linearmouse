//
//  Extension.swift
//  LinearMouse
//
//  Created by Jiahao Lu on 2022/1/3.
//

import Foundation
import JavaScriptCore

enum ExtensionError: Error {
    case jsError(JSValue)
}

class Extension {
    private let name: String
    private var context: JSContext!

    private let initializeTimeLimitInSeconds = 0.5

    init(name: String, script: String) throws {
        self.name = name
        createContext()
        withExecutionTimeLimit(seconds: initializeTimeLimitInSeconds) {
            context.evaluateScript("'use strict';" + script)
        }
        try checkException()
    }

    private func createContext() {
        context = JSContext()!
        RuntimeCore().registerToContext(context)
    }

    @discardableResult
    private func withExecutionTimeLimit<T>(seconds: Double, eval: () -> T) -> T {
        let group = JSContextGetGroup(context.jsGlobalContextRef)
        JSContextGroupSetExecutionTimeLimit(group, seconds, nil, nil)
        let result = eval()
        JSContextGroupClearExecutionTimeLimit(group)
        return result
    }

    private func checkException() throws {
        if let ex = context.exception {
            throw ExtensionError.jsError(ex)
        }
    }
}
