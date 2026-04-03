#include QMK_KEYBOARD_H
#include <string.h>

#include "raw_hid.h"
#include "keymap.h"

#define BOOTLOADER_MAGIC "BOOTLDR1"
#define RAW_HID_REPORT_SIZE 32

void toggle_lg(void) {
    register_code(KC_LSFT);
    register_code(KC_RSFT);
    unregister_code(KC_LSFT);
    unregister_code(KC_RSFT);
}

static uint16_t num_word_timer = 0;
static bool is_num_word_on = false;

void enable_num_word(void) {
    if (is_num_word_on) {
        return;
    }

    is_num_word_on = true;
    layer_on(_NUM);
}

static void disable_num_word(void) {
    if (!is_num_word_on) {
        return;
    }

    is_num_word_on = false;
    layer_off(_NUM);
}

static bool should_terminate_num_word(uint16_t keycode, const keyrecord_t *record) {
    switch (keycode) {
        case KC_1 ... KC_0:
        case KC_EQL:
        case KC_SCLN:
        case KC_MINS:
        case KC_DOT:
        case KC_P1 ... KC_P0:
        case KC_PSLS ... KC_PPLS:
        case KC_PDOT:
        case KC_UNDS:
        case KC_BSPC:
            return false;
        default:
            return record->event.pressed;
    }
}

bool process_record_num_word(uint16_t keycode, const keyrecord_t *record) {
    if (keycode == NUMWORD) {
        if (record->event.pressed) {
            enable_num_word();
            num_word_timer = timer_read();
            return false;
        }

        if (timer_elapsed(num_word_timer) > TAPPING_TERM) {
            disable_num_word();
            return false;
        }
    }

    if (!is_num_word_on || !record->event.pressed) {
        return true;
    }

    switch (keycode) {
        case QK_MOD_TAP ... QK_MOD_TAP_MAX:
        case QK_LAYER_TAP ... QK_LAYER_TAP_MAX:
        case QK_TAP_DANCE ... QK_TAP_DANCE_MAX:
            if (record->tap.count == 0) {
                return true;
            }
            keycode &= 0xFF;
            break;
        default:
            break;
    }

    if (should_terminate_num_word(keycode, record)) {
        disable_num_word();
    }

    return true;
}

static bool s_mous_held = false;
static bool s_mous_mouse_active = false;
static uint16_t s_mous_timer = 0;

static void s_mous_start(void) {
    s_mous_timer = timer_read();
    register_code(KC_LSFT);
    s_mous_held = true;
    s_mous_mouse_active = false;
}

static void s_mous_tap(void) {
    unregister_code(KC_LSFT);
    set_oneshot_mods(MOD_LSFT);
    s_mous_held = false;
}

static void s_mous_hold(void) {
    unregister_code(KC_LSFT);
    layer_on(_MOUSE);
    s_mous_held = false;
    s_mous_mouse_active = true;
}

static void s_mous_stop(void) {
    layer_off(_MOUSE);
    s_mous_mouse_active = false;
}

bool process_s_mous(keyrecord_t *record) {
    if (record->event.pressed) {
        s_mous_start();
    } else if (s_mous_held) {
        s_mous_tap();
    } else if (s_mous_mouse_active) {
        s_mous_stop();
    }

    return false;
}

void matrix_scan_s_mous(void) {
    if (s_mous_held && timer_elapsed(s_mous_timer) > TAPPING_TERM) {
        s_mous_hold();
    }
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
