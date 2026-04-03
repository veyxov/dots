#include QMK_KEYBOARD_H

enum {
    TD_Z_SCLN = 0
};

// Tap Dance definitions
tap_dance_action_t tap_dance_actions[] = {
    [TD_Z_SCLN] = ACTION_TAP_DANCE_DOUBLE(KC_Z, S(KC_SCLN))
};

#include "keymap.h"
#include "features.h"
#include "g/keymap_combo.h"
#include "adaptive.h"


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

    if (!process_record_num_word(keycode, record)) {
        return false;
    }

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
            return process_s_mous(record);
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
                                _______, _______,_______, _______,         _______, _______,G(KC_X),_______
    ),

    [_MOUSE] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______, _______, _______,_______, _______, _______,                      _______, _______, KC_WH_D, KC_WH_U, _______, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______,  _______,   _______,  _______,   _______,                     KC_WH_L, KC_MS_L, KC_MS_D, KC_MS_U, KC_MS_R, KC_WH_R,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______, _______, _______, _______, _______,                  _______, _______, _______, _______, _______, _______,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                _______,_______,_______, _______,         MS_BTN3, MS_BTN2, MS_BTN1, _______
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

    if (leader_sequence_one_key(QK_LEAD)) {
        // send F24, this is to toggle between workspaces in hyprland
        tap_code(KC_F24);
    }
}

void matrix_scan_user(void) {
    matrix_adaptive_user();
    matrix_scan_s_mous();
}

bool remember_last_key_user(uint16_t keycode, keyrecord_t* record,
                            uint8_t* remembered_mods) {
  // In remember_last_key_user(), we ignore the LT_REP key. Otherwise, pressing it will "remember" itself as the last key just before it is handled, in which case repeating the last key will do nothing.
  if (keycode == REP) { return false; }
  return true;
}
