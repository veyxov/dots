# AGENTS.md

## Scope
- Repository area: `keyboards/ergohaven/imperial44`
- Active keymap: `keymaps/veyxov`
- Hardware: Ergohaven Imperial44, split 44-key board with 3 thumb keys per hand
- MCU / bootloader: RP2040 / `rp2040`

## User Setup
- Primary alpha layout is Hands Down Gold, not QWERTY.
- User switches between English and Russian.
- Cyrillic switching fires `Ctrl+Space` (macOS input-source-switch shortcut) via `CRYLTG`/`SN_ESC_CRYL` in firmware.
- macOS, Aerospace window manager, zsh. Keyboard config is related to local Neovim and Aerospace configs, so check those when changing navigation, symbols, or language toggles.

## Relevant External Configs
- Neovim: `~/.config/nvim`
- Aerospace: `~/.config/aerospace/aerospace.toml`
- Dotfiles repo root: `~/dots`

## Important Keyboard Files
- `keymaps/veyxov/keymap.c`: layer definitions and thin QMK hook wrappers
- `keymaps/veyxov/keymap.h`: key aliases/macros such as layer-taps
- `keymaps/veyxov/features.c` / `features.h`: extracted keymap-local behavior helpers such as language toggle, repeat handling, and raw HID bootloader handling
- `keymaps/veyxov/layers.h`: layer enum
- `keymaps/veyxov/combos.def`: combos
- `keymaps/veyxov/adaptive.h`: adaptive key behavior
- `keymaps/veyxov/config.h`: timing constants
- `keymaps/veyxov/rules.mk`: keymap feature flags
- `keyboard.json`: board build marker and hardware metadata
- `config.h` / `rules.mk`: board-level split / RP2040 settings

## Current Firmware Shape
- Layers present: `BASE`, `NAV`, `NUM`, `CRYL`, `FN`, `SYM`
- Base layer is Hands Down Gold-derived:
  - Left hand alpha block: `J F M P V` / `R S N D W` / `X G L C B`
  - Right hand alpha block: `. / ? ' _` / `, A E I H :` / `- U O Y K`
- Notable behaviors:
  - `OSM(MOD_LSFT)`: tap for one-shot Shift, hold for a normal held Shift (built-in QMK one-shot mod)
  - `REP`: repeat key; with Ctrl held it uses alt-repeat
  - `LTNAV`: tap `T`, hold for nav
  - `CRYLTG`: toggles Cyrillic layer and system language

## Timing / Features
- `TAPPING_TERM 200`
- `COMBO_TERM 20`
- `ADAPTIVE_TERM 200`
- Enabled features in the active keymap include combos, repeat key, and raw HID.

## Build / Flash Workflow
- Bootloader key is present on the base layer as `QK_BOOTLOADER` / `QK_BOOT` (top-right FN key).
- Normal path from this directory:
```bash
./reflash.sh
```
- `reflash.sh` symlinks this repo copy into `~/qmk_firmware/keyboards/ergohaven/imperial44`, tries to trigger the bootloader over Raw HID via `bootloader_rawhid.py`, falls back to "press the physical BOOT/RESET button" if Raw HID is unavailable, then runs `qmk flash -kb ergohaven/imperial44 -km veyxov`, which auto-detects the mounted `RPI-RP2` volume under `/Volumes/` and copies the UF2.
- `RAW_ENABLE = yes` in the active keymap, and `raw_hid_receive()` lives in `features.c`; it recognizes the `BOOTLDR1` command and calls `reset_keyboard()`.
- Bootstrap requirement: the first flash after introducing Raw HID (or after Raw HID gets removed then re-added) needs a manual bootloader entry, because the currently running firmware doesn't yet expose the Raw HID interface.
- For this split keyboard, flash both halves after firmware changes — physically switch the USB-C connection to the other half and re-run `./reflash.sh`.

## Working Notes
- Prefer preserving the existing ergonomic model over introducing standard-QWERTY assumptions.
- Neovim has its own mapping layer.
- When changing symbols, navigation, thumbs, or language keys, also inspect the Neovim and Aerospace bindings for conflicts.
- When changing the keymap, also update the visualization files so they stay truthful.
- Prefer direct layer key definitions over adding `process_record_user()` custom handlers when standard QMK mod-tap, mod-combo, or one-shot-mod keycodes are sufficient (e.g. Shift is stock `OSM(MOD_LSFT)`, not a custom handler).
- User has two monitors only, so monitor focus and move-window actions (`NAV` layer) should use single toggle actions rather than separate previous/next buttons.

## User Preferences
- Uses Neovim
- Uses Aerospace (macOS tiling WM)
- Uses zsh
- Primary language: C#
- Switches frequently between English and Russian (Telegram, etc.)
- Double characters easy via REP key — don't suggest dedicated keys for `//`, `??`, etc.
- Does NOT want Vim commands hardcoded (Neovim handles its own keybindings)
- Does NOT use Rust or C++

## keymap-drawer Visualization
- YAML: `keymaps/veyxov/keymap.yaml`
- Web app: https://keymap-drawer.streamlit.app
- `ergohaven/imperial44` NOT in their QMK DB — use `ortho_layout: {split: true, rows: 3, columns: 6, thumbs: 4}`
- Key order: row-by-row, left+right interleaved per row, thumbs last
- Key spec: `{t: tap, h: hold, s: shifted, type: layer/trans/held/ghost}`
- Combo spec: `{p: [positions], k: key, l: [layers]}` — always set `l:` to avoid showing on all layers

## Files
| File | Purpose |
|------|---------|
| `keymap.c` | Layer definitions and thin hook wrappers |
| `keymap.h` | Macro shorthands (LTNAV, SYM_SPC, F5_ALT) |
| `features.c` / `features.h` | Extracted keymap-local behavior helpers |
| `layers.h` | Layer enum |
| `combos.def` | All combo definitions |
| `adaptive.h` | Adaptive key sequences |
| `config.h` | Timing constants |
| `rules.mk` | Feature flags |
