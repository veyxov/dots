#!/usr/bin/env bash

set -euo pipefail

KEYBOARD="${KEYBOARD:-ergohaven/imperial44}"
KEYMAP="${KEYMAP:-veyxov}"
QMK_HOME="${QMK_HOME:-$HOME/qmk_firmware}"
TARGET="${TARGET:-ergohaven_imperial44_veyxov}"
UF2_FILE="${UF2_FILE:-}"
BOOT_DRIVE_LABEL="${BOOT_DRIVE_LABEL:-RPI-RP2}"
MOUNT_POINT="${MOUNT_POINT:-/mnt/keyboard}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
UPSTREAM_KEYBOARD_DIR="$QMK_HOME/keyboards/$KEYBOARD"
IS_MACOS=0
[[ "$(uname -s)" == "Darwin" ]] && IS_MACOS=1

file_mtime() {
    if [[ "$IS_MACOS" -eq 1 ]]; then
        stat -f %m -- "$1"
    else
        stat -c %Y -- "$1"
    fi
}

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
build_started_at="$(date +%s)"
make "$KEYBOARD:$KEYMAP"

if [[ -z "$UF2_FILE" ]]; then
    for candidate in \
        "$QMK_HOME/${TARGET}.uf2" \
        "$QMK_HOME/.build/${TARGET}.uf2"
    do
        if [[ -f "$candidate" ]] && [[ "$(file_mtime "$candidate")" -ge "$build_started_at" ]]; then
            UF2_FILE="$candidate"
            break
        fi
    done
fi

if [[ -z "$UF2_FILE" ]] || [[ ! -f "$UF2_FILE" ]]; then
    printf 'Expected fresh UF2 was not produced for %s\n' "$TARGET" >&2
    exit 1
fi

rawhid_cmd=(python3 "$SCRIPT_DIR/bootloader_rawhid.py")
[[ "$IS_MACOS" -eq 0 ]] && rawhid_cmd=(sudo -n "${rawhid_cmd[@]}")

if "${rawhid_cmd[@]}"; then
    printf 'Entered bootloader over Raw HID.\n'
else
    printf 'Raw HID bootloader jump unavailable. Press the physical BOOT/RESET button now.\n'
fi

printf 'Waiting for %s bootloader drive...\n' "$BOOT_DRIVE_LABEL"

if [[ "$IS_MACOS" -eq 1 ]]; then
    boot_mount="/Volumes/$BOOT_DRIVE_LABEL"
    found=0
    for _ in $(seq 1 300); do
        if [[ -d "$boot_mount" ]]; then
            found=1
            break
        fi
        sleep 0.1
    done

    if [[ "$found" -eq 0 ]]; then
        printf 'Bootloader drive %s not found.\n' "$BOOT_DRIVE_LABEL" >&2
        exit 1
    fi

    printf 'Flashing %s via %s\n' "$UF2_FILE" "$boot_mount"
    sudo cp -v "$UF2_FILE" "$boot_mount/"
    sync
    if ! diskutil eject "$boot_mount"; then
        printf 'diskutil eject failed — board may stay stuck in bootloader until manually unplugged/replugged.\n' >&2
    fi
else
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
fi

sleep 5
printf 'done\n'
