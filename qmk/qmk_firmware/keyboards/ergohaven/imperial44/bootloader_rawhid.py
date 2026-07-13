#!/usr/bin/env python3

import sys
import time

import hid

VID = 0xE126
PID = 0x0080
RAW_USAGE_PAGE = 0xFF60
RAW_USAGE = 0x61
REPORT_SIZE = 32
BOOTLOADER_MAGIC = b"BOOTLDR1"


def find_raw_device():
    for device in hid.enumerate(VID, PID):
        if device.get("usage_page") == RAW_USAGE_PAGE and device.get("usage") == RAW_USAGE:
            return device
    return None


def main() -> int:
    device_info = find_raw_device()
    if device_info is None:
        print("Raw HID interface not found. Use a manual bootloader entry once to install the new firmware.", file=sys.stderr)
        return 1

    payload = BOOTLOADER_MAGIC.ljust(REPORT_SIZE, b"\0")
    path = device_info["path"]

    dev = hid.device()
    dev.open_path(path)
    try:
        dev.write(b"\0" + payload)
        dev.set_nonblocking(1)
        time.sleep(0.25)
        dev.read(REPORT_SIZE)
    finally:
        dev.close()

    time.sleep(0.25)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
