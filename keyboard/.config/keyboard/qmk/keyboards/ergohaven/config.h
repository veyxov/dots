#ifndef DYNAMIC_KEYMAP_LAYER_COUNT
#define DYNAMIC_KEYMAP_LAYER_COUNT 16
#endif

#ifndef DYNAMIC_KEYMAP_MACRO_COUNT
#define DYNAMIC_KEYMAP_MACRO_COUNT 109
#endif

#define RP2040_BOOTLOADER_DOUBLE_TAP_RESET              // Activates the double-tap behavior
#define RP2040_BOOTLOADER_DOUBLE_TAP_RESET_TIMEOUT 200U // Timeout window in ms in which the double tap can occur.
#define RP2040_BOOTLOADER_DOUBLE_TAP_RESET_LED_MASK 0U  // Specify a optional status led which blinks when entering the bootloader

#define BOTH_SHIFTS_TURNS_ON_CAPS_WORD
#define UNICODE_SELECTED_MODES UNICODE_MODE_LINUX, UNICODE_MODE_MACOS, UNICODE_MODE_WINCOMPOSE, UNICODE_MODE_WINDOWS

#define DEBOUNCE 10
#define USB_SUSPEND_WAKEUP_DELAY 2000 // wait for USB hub to start

#define WEAR_LEVELING_BACKING_SIZE 16384 // increase EEPROM size

#define EH_TIMEOUT (10 * 60 * 1000) // 10 minutes

#ifdef CONSOLE_ENABLE
#    undef NO_DEBUG
#endif
