#!/usr/bin/env python3
"""Set ANC/Ambient mode on Sony WH-1000XM* headphones over RFCOMM.

Protocol reverse-engineered from mos9527/SonyHeadphonesClient
(src/CommandSerializer.cpp, src/Constants.h, src/Headphones.cpp @ tag 1.4.4).
No external deps -- CPython's socket module has native AF_BLUETOOTH/RFCOMM
support on Linux.

MAC is auto-discovered via bluez DBus (matched by Sony's HPC service UUID)
unless passed explicitly with --mac.

Usage:
    sony_xm6_ctl.py ambient [--level N] [--voice] [--mac AA:BB:CC:DD:EE:FF]
    sony_xm6_ctl.py anc     [--level N]
    sony_xm6_ctl.py off
"""
import argparse
import json
import socket
import subprocess
import sys

START_MARKER = 0x3E
END_MARKER = 0x3C
ESCAPE_SENTRY = 0x3D
ESCAPE_MAP = {0x3C: 0x2C, 0x3D: 0x2D, 0x3E: 0x2E}
UNESCAPE_MAP = {v: k for k, v in ESCAPE_MAP.items()}

SERVICE_UUID = "956c7b26-d49a-4ba8-b03f-b17d393cb6e2"
DEFAULT_CHANNEL = 9  # fixed RFCOMM channel per upstream SDP dump comment

DATA_MDR = 12
NCASM_PARAM_SET = 0x68
INIT_REQUEST = 0x00


def escape_specials(data: bytes) -> bytes:
    out = bytearray()
    for b in data:
        if b in ESCAPE_MAP:
            out += bytes([ESCAPE_SENTRY, ESCAPE_MAP[b]])
        else:
            out.append(b)
    return bytes(out)


def checksum(data: bytes) -> int:
    return sum(data) & 0xFF


def package(payload: bytes, data_type: int, seq: int) -> bytes:
    body = bytes([data_type, seq]) + len(payload).to_bytes(4, "big") + payload
    body += bytes([checksum(body)])
    return bytes([START_MARKER]) + escape_specials(body) + bytes([END_MARKER])


def ncasm_set(effect: int, setting_type: int, voice: int, level: int) -> bytes:
    # 0x68 0x17 | drag-flag | on/off | NC:0/ASM:1 | voice-passthrough | level
    return bytes([NCASM_PARAM_SET, 0x17, 0x01, effect, setting_type, voice, level])


def find_headphones_mac() -> str:
    """Locate a connected bluez device advertising Sony's HPC service UUID."""
    out = subprocess.run(
        ["busctl", "--json=short", "call", "org.bluez", "/",
         "org.freedesktop.DBus.ObjectManager", "GetManagedObjects"],
        capture_output=True, text=True, check=True,
    ).stdout
    objects = json.loads(out)["data"][0]
    candidates = []
    for path, ifaces in objects.items():
        dev = ifaces.get("org.bluez.Device1")
        if not dev:
            continue
        uuids = dev.get("UUIDs", {}).get("data", [])
        connected = dev.get("Connected", {}).get("data", False)
        if SERVICE_UUID in [u.lower() for u in uuids]:
            candidates.append((connected, dev["Address"]["data"], dev.get("Name", {}).get("data", "")))
    if not candidates:
        raise SystemExit("No paired Sony headphones found (no device advertises the HPC UUID). Pass MAC manually.")
    candidates.sort(key=lambda c: not c[0])  # connected devices first
    connected, mac, name = candidates[0]
    if not connected:
        print(f"warning: {name or mac} is paired but not currently connected", file=sys.stderr)
    return mac


def read_frame(sock: socket.socket) -> bytes:
    """Read one framed reply (best-effort, used only to drain the ACK)."""
    buf = bytearray()
    b = sock.recv(1)
    while b and b[0] != START_MARKER:
        b = sock.recv(1)
    buf += b
    while True:
        b = sock.recv(1)
        if not b:
            break
        buf += b
        if b[0] == END_MARKER:
            break
    return bytes(buf)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("mode", choices=["ambient", "anc", "off"])
    ap.add_argument("--mac", help="headphones MAC address (default: auto-discover via bluez)")
    ap.add_argument("--level", type=int, default=20, help="ambient/NC level (default 20)")
    ap.add_argument("--voice", action="store_true", help="voice passthrough (ambient mode only)")
    ap.add_argument("--channel", type=int, default=DEFAULT_CHANNEL)
    args = ap.parse_args()

    mac = args.mac or find_headphones_mac()

    if args.mode == "off":
        effect, setting_type, level = 0, 0, 0
    elif args.mode == "anc":
        effect, setting_type, level = 1, 0, args.level
    else:  # ambient
        effect, setting_type, level = 1, 1, args.level
    voice = 1 if args.voice else 0

    sock = socket.socket(socket.AF_BLUETOOTH, socket.SOCK_STREAM, socket.BTPROTO_RFCOMM)
    sock.settimeout(5)
    try:
        sock.connect((mac, args.channel))

        sock.send(package(bytes([INIT_REQUEST, 0x00]), DATA_MDR, 0))
        try:
            read_frame(sock)  # drain ack/init response, ignore contents
        except socket.timeout:
            pass

        sock.send(package(ncasm_set(effect, setting_type, voice, level), DATA_MDR, 0))
        try:
            read_frame(sock)  # drain ack
        except socket.timeout:
            pass
    finally:
        sock.close()


if __name__ == "__main__":
    sys.exit(main())
