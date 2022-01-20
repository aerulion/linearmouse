//
//  Transformer.swift
//  LinearMouse
//
//  Created by lujjjh on 2021/11/20.
//

import Foundation

protocol EventTransformer {
    func transform(_ event: CGEvent) -> CGEvent?
}

func getTransformers(appDefaults: AppDefaults) -> [EventTransformer] {
    let transformers: [(Bool, () -> EventTransformer)] = [
        (appDefaults.reverseScrollingOn,        { ReverseScrolling() }),
        (appDefaults.linearScrollingOn,         { LinearScrolling(scrollLines: appDefaults.scrollLines) }),
        (appDefaults.universalBackForwardOn,    { UniversalBackForward() }),
        (true,                                  { ModifierActions(commandAction: appDefaults.modifiersCommandAction,
                                                                  shiftAction: appDefaults.modifiersShiftAction,
                                                                  alternateAction: appDefaults.modifiersAlternateAction,
                                                                  controlAction: appDefaults.modifiersControlAction) }),
    ]

    return transformers.filter { $0.0 }.map { $0.1() }
}

func transformEvent(appDefaults: AppDefaults, mouseDetector: MouseDetector, event: CGEvent) -> CGEvent? {
    guard !mouseDetector.isMouseEvent(event) else {
        return event
    }

    var transformed: CGEvent? = event
    let transformers = getTransformers(appDefaults: appDefaults)
    for transformer in transformers {
        if let transformedEvent = transformed {
            transformed = transformer.transform(transformedEvent)
        }
    }
    return transformed
}
