#include QMK_KEYBOARD_H
#include <string.h>

enum custom_keycodes {
    S_MOUS = SAFE_RANGE,
    NUMWORD,
    CRYLTG,
    REP,
    SN_ESC_CRYL,
};

enum {
    TD_Z_SCLN = 0
};

// Tap Dance definitions
tap_dance_action_t tap_dance_actions[] = {
    [TD_Z_SCLN] = ACTION_TAP_DANCE_DOUBLE(KC_Z, S(KC_SCLN))
};

#include "keymap.h"
#ifdef CONSOLE_ENABLE
#include "print.h"
#endif
#include "raw_hid.h"
#include "g/keymap_combo.h"
#include "adaptive.h"

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
    if (is_num_word_on) return;
    is_num_word_on = true;
    layer_on(_NUM);
}
void disable_num_word(void) {
    if (!is_num_word_on) return;
    is_num_word_on = false;
    layer_off(_NUM);
}
bool should_terminate_num_word(uint16_t keycode, const keyrecord_t *record) {
    switch (keycode) {
        // Keycodes which should not disable num word mode.
        // We could probably be more brief with these definitions by using
        // a couple more ranges, but I believe "explicit is better than
        // implicit"
        case KC_1 ... KC_0:
        case KC_EQL:
        case KC_SCLN:
        case KC_MINS:
        case KC_DOT:

        // Numpad keycodes
        case KC_P1 ... KC_P0:
        case KC_PSLS ... KC_PPLS:
        case KC_PDOT:

        // Misc
        case KC_UNDS:
        case KC_BSPC:
            return false;

        default:
            if (record->event.pressed) {
                return true;
            }
            return false;
    }

}
bool process_record_num_word(uint16_t keycode, const keyrecord_t *record) {
    // Handle the custom keycodes that go with this feature
    if (keycode == NUMWORD) {
        if (record->event.pressed) {
            enable_num_word();
            num_word_timer = timer_read();
            return false;
        }
        else {
            if (timer_elapsed(num_word_timer) > TAPPING_TERM) {
                // If the user held the key longer than TAPPING_TERM,
                // consider it a hold, and disable the behavior on
                // key release.
                disable_num_word();
                return false;
            }
        }
    }

    // Other than the custom keycodes, nothing else in this feature will
    // activate if the behavior is not on, so allow QMK to handle the
    // event as usual
    if (!is_num_word_on) return true;

    // Nothing else acts on key release, either
    if (!record->event.pressed) {
        return true;
    }

    // Get the base keycode of a mod or layer tap key
    switch (keycode) {
        case QK_MOD_TAP ... QK_MOD_TAP_MAX:
        case QK_LAYER_TAP ... QK_LAYER_TAP_MAX:
        case QK_TAP_DANCE ... QK_TAP_DANCE_MAX:
            // Earlier return if this has not been considered tapped yet
            if (record->tap.count == 0)
                return true;
            keycode = keycode & 0xFF;
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
static uint16_t s_mous_timer = 0;


bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case QK_MOD_TAP ... QK_MOD_TAP_MAX:
        case QK_LAYER_TAP ... QK_LAYER_TAP_MAX:
            if (record->tap.count == 0) // If not tapped yet,
                return true;            // let QMK handle it first.
            keycode &= QK_BASIC_MAX;    // Trim mods + taps.
            break;
    }

    // no adaptive keys on the cyrillic layer
    if (get_highest_layer(layer_state) != _CRYL) {
        if (!process_adaptive_user(keycode, record)) {
            return false; // We have declared no more processing.
        }
    }

    #ifdef CONSOLE_ENABLE
        const bool is_combo = record->event.type == COMBO_EVENT;
        uprintf("0x%04X,%u,%u,%u,%b,0x%02X,0x%02X,%u\n",
             keycode,
             is_combo ? 254 : record->event.key.row,
             is_combo ? 254 : record->event.key.col,
             get_highest_layer(layer_state),
             record->event.pressed,
             get_mods(),
             get_oneshot_mods(),
             record->tap.count
             );
    #endif

    process_record_num_word(keycode, record);

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
            if (record->event.pressed) {
                toggle_lg();
                if (get_highest_layer(layer_state) == _CRYL) layer_off(_CRYL);
                else                                         layer_on (_CRYL);
            }
            return false;
        case SN_ESC_CRYL:
            if (record->event.pressed) {
                if (get_highest_layer(layer_state) == _CRYL) {
                    toggle_lg();
                    layer_off(_CRYL);
                } else {
                    tap_code(KC_ESC);
                }
            }
            return false;
        // remove the lag after repeating KC_T
        case LTNAV:
            if (get_repeat_key_count() > 0) {
                if (record->event.pressed) {
                    // send directly KC_T, don't trigger tap-dance
                    tap_code(KC_T);
                }
            } else {
                // do nothing, (tap dance)
                return true;
            }
            return false;
        case S_MOUS:
            if (record->event.pressed) {
                if (layer_state_is(_MOUSE)) {
                    // Already in mouse layer: toggle it off
                    layer_off(_MOUSE);
                } else {
                    s_mous_timer = timer_read();
                    register_code(KC_LSFT);
                    s_mous_held = true;
                }
            } else {
                if (s_mous_held) {
                    // Released before threshold: one-shot shift
                    unregister_code(KC_LSFT);
                    set_oneshot_mods(MOD_LSFT);
                    s_mous_held = false;
                }
                // If s_mous_held is false, matrix_scan already activated
                // the layer and unregistered shift — layer stays on
            }
            return false;
    }

    return true;
}

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_BASE] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        OSL(_NUM),  KC_J,   KC_F,   KC_M,   KC_P,   KC_V,                     QK_LEAD,KC_DOT, KC_SLSH, S(KC_SLSH),  KC_QUOT,   S(KC_MINS),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        KC_DEL,  KC_R,   KC_S,   KC_N,   KC_D,   KC_W,                        KC_COMM,   KC_A,   KC_E,   KC_I, KC_H,  S(KC_SCLN),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        LT(_FN, KC_LGUI), KC_X,   KC_G,   KC_L,   KC_C,   KC_B,                        KC_MINS,   KC_U,   KC_O,  KC_Y,  KC_K,   CRYLTG,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                S_MOUS, LTNAV, REP,  KC_TAB,                            LGUI(KC_L),   MT(MOD_LCTL, KC_LEFT), SYM_SPC, MT(MOD_LALT, KC_RGHT)
    ),

    [_NAV] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______, _______, G(KC_F), _______, G(KC_P), G(KC_V),                 _______,G(KC_1),G(KC_2),G(KC_3),G(KC_4), _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______,G(KC_S), KC_LALT, KC_LSFT, KC_LCTL, KC_LGUI,                 KC_HOME,KC_LEFT,KC_DOWN,KC_UP,KC_RGHT, KC_END,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______, _______, G(KC_N), C(KC_Z), C(S(KC_Z)),                 _______, G(KC_C), G(KC_R), G(KC_K), MON_TOG, MON_MOV,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                _______, _______,_______, _______,         _______,SELLINE,G(KC_X),SELWORD
    ),

    [_MOUSE] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______, _______, _______,_______, _______, _______,                      _______,OM_HLDS,OM_D, OM_RELS, OM_W_U, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______,  _______,   _______,  _______,   _______,                     _______,OM_L, OM_U, OM_R, OM_W_D, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______, _______, _______, _______, _______,                  _______, OM_SEL1, OM_SEL2, OM_SEL3, _______, _______,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                _______,_______,_______, _______,         _______,OM_DBLS,OM_BTNS,OM_SLOW
    ),

    [_NUM] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______, _______, _______, _______, _______, _______,                 _______,_______,S(KC_EQL),_______,_______, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______,KC_6, KC_4, KC_0, KC_2, _______,                                _______,KC_3,KC_1,KC_5,  KC_7, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______, _______, _______, KC_8, _______,                 _______, KC_9, _______, _______, _______, _______,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                _______,KC_BSPC,_______, _______,         _______,MS_BTN1, KC_SPC,MS_BTN2
    ),
    [_CRYL] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______,  _______,   _______,   _______,   _______,   _______,                      _______, _______, _______, _______, _______, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
       _______,  _______,   _______,   _______,   _______,   _______,                       _______,   _______,   _______,   _______,   _______, TD(TD_Z_SCLN),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______,   _______,   _______,   _______,   _______,                       _______,   _______,   _______,  _______,  _______,   KC_NO,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                _______, _______, KC_2, KC_3,    _______, KC_LEFT, _______,   OSM(MOD_RALT)
    ),

    [_FN] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______,  DM_REC1,   DM_RSTP,   DM_PLY1,   _______,   _______,                      _______, _______, _______, _______, _______, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
       _______,  _______,   _______,   _______,   _______,   _______,                         KC_MUTE, KC_VOLD, _______,  _______,  KC_VOLU , _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______,   _______,   _______,   _______,   _______,                       _______,   KC_MPRV, KC_MPLY,  KC_MNXT,  _______,   _______,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                _______, _______, _______, _______,                     _______, _______, _______,   _______
    ),

    [_SYM] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______,  KC_QUOT,   S(KC_COMM),   S(KC_DOT), S(KC_QUOT),              _______, KC_DOT,   S(KC_7), KC_RBRC, KC_LBRC, S(KC_5), _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
       _______,  S(KC_1),   KC_MINS,   S(KC_EQL),   KC_EQL,   S(KC_3),         KC_0, KC_SCLN, S(KC_0),  S(KC_9),  S(KC_4), _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, S(KC_6),    KC_SLSH,S(KC_2),   KC_BSLS,   _______,           S(KC_GRV),   S(KC_8), S(KC_RBRC),  S(KC_LBRC),  S(KC_2),   _______,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                KC_BSPC, KC_SPC, KC_ENTER, _______,    _______, _______, _______,   _______
    ),
};


