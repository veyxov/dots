#include QMK_KEYBOARD_H
#include <string.h>

#include "raw_hid.h"
#include "keymap.h"

#define BOOTLOADER_MAGIC "BOOTLDR1"
#define RAW_HID_REPORT_SIZE 32

bool process_record_features(uint16_t keycode, keyrecord_t *record) {
    // NUMWORD: smart num layer (T-34 style). Toggled by the thumb combo;
    // stays on while numeric-ish keys are typed, turns itself off on the
    // first other key. Layer state is the source of truth, no shadow flag.
    if (keycode != NUMWORD && layer_state_is(_NUM) && record->event.pressed) {
        switch (keycode) {
            case KC_1 ... KC_0:
            case KC_DOT:
            case KC_MINS:
            case S(KC_EQL):
            case KC_BSPC:
            case REP:
                break;
            default:
                layer_off(_NUM);
        }
    }
    switch (keycode) {
        case NUMWORD:
            if (record->event.pressed) {
                if (layer_state_is(_NUM)) layer_off(_NUM); else layer_on(_NUM);
            }
            return false;
        case REP:
            if (!record->event.pressed) {
                keyevent_t press_event = record->event;
                press_event.pressed = true;
                if (get_mods() & MOD_MASK_CTRL) {
                    uint8_t temp_mods = get_mods();
                    del_mods(MOD_MASK_CTRL);
                    alt_repeat_key_invoke(&press_event);
                    alt_repeat_key_invoke(&record->event);
                    set_mods(temp_mods);
                } else {
                    repeat_key_invoke(&press_event);
                    repeat_key_invoke(&record->event);
                }
            }
            return false;
        case LANG_SW:
            // macOS input-source-switch shortcut: Ctrl+Space.
            if (record->event.pressed) tap_code16(C(KC_SPC));
            return false;
        case CG_WBSPC:
            if (record->event.pressed) tap_code16(A(KC_BSPC));
            return false;
        case CG_COPY:
            if (record->event.pressed) tap_code16(G(KC_C));
            return false;
        case CG_PASTE:
            if (record->event.pressed) tap_code16(G(KC_V));
            return false;
        case CG_SELALL:
            if (record->event.pressed) tap_code16(G(KC_A));
            return false;
        default:
            return true;
    }
}

bool remember_last_key_features(uint16_t keycode) {
    return keycode != REP;
}

void raw_hid_receive(uint8_t *data, uint8_t length) {
    if (length != RAW_HID_REPORT_SIZE) {
        return;
    }

    if (memcmp(data, BOOTLOADER_MAGIC, sizeof(BOOTLOADER_MAGIC) - 1) == 0) {
        uint8_t response[RAW_HID_REPORT_SIZE] = {0};
        memcpy(response, "BOOTING", 7);
        raw_hid_send(response, sizeof(response));
        wait_ms(10);
        reset_keyboard();
    }
}
