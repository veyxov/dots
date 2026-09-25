#!/usr/bin/swift

import Carbon
import Foundation
import IOKit.hid

// The installed RussianTajikPhonetic.keylayout reports this input source ID.
private let cyrillicSourceID = "org.unknown.keylayout.Russian-TajikPhoneticHandsDown"
private let vendorID = 0xE126
private let productID = 0x0080
private let rawUsagePage: UInt32 = 0xFF60
private let rawUsage: UInt32 = 0x61
private let refreshInterval = 2.0

private func currentSourceID() -> String? {
    let source = TISCopyCurrentKeyboardInputSource().takeRetainedValue()
    guard let property = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) else {
        return nil
    }
    return Unmanaged<CFString>.fromOpaque(property).takeUnretainedValue() as String
}

private let manager = IOHIDManagerCreate(kCFAllocatorDefault, 0)
IOHIDManagerSetDeviceMatching(manager, [
    kIOHIDVendorIDKey as String: vendorID,
    kIOHIDProductIDKey as String: productID,
] as CFDictionary)
IOHIDManagerScheduleWithRunLoop(manager, CFRunLoopGetCurrent(), CFRunLoopMode.defaultMode.rawValue)
let managerStatus = IOHIDManagerOpen(manager, 0)
guard managerStatus == 0 else {
    fputs("Cannot open HID manager: \(String(format: "0x%08X", managerStatus))\n", stderr)
    exit(1)
}
_ = CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.1, false)

private func rawDevice() -> IOHIDDevice? {
    guard let devices = IOHIDManagerCopyDevices(manager) else { return nil }
    for case let device as IOHIDDevice in devices as NSSet
        where IOHIDDeviceConformsTo(device, rawUsagePage, rawUsage) {
        return device
    }
    return nil
}

private func sendLanguage(_ cyrillic: Bool) -> Bool {
    guard let device = rawDevice(), IOHIDDeviceOpen(device, 0) == 0 else { return false }
    defer { IOHIDDeviceClose(device, 0) }

    var report = [UInt8](repeating: 0, count: 32)
    for (index, byte) in "SETLANG".utf8.enumerated() { report[index] = byte }
    report[7] = cyrillic ? 49 : 48 // ASCII 1 / 0
    return report.withUnsafeBufferPointer {
        IOHIDDeviceSetReport(device, kIOHIDReportTypeOutput, 0, $0.baseAddress!, report.count) == 0
    }
}

if CommandLine.arguments.contains("--status") {
    print("input source: \(currentSourceID() ?? "unknown")")
    print("Imperial44 Raw HID: \(rawDevice() == nil ? "disconnected" : "connected")")
    exit(0)
}

if CommandLine.arguments.contains("--once") {
    guard let sourceID = currentSourceID(), sendLanguage(sourceID == cyrillicSourceID) else {
        fputs("Could not synchronize input source to Imperial44\n", stderr)
        exit(1)
    }
    exit(0)
}

var lastSourceID: String?
var nextRefresh = Date.distantPast
while true {
    if let sourceID = currentSourceID() {
        if sourceID != lastSourceID {
            lastSourceID = sourceID
            nextRefresh = .distantPast
        }
        if Date() >= nextRefresh {
            _ = sendLanguage(sourceID == cyrillicSourceID)
            nextRefresh = Date().addingTimeInterval(refreshInterval)
        }
    }
    Thread.sleep(forTimeInterval: 0.25)
    _ = CFRunLoopRunInMode(CFRunLoopMode.defaultMode, 0.01, false)
}