const custom_shift_key_t custom_shift_keys[] = {
    {KC_DOT, S(KC_GRV)}, // . -> ~
    {KC_SLSH, S(KC_7)}, // / -> &
    {S(KC_SLSH), S(KC_1)}, // ? -> !
    {KC_COMM, S(KC_BSLS)}, // , -> |
    {S(KC_MINS), KC_GRV}, // _ -> `
    {KC_MINS, S(KC_EQL)}, // - -> +
    {S(KC_SCLN), KC_SCLN}, // : -> ;
};

void leader_end_user(void) {
    if (leader_sequence_one_key(KC_N)) {
        // activate the numword
        enable_num_word();
    }
}

void matrix_scan_user(void) {
    matrix_adaptive_user();
    // S_MOUS: switch from shift to mouse layer once hold threshold is reached
    if (s_mous_held && timer_elapsed(s_mous_timer) > TAPPING_TERM) {
        unregister_code(KC_LSFT);
        layer_on(_MOUSE);
        s_mous_held = false;
    }
}

bool remember_last_key_user(uint16_t keycode, keyrecord_t* record,
                            uint8_t* remembered_mods) {
  // In remember_last_key_user(), we ignore the LT_REP key. Otherwise, pressing it will "remember" itself as the last key just before it is handled, in which case repeating the last key will do nothing.
  if (keycode == REP) { return false; }
  return true;
}

