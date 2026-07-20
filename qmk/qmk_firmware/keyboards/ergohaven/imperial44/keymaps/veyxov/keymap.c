#include QMK_KEYBOARD_H

#include "keymap.h"
#include "features.h"
#include "g/keymap_combo.h"
#include "adaptive.h"

// Only the arrow-thumb mod-taps resolve hold on the next keypress (needed for
// fast rolls like Alt+M). Everything else — especially LTNAV, since T is a
// layer-tap on a very common letter — keeps waiting out TAPPING_TERM so fast
// typing isn't misread as a layer hold.
bool get_hold_on_other_key_press(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case MT(MOD_LALT, KC_RGHT):
        case MT(MOD_LCTL, KC_LEFT):
            return true;
        default:
            return false;
    }
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case QK_MOD_TAP ... QK_MOD_TAP_MAX:
        case QK_LAYER_TAP ... QK_LAYER_TAP_MAX:
            if (record->tap.count == 0) // If not tapped yet,
                return true;            // let QMK handle it first.
            // A tap of LTNAV during an active repeat sequence sends plain T
            // directly (bypassing repeat bookkeeping), so T after REP can't
            // disturb the sequence. Must run before the keycode is trimmed —
            // features.c would only ever see KC_T.
            if (keycode == LTNAV && get_repeat_key_count() > 0) {
                if (record->event.pressed) tap_code(KC_T);
                return false;
            }
            keycode &= QK_BASIC_MAX;    // Trim mods + taps.
            break;
    }

    // Adaptive keys are for plain typing on the base layer only — on other
    // layers transparent positions resolve to the same base keycodes and
    // would misfire pairs (e.g. F+M on NAV).
    if (get_highest_layer(layer_state) == _BASE) {
        if (!process_adaptive_user(keycode, record)) {
            return false; // We have declared no more processing.
        }
    }

    return process_record_features(keycode, record);
}

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_BASE] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        OSL(_NUM),  KC_J,   KC_F,   KC_M,   KC_P,   KC_V,                     KC_X, KC_DOT, KC_SLSH, S(KC_SLSH),  KC_QUOT,   S(KC_MINS),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        KC_DEL,  KC_R,   KC_S,   KC_N,   KC_D,   KC_W,                        KC_COMM,   KC_A,   KC_E,   KC_I, KC_H,  S(KC_SCLN),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        LT(_FN, KC_LGUI), KC_X,   KC_G,   KC_L,   KC_C,   KC_B,                        KC_MINS,   KC_U,   KC_O,  KC_Y,  KC_K,   CRYLTG,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                REP, LTNAV, OSM(MOD_LSFT),  KC_TAB,                    OS_LOCK,   MT(MOD_LCTL, KC_LEFT), SYM_SPC, MT(MOD_LALT, KC_RGHT)
    ),

    [_NAV] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______, _______, A(KC_F), _______, A(KC_P), A(KC_V),                 _______,A(KC_1),A(KC_2),A(KC_3),A(KC_4), _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______,G(S(KC_S)), KC_LALT, KC_LSFT, KC_LCTL, KC_LGUI,                 KC_HOME,KC_LEFT,KC_DOWN,KC_UP,KC_RGHT, KC_END,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______, G(S(KC_G)), A(KC_N), C(KC_Z), C(S(KC_Z)),                 _______, A(KC_C), G(KC_SPC), A(KC_K), MON_TOG, MON_MOV,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                _______, _______,_______, _______,         _______, G(S(KC_S)),G(S(KC_SPC)),G(S(KC_C))
    ),

    [_NUM] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______, _______, _______, _______, _______, _______,                 _______,_______,S(KC_EQL),_______,_______, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______,KC_6, KC_4, KC_0, KC_2, _______,                                _______,KC_3,KC_1,KC_5,  KC_7, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______, _______, _______, KC_8, _______,                 _______, KC_9, _______, _______, _______, _______,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                _______,KC_BSPC,_______, _______,         _______,_______, KC_SPC,_______
    ),
    [_CRYL] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______,  _______,   _______,   _______,   _______,   _______,                      _______, _______, _______, _______, _______, _______,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
       _______,  _______,   _______,   _______,   _______,   _______,                       _______,   _______,   _______,   _______,   _______, A(KC_D),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        _______, _______,   _______,   _______,   _______,   _______,                       _______,   _______,   _______,  _______,  _______,   _______,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                KC_2, _______, _______, KC_3,    _______, KC_LEFT, _______,   OSM(MOD_RALT)
    ),

    [_FN] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        _______,  _______,   _______,   _______,   _______,   _______,                      _______, _______, _______, _______, _______, QK_BOOT,
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

void matrix_scan_user(void) {
    matrix_adaptive_user();
}

bool remember_last_key_user(uint16_t keycode, keyrecord_t* record,
                            uint8_t* remembered_mods) {
  return remember_last_key_features(keycode);
}
