#include QMK_KEYBOARD_H
#include "display.h"
#include "layers.h"

#define DISPLAY_IDLE_TIMEOUT_MS 600000UL

#ifdef OLED_ENABLE
#include "caps_word.h"
#include "keycat.h"
#include "transactions.h"

static bool remote_caps_word;

static void receive_caps_word(uint8_t in_size, const void *in_data, uint8_t out_size, void *out_data) {
    (void)out_size;
    (void)out_data;
    if (in_size == sizeof(remote_caps_word)) {
        memcpy(&remote_caps_word, in_data, sizeof(remote_caps_word));
    }
}
#endif

#ifdef RGBLIGHT_ENABLE
#include "rgblight.h"

#define HSV_BASE 30, 0, 25
#define HSV_NAV 85, 255, 120
#define HSV_NUM 32, 255, 120
#define HSV_SYM 170, 255, 120

static const rgblight_segment_t PROGMEM base_layer[] = RGBLIGHT_LAYER_SEGMENTS({0, RGBLIGHT_LED_COUNT, HSV_BASE});
static const rgblight_segment_t PROGMEM nav_layer[] = RGBLIGHT_LAYER_SEGMENTS({0, RGBLIGHT_LED_COUNT, HSV_NAV});
static const rgblight_segment_t PROGMEM num_layer[] = RGBLIGHT_LAYER_SEGMENTS({0, RGBLIGHT_LED_COUNT, HSV_NUM});
static const rgblight_segment_t PROGMEM sym_layer[] = RGBLIGHT_LAYER_SEGMENTS({0, RGBLIGHT_LED_COUNT, HSV_SYM});
static const rgblight_segment_t *const PROGMEM lighting_layers[] =
    RGBLIGHT_LAYERS_LIST(base_layer, nav_layer, num_layer, sym_layer);
#endif

void display_init(void) {
#ifdef OLED_ENABLE
    transaction_register_rpc(RPC_SYNC_CAPS_WORD, receive_caps_word);
#endif
#ifdef RGBLIGHT_ENABLE
    rgblight_layers = lighting_layers;
    rgblight_enable_noeeprom();
    rgblight_mode_noeeprom(RGBLIGHT_MODE_STATIC_LIGHT);
    display_layer_state_set(layer_state);
#endif
}

void display_layer_state_set(layer_state_t state) {
#ifdef RGBLIGHT_ENABLE
    const uint8_t layer = get_highest_layer(state);
    rgblight_set_layer_state(0, layer == _BASE);
    rgblight_set_layer_state(1, layer == _NAV);
    rgblight_set_layer_state(2, layer == _NUM);
    rgblight_set_layer_state(3, layer == _SYM);
#else
    (void)state;
#endif
}

// Caps Word is not included in QMK's built-in modifier synchronization.
void display_sync(void) {
#ifdef OLED_ENABLE
    static uint32_t last_attempt;
    static uint32_t last_success;
    static bool last_sent;
    if (!is_keyboard_master() || timer_elapsed32(last_attempt) < 50) {
        return;
    }
    const bool active = is_caps_word_on();
    if (active == last_sent && timer_elapsed32(last_success) < 1000) {
        return;
    }
    last_attempt = timer_read32();
    if (transaction_rpc_send(RPC_SYNC_CAPS_WORD, sizeof(active), &active)) {
        last_sent = active;
        last_success = last_attempt;
    }
#endif
}

#ifdef OLED_ENABLE
typedef struct {
    uint8_t layer;
    uint8_t wpm;
    bool caps_word;
    bool caps_lock;
    bool hyper;
} display_status_t;

static void render_layer_name(uint8_t layer) {
    switch (layer) {
    case _NAV:
        oled_write_P(PSTR("NAV"), false);
        break;
    case _NUM:
        oled_write_P(PSTR("NUM"), false);
        break;
    case _SYM:
        oled_write_P(PSTR("SYM"), false);
        break;
    default:
        oled_write_P(PSTR("BASE"), false);
        break;
    }
}

static void render_status(void) {
    static bool drawn;
    static display_status_t previous;
    const uint8_t mods = get_mods() | get_weak_mods() | get_oneshot_mods();
    const display_status_t current = {
        .layer = get_highest_layer(layer_state | default_layer_state),
        .wpm = get_current_wpm(),
        .caps_word = is_keyboard_master() ? is_caps_word_on() : remote_caps_word,
        .caps_lock = host_keyboard_led_state().caps_lock,
        .hyper = (mods & MOD_MASK_CTRL) && (mods & MOD_MASK_SHIFT) && (mods & MOD_MASK_ALT) && (mods & MOD_MASK_GUI),
    };
    if (drawn && current.layer == previous.layer && current.wpm == previous.wpm &&
        current.caps_word == previous.caps_word && current.caps_lock == previous.caps_lock &&
        current.hyper == previous.hyper) {
        return;
    }
    previous = current;
    drawn = true;

    // Overwrite complete rows; avoid clearing and dirtying an unchanged buffer.
    oled_set_cursor(0, 0);
    oled_write_P(PSTR("LAYER: "), false);
    render_layer_name(current.layer);
    oled_write_ln_P(PSTR(""), false);
    oled_write_P(PSTR("WPM:   "), false);
    char wpm_text[] = {
        '0' + current.wpm / 100,
        '0' + current.wpm / 10 % 10,
        '0' + current.wpm % 10,
        '\0',
    };
    oled_write_ln(wpm_text, false);
    oled_write_P(PSTR("CW "), current.caps_word);
    oled_write_P(PSTR("CAPS "), current.caps_lock);
    oled_write_ln_P(PSTR("HYPER"), current.hyper);
}

oled_rotation_t display_oled_init(oled_rotation_t rotation) {
    return is_keyboard_left() ? OLED_ROTATION_180 : rotation;
}

bool display_oled_task(void) {
    // QMK synchronizes this timestamp to the offhand, including modifier keys.
    // Both displays share one policy; animation and WPM never determine wakeup.
    if (last_input_activity_elapsed() >= DISPLAY_IDLE_TIMEOUT_MS) {
        oled_off();
        return false;
    }
    oled_on();
    if (is_keyboard_left()) {
        keycat_render();
    } else {
        render_status();
    }
    return false;
}
#endif
