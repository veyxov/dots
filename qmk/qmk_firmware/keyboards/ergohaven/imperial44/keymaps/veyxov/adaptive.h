static uint8_t  prior_saved_mods = 0;
static uint16_t prior_keycode    = KC_NO;
static uint32_t prior_keydown    = 0;

bool process_adaptive_user(uint16_t keycode, const keyrecord_t *record) {
    bool return_state = true;

    if (record->event.pressed) {
        uint8_t saved_mods = get_mods();
        if (saved_mods & MOD_MASK_CAG) {
            // Don't do anything if mods are present.
            return true;
        }
        uint16_t second     = KC_NO;
        bool     pair_fired = false;
        if (timer_elapsed32(prior_keydown) < ADAPTIVE_TERM) {
            uint16_t first = KC_NO;
            clear_mods();

            switch (prior_keycode) {
                case KC_F: // FM -> FL
                    switch (keycode) {
                        case KC_M:
                            return_state = false;
                            second       = KC_L;
                            break;
                        case KC_P: // FP -> {
                            return_state = false;
                            second       = S(KC_LBRC);
                            break;
                    }
                    break;
                case KC_V: // VM -> VL
                    switch (keycode) {
                        case KC_M:
                            return_state = false;
                            second       = KC_L;
                            break;
                    }
                    break;
                case KC_M: // MV -> MB
                    switch (keycode) {
                        case KC_V:
                            return_state = false;
                            second       = KC_B;
                            break;
                    }
                    break;
                case KC_P:
                    switch (keycode) {
                        case KC_V: // PV -> LV
                            return_state = false;
                            first        = KC_L;
                            second       = KC_V;
                            break;
                        case KC_M: // PM -> PL
                            return_state = false;
                            first        = KC_P;
                            second       = KC_L;
                            break;
                        default:
                            // Replay the gobbled P with the mods it was
                            // pressed with (Shift+P must stay "P").
                            set_mods(prior_saved_mods);
                            tap_code(prior_keycode);
                            break;
                    }
                    break;
                case KC_L: // LC -> LP
                    switch (keycode) {
                        case KC_C:
                            return_state = false;
                            second       = KC_P;
                            break;
                        case KC_L: // LL -> LM
                            return_state = false;
                            second       = KC_M;
                            break;
                    }
                    break;
                case KC_G: // GX -> GS
                    switch (keycode) {
                        case KC_X:
                            return_state = false;
                            second       = KC_S;
                            break;
                        case KC_G: // GG -> GF
                            return_state = false;
                            second = KC_F;
                            break;
                    }
                    break;
                case KC_U: // UH -> UA
                    switch (keycode) {
                        case KC_H:
                            return_state = false;
                            second       = KC_A;
                            break;
                    }
                    break;
                case KC_A:
                    switch (keycode) {
                        case KC_H: // AH -> AU
                            return_state = false;
                            second = KC_U;
                            break;
                    }
                    break;

                case KC_O:
                    switch (keycode) {
                        case KC_H: // OH -> OE
                            return_state = false;
                            second = KC_E;
                            break;
                    }
                    break;
                case KC_D:
                    switch (keycode) {
                        case KC_D: // DD -> DC
                            return_state = false;
                            second = KC_C;
                            break;
                    }
                    break;
                case KC_E:
                    switch (keycode) {
                        case KC_H: // EH -> EO
                            return_state = false;
                            second = KC_O;
                            break;
                    }
                    break;
            }

            pair_fired = !return_state;
            if (return_state) {
                set_mods(saved_mods);
            } else {
                set_mods(prior_saved_mods);
                if (first) {
                    tap_code16(first);
                }
                // The rewritten key follows the current shift state, and
                // 16-bit codes like S(KC_LBRC) need tap_code16 (tap_code
                // truncates { down to [).
                set_mods(saved_mods);
                tap_code16(second);
            }
        }
        switch (keycode) {
            // If pressed, gobble these keys until
            // `ADAPTIVE_TERM` (handled in `matrix_adaptive_user`)
            // or another keypress (handled in `case`s above).
            // A P consumed by a pair above was already emitted — don't
            // re-buffer it.
            case KC_P:
                if (!pair_fired) return_state = false;
                break;
        }
        prior_saved_mods = saved_mods;
        // After a rewrite the effective last key is what was emitted, not
        // what was pressed (same semantics as the kanata port, which reads
        // output history).
        prior_keycode    = pair_fired ? (second & QK_BASIC_MAX) : keycode;
        prior_keydown    = timer_read32();
    }
    return return_state;
}
void matrix_adaptive_user(void) {
    if (timer_elapsed32(prior_keydown) >= ADAPTIVE_TERM) {
        switch (prior_keycode) {
            // If `ADAPTIVE_TERM` has elapsed,
            // with no other key presses
            case KC_P:
                set_mods(prior_saved_mods);
                tap_code(prior_keycode);
                clear_mods();
                break;
        }
        prior_keydown = timer_read32();
        prior_keycode = KC_NO;
    }
}
