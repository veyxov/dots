#include QMK_KEYBOARD_H
#include <string.h>

#include "raw_hid.h"
#include "keymap.h"
#include "adaptive.h"

#define BOOTLOADER_MAGIC "BOOTLDR1"
#define LANGUAGE_MAGIC "SETLANG"
#define RAW_HID_REPORT_SIZE 32

// One-shot taps: pressing `custom` sends `action` once.
static const struct { uint16_t custom, action; } tap_macros[] = {
    {CG_WBSPC, A(KC_BSPC)}, // word backspace
    {CG_COPY, G(KC_C)},
    {CG_PASTE, G(KC_V)},
    {CG_SELALL, G(KC_A)},
};

static bool process_record_features(uint16_t keycode, keyrecord_t *record) {
    // NUMWORD: smart num layer (T-34 style), self-exits on any key not in
    // this allowlist. Layer state is the source of truth, no shadow flag.
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

    for (uint8_t i = 0; i < ARRAY_SIZE(tap_macros); i++) {
        if (keycode == tap_macros[i].custom) {
            if (record->event.pressed) tap_code16(tap_macros[i].action);
            return false;
        }
    }

    switch (keycode) {
        case LANG_SW:
            if (record->event.pressed) {
                reset_adaptive_user();
                set_single_default_layer(get_highest_layer(default_layer_state) == _BASE ? _CYR : _BASE);
                tap_code16(C(KC_SPC));
            }
            return false;
        case NUMWORD:
            if (record->event.pressed) layer_invert(_NUM);
            return false;
        case REP:
            if (!record->event.pressed) {
                keyevent_t press_event = record->event;
                press_event.pressed = true;
                // Ctrl+Repeat re-invokes the alt-repeat (e.g. Ctrl+C twice = exit).
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
        default:
            return true;
    }
}

// Arrow-thumb mod-taps resolve hold on next keypress (fast Alt+M rolls);
// LTNAV still waits out TAPPING_TERM since T is too common to misread as NAV.
bool get_hold_on_other_key_press(uint16_t keycode, keyrecord_t *record) {
    return keycode == MT(MOD_LALT, KC_RGHT) || keycode == MT(MOD_LCTL, KC_LEFT);
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    if (keycode == LANG_SW) return process_record_features(keycode, record);

    switch (keycode) {
        case QK_MOD_TAP ... QK_MOD_TAP_MAX:
        case QK_LAYER_TAP ... QK_LAYER_TAP_MAX:
            if (record->tap.count == 0) return true; // let QMK resolve tap/hold first
            // Tapping LTNAV mid-repeat sends plain T directly, bypassing repeat
            // bookkeeping, so T after REP can't disturb the sequence.
            if (keycode == LTNAV && get_repeat_key_count() > 0) {
                if (record->event.pressed) tap_code(KC_T);
                return false;
            }
            keycode &= QK_BASIC_MAX; // trim mods + taps
            break;
    }

    // Adaptive pairs are base-layer-only; on other layers transparent keys
    // resolve to the same base keycodes and would misfire (e.g. F+M on NAV).
    if (get_highest_layer(layer_state | default_layer_state) == _BASE && !process_adaptive_user(keycode, record)) {
        return false;
    }

    return process_record_features(keycode, record);
}

void matrix_scan_user(void) {
    matrix_adaptive_user();
}

bool remember_last_key_user(uint16_t keycode, keyrecord_t *record, uint8_t *remembered_mods) {
    return keycode != REP;
}

void raw_hid_receive(uint8_t *data, uint8_t length) {
    if (length != RAW_HID_REPORT_SIZE) {
        return;
    }

    if (memcmp(data, BOOTLOADER_MAGIC, sizeof(BOOTLOADER_MAGIC) - 1) == 0) {
        uint8_t response[RAW_HID_REPORT_SIZE] = {0};
        memcpy(response, "BOOTING", sizeof("BOOTING") - 1);
        raw_hid_send(response, sizeof(response));
        wait_ms(10);
        reset_keyboard();
    } else if (memcmp(data, LANGUAGE_MAGIC, sizeof(LANGUAGE_MAGIC) - 1) == 0 &&
               (data[7] == '0' || data[7] == '1')) {
        const uint8_t layer = data[7] == '1' ? _CYR : _BASE;
        if (get_highest_layer(default_layer_state) != layer) {
            reset_adaptive_user();
            set_single_default_layer(layer);
        }
    }
}
