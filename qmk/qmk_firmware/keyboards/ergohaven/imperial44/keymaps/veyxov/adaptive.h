static uint8_t  prior_saved_mods = 0;
static uint16_t prior_keycode    = KC_NO;
static uint32_t prior_keydown    = 0;

// Pair rewrites: typing `prior` then `key` within ADAPTIVE_TERM emits
// `first` (if set) followed by `second` instead of the literal pair.
typedef struct {
    uint16_t prior, key, first, second;
} adaptive_pair_t;

static const adaptive_pair_t adaptive_pairs[] = {
    {KC_F, KC_M, KC_NO, KC_L},          // FM -> FL
    {KC_F, KC_P, KC_NO, S(KC_LBRC)},    // FP -> {
    {KC_V, KC_M, KC_NO, KC_L},          // VM -> VL
    {KC_M, KC_V, KC_NO, KC_B},          // MV -> MB
    {KC_P, KC_V, KC_L, KC_V},           // PV -> LV
    {KC_P, KC_M, KC_P, KC_L},           // PM -> PL
    {KC_L, KC_C, KC_NO, KC_P},          // LC -> LP
    {KC_L, KC_L, KC_NO, KC_M},          // LL -> LM
    {KC_G, KC_X, KC_NO, KC_S},          // GX -> GS
    {KC_G, KC_G, KC_NO, KC_F},          // GG -> GF
    {KC_U, KC_H, KC_NO, KC_A},          // UH -> UA
    {KC_A, KC_H, KC_NO, KC_U},          // AH -> AU
    {KC_O, KC_H, KC_NO, KC_E},          // OH -> OE
    {KC_D, KC_D, KC_NO, KC_C},          // DD -> DC
    {KC_E, KC_H, KC_NO, KC_O},          // EH -> EO
};

bool process_adaptive_user(uint16_t keycode, const keyrecord_t *record) {
    bool return_state = true;

    if (record->event.pressed) {
        uint8_t saved_mods = get_mods();
        if (saved_mods & MOD_MASK_CAG) {
            // Don't do anything if mods are present.
            return true;
        }
        const adaptive_pair_t *match = NULL;
        if (timer_elapsed32(prior_keydown) < ADAPTIVE_TERM) {
            clear_mods();

            for (uint8_t i = 0; i < ARRAY_SIZE(adaptive_pairs); i++) {
                if (adaptive_pairs[i].prior == prior_keycode && adaptive_pairs[i].key == keycode) {
                    match = &adaptive_pairs[i];
                    break;
                }
            }

            if (match) {
                return_state = false;
            } else if (prior_keycode == KC_P) {
                // Replay the gobbled P with the mods it was pressed with
                // (Shift+P must stay "P").
                set_mods(prior_saved_mods);
                tap_code(prior_keycode);
            }

            if (return_state) {
                set_mods(saved_mods);
            } else {
                set_mods(prior_saved_mods);
                if (match->first) {
                    tap_code16(match->first);
                }
                // The rewritten key follows the current shift state, and
                // 16-bit codes like S(KC_LBRC) need tap_code16 (tap_code
                // truncates { down to [).
                set_mods(saved_mods);
                tap_code16(match->second);
            }
        }
        // Gobble P until `ADAPTIVE_TERM` (handled in `matrix_adaptive_user`)
        // or another keypress (handled in the pair cases above). A P consumed
        // by a pair above was already emitted — don't re-buffer it.
        if (keycode == KC_P && !match) {
            return_state = false;
        }
        prior_saved_mods = saved_mods;
        // After a rewrite the effective last key is what was emitted, not
        // what was pressed (same semantics as the kanata port, which reads
        // output history).
        prior_keycode    = match ? (match->second & QK_BASIC_MAX) : keycode;
        prior_keydown    = timer_read32();
    }
    return return_state;
}
void matrix_adaptive_user(void) {
    if (timer_elapsed32(prior_keydown) >= ADAPTIVE_TERM) {
        // `ADAPTIVE_TERM` elapsed with no other key press — flush gobbled P.
        if (prior_keycode == KC_P) {
            set_mods(prior_saved_mods);
            tap_code(prior_keycode);
            clear_mods();
        }
        prior_keydown = timer_read32();
        prior_keycode = KC_NO;
    }
}
