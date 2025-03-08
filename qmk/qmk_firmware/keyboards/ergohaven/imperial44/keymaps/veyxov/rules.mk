NO_USB_STARTUP_CHECK = no
OLED_ENABLE = no
AUTO_SHIFT_ENABLE = no
COMMAND_ENABLE = no
AUTOCORRECT_ENABLE = no
ENCODER_ENABLE = no
ENCODER_MAP_ENABLE = no
WPM_ENABLE = no
RAW_ENABLE = no
UNICODE_COMMON = no
UNICODE_ENABLE = no

CAPS_WORD_ENABLE = yes
CONSOLE_ENABLE = yes
LEADER_ENABLE = yes
NKRO_ENABLE = yes
BOOTMAGIC_ENABLE = yes

SRC += features/orbital_mouse.c
MOUSE_ENABLE = yes

EXTRAKEY_ENABLE = yes
LTO_ENABLE = yes
TAP_DANCE_ENABLE = no

COMBO_ENABLE = yes
VPATH += keyboards/gboards

KEY_OVERRIDE_ENABLE = yes
DYNAMIC_MACRO_ENABLE = yes
REPEAT_KEY_ENABLE = yes


DEBOUNCE_TYPE = sym_eager_pk
