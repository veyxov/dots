#!/usr/bin/env bash

set -euo pipefail

KEYBOARD="${KEYBOARD:-ergohaven/imperial44}"
KEYMAP="${KEYMAP:-veyxov}"
QMK_HOME="${QMK_HOME:-/home/iz/qmk_firmware}"
TARGET="${TARGET:-ergohaven_imperial44_veyxov}"
UF2_FILE="${UF2_FILE:-$QMK_HOME/.build/${TARGET}.uf2}"
BOOT_DRIVE_LABEL="${BOOT_DRIVE_LABEL:-RPI-RP2}"
MOUNT_POINT="${MOUNT_POINT:-/mnt/keyboard}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
UPSTREAM_KEYBOARD_DIR="$QMK_HOME/keyboards/$KEYBOARD"

ensure_upstream_keyboard_link() {
    local parent_dir
    parent_dir="$(dirname -- "$UPSTREAM_KEYBOARD_DIR")"

    mkdir -p "$parent_dir"

    if [[ -L "$UPSTREAM_KEYBOARD_DIR" ]]; then
        if [[ "$(readlink -f -- "$UPSTREAM_KEYBOARD_DIR")" == "$SCRIPT_DIR" ]]; then
            return
        fi
        rm -f "$UPSTREAM_KEYBOARD_DIR"
    elif [[ -e "$UPSTREAM_KEYBOARD_DIR" ]]; then
        return
    fi

    ln -s "$SCRIPT_DIR" "$UPSTREAM_KEYBOARD_DIR"
}

cd "$QMK_HOME"
ensure_upstream_keyboard_link

printf 'Compiling %s:%s\n' "$KEYBOARD" "$KEYMAP"
make "$KEYBOARD:$KEYMAP"

if sudo -n python3 "$SCRIPT_DIR/bootloader_rawhid.py"; then
    printf 'Entered bootloader over Raw HID.\n'
else
    printf 'Raw HID bootloader jump unavailable. Press QK_BOOTLOADER now.\n'
fi

printf 'Waiting for %s bootloader drive...\n' "$BOOT_DRIVE_LABEL"

boot_device=''
for _ in $(seq 1 100); do
    boot_device="$(lsblk -pnro PATH,LABEL | awk -v label="$BOOT_DRIVE_LABEL" '$2 == label { print $1; exit }')"
    if [[ -n "$boot_device" ]]; then
        break
    fi
    sleep 0.1
done

if [[ -z "$boot_device" ]]; then
    printf 'Bootloader drive %s not found.\n' "$BOOT_DRIVE_LABEL" >&2
    exit 1
fi

printf 'Flashing %s via %s\n' "$UF2_FILE" "$boot_device"
sudo mkdir -p "$MOUNT_POINT"
sudo mount "$boot_device" "$MOUNT_POINT"
sudo cp -v "$UF2_FILE" "$MOUNT_POINT/"
sudo umount "$MOUNT_POINT"

sleep 5
printf 'done\n'
