#pragma once

/* Serial settings */
#define SERIAL_USART_FULL_DUPLEX
#define SERIAL_USART_TX_PIN GP0
#define SERIAL_USART_RX_PIN GP1
#define SPLIT_HAND_PIN      GP29
#define SPLIT_LAYER_STATE_ENABLE
#define SPLIT_WPM_ENABLE
#define SPLIT_WATCHDOG_ENABLE

#ifdef OLED_ENABLE
#    define OLED_DISPLAY_128X32
#    define I2C1_SCL_PIN GP3
#    define I2C1_SDA_PIN GP2
#    define OLED_BRIGHTNESS 128
#    define I2C_DRIVER I2CD1
#    define SPLIT_MODS_ENABLE
#    define SPLIT_ACTIVITY_ENABLE
#    define SPLIT_LED_STATE_ENABLE
// Both halves apply the same timeout using synchronized activity timestamps.
#    define OLED_TIMEOUT 0
#endif

/* split protocol settings */
#define SELECT_SOFT_SERIAL_SPEED 1
#define SPLIT_TRANSACTION_IDS_USER RPC_SYNC_CONFIG, RPC_SYNC_HID, RPC_SYNC_CAPS_WORD

#define RGBLIGHT_LED_COUNT 2
#define RGBLED_SPLIT {1, 1}
#define RGBLIGHT_SLEEP
#define RGBLIGHT_SPLIT
#define RGBLIGHT_LAYERS
#define RGBLIGHT_MAX_LAYERS 4
#define RGBLIGHT_DEFAULT_VAL 100
#define RGBLIGHT_LIMIT_VAL 255
#define RGBLIGHT_VAL_STEP 15
#define RGBLIGHT_DEFAULT_SAT 0

#define TAP_CODE_DELAY 1

#define EH_SHORT_PRODUCT_NAME "I44"
