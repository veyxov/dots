#include QMK_KEYBOARD_H

enum custom_keycodes {
    S_MOUS = SAFE_RANGE,
    NUMWORD,
    CRYLTG,
    REP
};

#include "keymap.h"
#include "print.h"
#include "g/keymap_combo.h"
#include "adaptive.h"

void toggle_lg(void) {
    register_code(KC_LSFT);
    register_code(KC_RSFT);
    unregister_code(KC_LSFT);
    unregister_code(KC_RSFT);
}

uint16_t get_tapping_term(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        default:
            return TAPPING_TERM;
    }
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

    // Should be unreachable
    return false;
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

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
        case QK_MOD_TAP ... QK_MOD_TAP_MAX:
        case QK_LAYER_TAP ... QK_LAYER_TAP_MAX:
            if (record->tap.count == 0) // If not tapped yet,
                return true;            // let QMK handle it first.
            keycode &= QK_BASIC_MAX;    // Trim mods + taps.
            break;
    }

    // no adaptive keys on the cryllic layer
    if (get_highest_layer(layer_state) != _CRYL) {
        if (!process_adaptive_user(keycode, record)) {
            return false; // We have declared no more processing.
        }
    }

    static bool shift_triggered = false;
    static uint16_t shift_timer = 0;

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
            // if the lgui modifier is active
            if (get_mods() & MOD_MASK_CTRL) {
                // type the alternate
                uint8_t temp_mods = get_mods();
                // remove the gui mod, because it's the trigger
                del_mods(MOD_MASK_CTRL);
                alt_repeat_key_invoke(&record->event);
                set_mods(temp_mods);
                return false;
            } else {
                repeat_key_invoke(&record->event);
                return false;
            }
        case CRYLTG:
            if (record->event.pressed) {
                toggle_lg();
                if (get_highest_layer(layer_state) == _CRYL) layer_off(_CRYL);
                else                                         layer_on (_CRYL);
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
                shift_timer = timer_read();
                register_code(KC_LSFT);
                shift_triggered = true;
            } else {
                if (shift_triggered && (timer_elapsed(shift_timer) < TAPPING_TERM)) {
                    // If released quickly, trigger one-shot shift
                    unregister_code(KC_LSFT);
                    set_oneshot_mods(MOD_LSFT);
                } else {
                    // If it was held, disable the mouse layer
                    unregister_code(KC_LSFT);
                    layer_off(_MOUSE);
                }
                shift_triggered = false;
            }
            return false;
    }

    // Add this outside the switch statement
    if (shift_triggered && timer_elapsed(shift_timer) > TAPPING_TERM) {
        unregister_code(KC_LSFT);  // Unregister shift before enabling mouse layer
        layer_on(_MOUSE);
        shift_triggered = false;
    }

    return true;
}

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    [_BASE] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        XXXXXXX,  KC_J,   KC_F,   KC_M,   KC_P,   KC_V,                          XXXXXXX,KC_DOT, KC_SLSH, S(KC_SLSH),  KC_QUOT,   S(KC_MINS),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        F5_ALT,  KC_R,   KC_S,   KC_N,   KC_D,   KC_W,                        KC_COMM,   KC_A,   KC_E,   KC_I, KC_H,  REP,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        LT(_FN, KC_LGUI), KC_X,   KC_G,   KC_L,   KC_C,   KC_B,                        KC_MINS,   KC_U,   KC_O,  KC_Y,  KC_K,   CRYLTG,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                REP, LTNAV, MT(MOD_LGUI, KC_RGHT),  QK_BOOTLOADER,      LGUI(KC_L),   MT(MOD_LCTL, KC_LEFT), KC_SPC,    S_MOUS
    ),

    [_NAV] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX,LGUI(KC_1),LGUI(KC_2),LGUI(KC_3),LGUI(KC_4), XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX,XXXXXXX, KC_LALT, KC_LSFT, KC_LCTL, XXXXXXX,                 KC_HOME,KC_LEFT,KC_DOWN,KC_UP,  KC_RGHT, KC_END,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                XXXXXXX, LTNAV,XXXXXXX, XXXXXXX,         XXXXXXX,XXXXXXX,KC_DEL,XXXXXXX
    ),
    [_MOUSE] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        MS_ACL0, XXXXXXX, MS_WHLU,MS_WHLD, XXXXXXX, XXXXXXX,                 XXXXXXX,XXXXXXX,XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        MS_WHLL,MS_LEFT,MS_DOWN,MS_UP,  MS_RGHT, MS_WHLR,                     XXXXXXX,XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        MS_ACL2, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                XXXXXXX,MS_BTN1,MS_BTN2, XXXXXXX,         XXXXXXX,XXXXXXX,XXXXXXX,XXXXXXX
    ),
    [_NUM] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        MS_ACL0, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX,XXXXXXX,MS_WHLD,MS_WHLU,XXXXXXX, XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        MS_ACL1,KC_6, KC_4, KC_0, KC_2, XXXXXXX,                                MS_WHLL,KC_3,KC_1,KC_5,  KC_7, MS_WHLR,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        MS_ACL2, XXXXXXX, XXXXXXX, XXXXXXX, KC_8, XXXXXXX,                 XXXXXXX, KC_9, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                XXXXXXX,XXXXXXX,XXXXXXX, XXXXXXX,         XXXXXXX,KC_SPC,MS_BTN1,XXXXXXX
    ),
    [_CRYL] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        XXXXXXX,  KC_J,   KC_F,   KC_M,   KC_P,   KC_V,                      XXXXXXX, KC_DOT, KC_SLSH, S(KC_SLSH), KC_QUOT, S(KC_MINS),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
       F5_ALT,  KC_R,   KC_S,   KC_N,   KC_D,   KC_W,                       KC_COMM,   KC_A,   KC_E,   KC_I,   KC_H , KC_Z,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX, KC_X,   KC_G,   KC_L,   KC_C,   KC_B,                       KC_MINS,   KC_U,   KC_O,  KC_Y,  KC_K,   CRYLTG,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                S_MOUS, LTNAV, KC_LGUI, QK_BOOTLOADER,    XXXXXXX, KC_LCTL, KC_SPC,   XXXXXXX
    ),
    [_FN] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        XXXXXXX,  DM_REC1,   DM_RSTP,   DM_PLY1,   KC_P,   KC_V,                      XXXXXXX, KC_DOT, KC_SLSH, S(KC_9), KC_QUOT, S(KC_MINS),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
       XXXXXXX,  XXXXXXX,   KC_S,   KC_N,   KC_D,   KC_W,                         KC_MUTE, KC_VOLD, KC_E,  KC_I,  KC_VOLU , KC_Z,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX, KC_X,   KC_G,   KC_L,   KC_C,   KC_B,                       KC_MINS,   KC_MPRV, KC_MPLY,  KC_MNXT,  KC_K,   CRYLTG,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                S_MOUS, LTNAV, KC_LGUI, QK_BOOTLOADER,    XXXXXXX, KC_LCTL, KC_SPC,   XXXXXXX
    ),
};


