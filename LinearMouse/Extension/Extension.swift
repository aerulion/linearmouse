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
    private var libraries: [Library] = []

    private let initializeTimeLimitInSeconds = 0.5

    init(name: String, script: String) throws {
        self.name = name
        initContext()
        try run(withTimeLimitInSeconds: initializeTimeLimitInSeconds) {
            context.evaluateScript("(function () { 'use strict'; " + script + " })();")
        }
    }

    private func initContext() {
        context = JSContext()!
        libraries = [
            Console(extensionName: self.name),
            Core(),
        ]
        libraries.forEach({ $0.registerToContext(context) })
    }

    @discardableResult
    private func run<T>(withTimeLimitInSeconds: Double, eval: () -> T) throws -> T {
        let group = JSContextGetGroup(context.jsGlobalContextRef)
        JSContextGroupSetExecutionTimeLimit(group, withTimeLimitInSeconds, nil, nil)
        let result = eval()
        JSContextGroupClearExecutionTimeLimit(group)
        if let ex = context.exception {
            throw ExtensionError.jsError(ex)
        }
        return result
    }
}