uint16_t get_alt_repeat_key_keycode_user(uint16_t keycode, uint8_t mods) {
   switch (keycode) {
    case SELWBAK: return SELWORD;
    case SELWORD: return SELWBAK;
    // ...
  }
  return KC_TRNS; 
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

#ifdef OLED_ENABLE
oled_rotation_t oled_init_user(oled_rotation_t rotation) {
    if (!is_keyboard_master()) {
        return OLED_ROTATION_180;
    }

    return rotation;
}

bool oled_task_user(void) {
    oled_clear();

    if (is_keyboard_master()) {
        oled_write_ln_P(PSTR("I44 veyxov"), false);
        oled_write_ln_P(PSTR("MASTER"), false);
    } else {
        oled_write_ln_P(PSTR("I44 veyxov"), false);
        oled_write_ln_P(PSTR("OFFHAND"), false);
    }

    oled_write_P(PSTR("Layer: "), false);

    switch (get_highest_layer(layer_state)) {
        case _BASE:
            oled_write_ln_P(PSTR("BASE"), false);
            break;
        case _NAV:
            oled_write_ln_P(PSTR("NAV"), false);
            break;
        case _MOUSE:
            oled_write_ln_P(PSTR("MOUSE"), false);
            break;
        case _NUM:
            oled_write_ln_P(PSTR("NUM"), false);
            break;
        case _CRYL:
            oled_write_ln_P(PSTR("CRYL"), false);
            break;
        case _FN:
            oled_write_ln_P(PSTR("FN"), false);
            break;
        case _SYM:
            oled_write_ln_P(PSTR("SYM"), false);
            break;
        default:
            oled_write_ln_P(PSTR("?"), false);
            break;
    }

    return false;
}
#endif
