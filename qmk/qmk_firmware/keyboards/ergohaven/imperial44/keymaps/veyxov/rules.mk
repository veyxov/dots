SRC += features.c

LTO_ENABLE = yes

# features in use
RAW_ENABLE = yes
OS_DETECTION_ENABLE = yes
MOUSEKEY_ENABLE = yes
EXTRAKEY_ENABLE = yes
COMBO_ENABLE = yes
DYNAMIC_MACRO_ENABLE = yes
REPEAT_KEY_ENABLE = yes
VPATH += keyboards/gboards

# disable unused defaults
BOOTMAGIC_ENABLE = no
GRAVE_ESC_ENABLE = no
SPACE_CADET_ENABLE = no
MAGIC_ENABLE = no
