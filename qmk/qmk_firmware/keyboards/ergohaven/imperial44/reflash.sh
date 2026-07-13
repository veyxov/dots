#!/usr/bin/env bash

set -euo pipefail

KEYBOARD="${KEYBOARD:-ergohaven/imperial44}"
KEYMAP="${KEYMAP:-veyxov}"
QMK_HOME="${QMK_HOME:-$HOME/qmk_firmware}"
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

ensure_upstream_keyboard_link

if python3 "$SCRIPT_DIR/bootloader_rawhid.py"; then
    printf 'Entered bootloader over Raw HID.\n'
else
    printf 'Raw HID bootloader jump unavailable. Press the physical BOOT/RESET button now.\n'
fi

cd "$QMK_HOME"
qmk flash -kb "$KEYBOARD" -km "$KEYMAP"
