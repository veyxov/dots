#include QMK_KEYBOARD_H
#include <string.h>

#include "raw_hid.h"
#include "keymap.h"
#include "os_detection.h"

#define BOOTLOADER_MAGIC "BOOTLDR1"
#define RAW_HID_REPORT_SIZE 32

// Linux (Hyprland kb_options=grp:shifts_toggle) switches input source on a
// both-shifts tap; macOS's input-source-switch shortcut is Ctrl+Space
// instead, so a plain both-shifts tap is a no-op there and the firmware's
// _CRYL layer desyncs from the OS's actual active layout.
static void toggle_lg(void) {
    os_variant_t os = detected_host_os();
    if (os == OS_WINDOWS || os == OS_LINUX) {
        register_code(KC_LSFT);
        register_code(KC_RSFT);
        unregister_code(KC_LSFT);
        unregister_code(KC_RSFT);
    } else {
        register_code(KC_LCTL);
        tap_code(KC_SPC);
        unregister_code(KC_LCTL);
    }
}

static void cryl_off(void) {
    toggle_lg();
    layer_off(_CRYL);
}

// Word-delete: Ctrl+Backspace on Windows/Linux, Option+Backspace on macOS
// (Ctrl+Backspace is a no-op there).
static void tap_word_bspc(void) {
    os_variant_t os = detected_host_os();
    uint8_t mod = (os == OS_WINDOWS || os == OS_LINUX) ? MOD_BIT(KC_LCTL) : MOD_BIT(KC_LALT);
    register_mods(mod);
    tap_code(KC_BSPC);
    unregister_mods(mod);
}

// Windows/Linux use Ctrl for copy/paste/select-all, macOS uses Cmd.
// OS detection is best-effort and known to misdetect behind hubs/docks
// (see QMK os_detection docs), so an unsure/misdetected result falls back
// to Cmd rather than Ctrl, since macOS is the primary machine.
static void tap_os_mod(uint16_t kc) {
    os_variant_t os = detected_host_os();
    uint8_t mod = (os == OS_WINDOWS || os == OS_LINUX) ? MOD_BIT(KC_LCTL) : MOD_BIT(KC_LGUI);
    register_mods(mod);
    tap_code(kc);
    unregister_mods(mod);
}

static bool s_mous_held = false;
static bool s_mous_mouse_active = false;
static bool s_mous_interrupted = false;
static uint16_t s_mous_timer = 0;

static void s_mous_start(void) {
    s_mous_timer = timer_read();
    register_code(KC_LSFT);
    s_mous_held = true;
    s_mous_mouse_active = false;
    s_mous_interrupted = false;
}

static void s_mous_tap(void) {
    unregister_code(KC_LSFT);
    // If another key was pressed while S_MOUS was held, the physical shift
    // already applied to it; setting a one-shot here would leak an extra
    // shift onto the next key.
    if (!s_mous_interrupted) {
        set_oneshot_mods(MOD_LSFT);
    }
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

static bool process_s_mous(keyrecord_t *record) {
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

// Must run for EVERY key event, before adaptive/combo/mod-tap dispatch can
// swallow a key. A key pressed while S_MOUS is held means we're rolling into a
// held-shift, not tapping for a one-shot, so the one-shot must be suppressed.
void s_mous_note_interrupt(uint16_t keycode, keyrecord_t *record) {
    if (s_mous_held && record->event.pressed && keycode != S_MOUS) {
        s_mous_interrupted = true;
    }
}

bool process_record_features(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
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
        case CRYLTG:
            // Enable-only: turning Russian OFF is Esc's job (SN_ESC_CRYL),
            // so a repeated press can't blind-toggle the OS out of sync.
            if (record->event.pressed && get_highest_layer(layer_state) != _CRYL) {
                toggle_lg();
                layer_on(_CRYL);
            }
            return false;
        case SN_ESC_CRYL:
            // Esc disables Russian when it's on; plain Esc otherwise.
            if (record->event.pressed) {
                if (get_highest_layer(layer_state) == _CRYL) {
                    cryl_off();
                } else {
                    tap_code(KC_ESC);
                }
            }
            return false;
        case CG_WBSPC:
            if (record->event.pressed) tap_word_bspc();
            return false;
        case S_MOUS:
            return process_s_mous(record);
        case CG_COPY:
            if (record->event.pressed) tap_os_mod(KC_C);
            return false;
        case CG_PASTE:
            if (record->event.pressed) tap_os_mod(KC_V);
            return false;
        case CG_SELALL:
            if (record->event.pressed) tap_os_mod(KC_A);
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
