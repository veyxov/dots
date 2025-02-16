#include QMK_KEYBOARD_H
#ifdef CONSOLE_ENABLE
#include "print.h"
#endif


#define _BASE 0
#define _NAV 1
#define _MOUSE 2

enum custom_keycodes {
    S_MOUS = SAFE_RANGE,
    // other custom keycodes...
};


bool process_record_user(uint16_t keycode, keyrecord_t *record) {
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

    switch (keycode) {
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
        KC_Q,  KC_J,   KC_F,   KC_M,   KC_P,   KC_V,                          XXXXXXX,KC_DOT, KC_SLASH, S(KC_SLSH),  KC_QUOT,   S(KC_MINS),
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
       KC_LALT,  KC_R,   KC_S,   KC_N,   KC_D,   KC_W,                       KC_COMM,   KC_A,   KC_E,   KC_I,   KC_H , QK_REP,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX, KC_X,   KC_G,   KC_L,   KC_C,   KC_B,                       KC_MINS,   KC_U,   KC_O,  KC_Y,  KC_K, KC_RSFT,
    // └───────┴───────┴───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┴───────┴────────┘
                S_MOUS, LT(_NAV, KC_T), XXXXXXX, QK_BOOTLOADER,    XXXXXXX, QK_REP, KC_SPC,   XXXXXXX
    ),
    [_NAV] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX,LGUI(KC_1),LGUI(KC_2),LGUI(KC_3),LGUI(KC_4), XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX,XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX,KC_LEFT,KC_DOWN,KC_UP,  KC_RGHT, XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                XXXXXXX,XXXXXXX,XXXXXXX, XXXXXXX,         XXXXXXX,XXXXXXX,XXXXXXX,XXXXXXX
    ),
    [_MOUSE] = LAYOUT(
    // ┌───────┬───────┬───────┬───────┬───────┬───────┐                     ┌───────┬───────┬───────┬───────┬───────┬────────┐
        MS_ACL0, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX,XXXXXXX,MS_WHLD,MS_WHLU,XXXXXXX, XXXXXXX,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        MS_ACL1,XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 MS_WHLL,MS_LEFT,MS_DOWN,MS_UP,  MS_RGHT, MS_WHLR,
    // ├───────┼───────┼───────┼───────┼───────┼───────┤                     ├───────┼───────┼───────┼───────┼───────┼────────┤
        MS_ACL2, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                 XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    // └───────┴───────┴───────┬───────┬───────┬───────┐                 ┌───────┬─────┴─┬───────┬───────┬────────────────────────┘
                                XXXXXXX,XXXXXXX,XXXXXXX, XXXXXXX,         XXXXXXX,MS_BTN2,MS_BTN1,XXXXXXX
    ),
};


const uint16_t PROGMEM z[] = {KC_U, KC_Y, COMBO_END};
const uint16_t PROGMEM qu[] = {KC_F, KC_M, COMBO_END};
const uint16_t PROGMEM ei_enter[] = {KC_E, KC_I, COMBO_END};
const uint16_t PROGMEM sn_esc[] = {KC_S, KC_N, COMBO_END};
const uint16_t PROGMEM nd_tab[] = {KC_N, KC_D, COMBO_END};
const uint16_t PROGMEM ae_bsp[] = {KC_A, KC_E, COMBO_END};
const uint16_t PROGMEM gl_cpy[] = {KC_G, KC_L, COMBO_END};
const uint16_t PROGMEM lc_pst[] = {KC_L, KC_C, COMBO_END};
const uint16_t PROGMEM glc_all[] = {KC_G, KC_L, KC_C, COMBO_END};
combo_t key_combos[] = {
    COMBO(z, KC_Z),
    COMBO(qu, KC_Q),
    COMBO(ei_enter, KC_ENT),
    COMBO(sn_esc, KC_ESC),
    COMBO(nd_tab, KC_TAB),
    COMBO(ae_bsp, KC_BSPC),
    COMBO(gl_cpy, C(KC_C)),
    COMBO(lc_pst, C(KC_V)),
    COMBO(glc_all, C(KC_A)),
};

const key_override_t delete_key_override = ko_make_basic(MOD_MASK_SHIFT, KC_BSPC, KC_DEL);

// This globally defines all key overrides to be used
const key_override_t *key_overrides[] = {
	&delete_key_override
};
