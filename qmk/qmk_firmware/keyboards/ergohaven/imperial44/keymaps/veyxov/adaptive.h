// Track last key and timestamp
static uint16_t last_key = KC_NO;
static uint32_t last_time = 0;
#define ADAPTIVE_TIMEOUT 200  // ideally only trigger adaptiveness on rolls

bool process_adaptive_key(uint16_t keycode, const keyrecord_t *record) {
    if (record->event.pressed) {
        switch (keycode) {
            case LorM:  // Adaptive key pressed
                if (last_key != KC_NO && timer_elapsed(last_time) < ADAPTIVE_TIMEOUT) {
                    // KC_M becomes KC_L after KC_F and KC_P
                    // usage: play, fly
                    // 'fm' and 'pm' are rare biagrams
                    if (last_key == KC_F || last_key == KC_P) {
                        tap_code(KC_L);
                    } else {
                        tap_code(KC_M);
                    }
                } else {
                    tap_code(KC_M);
                }
                return false;
            case LorV:  // Adaptive key pressed
                if (last_key != KC_NO && timer_elapsed(last_time) < ADAPTIVE_TIMEOUT) {
                    // 'pv' becomes 'lv'
                    if (last_key == KC_P) {
                        tap_code(KC_BSPC);
                        tap_code(KC_L);
                        tap_code(KC_V);
                    } else if (last_key == LorM) {
                        // mv yields mb
                        tap_code(KC_B);
                    } else {
                        tap_code(KC_V);
                    }
                } else {
                    tap_code(KC_V);
                }
                return false;
            default:
                break;
        }
    }
    return true;
}