const key_override_t ovr_dot = ko_make_basic(MOD_MASK_SHIFT, KC_DOT, S(KC_GRV));
const key_override_t ovr_slsh = ko_make_basic(MOD_MASK_SHIFT, KC_SLSH, S(KC_7));
const key_override_t ovr_qst = ko_make_basic(MOD_MASK_SHIFT, S(KC_SLSH), S(KC_1));
const key_override_t ovr_comm = ko_make_basic(MOD_MASK_SHIFT, KC_COMM, S(KC_BSLS));
const key_override_t ovr_undr = ko_make_basic(MOD_MASK_SHIFT, S(KC_MINS), KC_GRV);
const key_override_t ovr_mins = ko_make_basic(MOD_MASK_SHIFT, KC_MINS, S(KC_EQL));

const key_override_t *key_overrides[] = {
	&ovr_dot,
    &ovr_slsh,
    &ovr_qst,
    &ovr_comm,
    &ovr_undr
};

void leader_end_user(void) {
    if (leader_sequence_one_key(KC_N)) {
        // activate the numword
        enable_num_word();
    }
}

// combos
#ifdef COMBO_TERM_PER_COMBO
    uint16_t get_combo_term(uint16_t index, combo_t *combo) {
        switch (combo->keycode) {
            case S(KC_LBRC):
                return 25;
        }
        return 15;
    }
#endif

bool process_combo_keycode_user(uint16_t keycode, keyrecord_t *record) {
    switch (keycode) {
    }
    return true;
}
// combo end

// matrix can
void matrix_scan_user(void) {
    matrix_adaptive_user();
}

bool remember_last_key_user(uint16_t keycode, keyrecord_t* record,
                            uint8_t* remembered_mods) {
    // In remember_last_key_user(), we ignore the LT_REP key. Otherwise, pressing it will "remember" itself as the last key just before it is handled, in which case repeating the last key will do nothing.
  if (keycode == REP) { return false; }
  return true;
}
