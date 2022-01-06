//
//  Touch-Bridging-Header.h
//  LinearMouse
//
//  Created by lujjjh on 2021/8/5.
//

#include <IOKit/hidsystem/IOHIDEventSystemClient.h>
#include <JavaScriptCore/JSObjectRef.h>
#include <JavaScriptCore/JSValueRef.h>
#include "../Touch/TouchSimulate.h"

typedef void (^IOHIDServiceClientBlock)(void *, void *, IOHIDServiceClientRef);

IOHIDEventSystemClientRef IOHIDEventSystemClientCreate(CFAllocatorRef);
void IOHIDEventSystemClientSetMatching(IOHIDEventSystemClientRef, CFDictionaryRef);
void IOHIDEventSystemClientRegisterDeviceMatchingBlock(IOHIDEventSystemClientRef, IOHIDServiceClientBlock, void *, void *);
void IOHIDEventSystemClientUnregisterDeviceMatchingBlock(IOHIDEventSystemClientRef);
void IOHIDEventSystemClientScheduleWithDispatchQueue(IOHIDEventSystemClientRef, dispatch_queue_t);

void IOHIDServiceClientRegisterRemovalBlock(IOHIDServiceClientRef, IOHIDServiceClientBlock, void*, void*);

typedef bool (*JSShouldTerminateCallback)(JSContextRef ctx, void* context);

JS_EXPORT void JSContextGroupSetExecutionTimeLimit(JSContextGroupRef group, double limit, JSShouldTerminateCallback callback, void* context) CF_AVAILABLE(10_6, 7_0);

JS_EXPORT void JSContextGroupClearExecutionTimeLimit(JSContextGroupRef group) CF_AVAILABLE(10_6, 7_0);
