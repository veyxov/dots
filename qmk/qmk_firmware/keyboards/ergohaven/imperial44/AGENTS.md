# AGENTS.md

## Scope
- Repository area: `keyboards/ergohaven/imperial44`
- Active keymap: `keymaps/veyxov`
- Hardware: Ergohaven Imperial44, split 44-key board with 3 thumb keys per hand
- MCU / bootloader: RP2040 / `rp2040`

## User Setup
- Primary alpha layout is Hands Down Gold, not QWERTY.
- User switches between English and Russian.
- Cyrillic switching is tied to system layout switching via Shift+Shift in firmware (`toggle_lg()`).
- Keyboard config is related to local Neovim and Hyprland configs, so check those when changing navigation, symbols, leader flows, or language toggles.

## Relevant External Configs
- Neovim: `~/.config/nvim`
- Hyprland: `~/.config/hypr/hyprland.conf`
- Dotfiles repo root: `~/dots`

## Important Keyboard Files
- `keymaps/veyxov/keymap.c`: layer definitions and thin QMK hook wrappers
- `keymaps/veyxov/keymap.h`: key aliases/macros such as layer-taps
- `keymaps/veyxov/features.c` / `features.h`: extracted keymap-local behavior helpers such as num-word, `S_MOUS`, language toggle, repeat handling, leader actions, and raw HID bootloader handling
- `keymaps/veyxov/layers.h`: layer enum
- `keymaps/veyxov/combos.def`: combos
- `keymaps/veyxov/adaptive.h`: adaptive key behavior
- `keymaps/veyxov/config.h`: timing constants
- `keymaps/veyxov/rules.mk`: keymap feature flags
- `keyboard.json`: board build marker and hardware metadata
- `config.h` / `rules.mk`: board-level split / RP2040 settings

## Current Firmware Shape
- Layers present: `BASE`, `NAV`, `MOUSE`, `NUM`, `CRYL`, `FN`, `SYM`
- Base layer is Hands Down Gold-derived:
  - Left hand alpha block: `J F M P V` / `R S N D W` / `X G L C B`
  - Right hand alpha block: `. / ? ' _` / `, A E I H :` / `- U O Y K`
- Notable behaviors:
  - `S_MOUS`: tap for one-shot Shift, hold past `TAPPING_TERM` for a momentary mouse layer, release to turn mouse off
  - `REP`: repeat key; with Ctrl held it uses alt-repeat
  - `LTNAV`: tap `T`, hold for nav
  - `CRYLTG`: toggles Cyrillic layer and system language
  - `NUMWORD`: supported through leader sequence

## Timing / Features
- `TAPPING_TERM 200`
- `COMBO_TERM 20`
- `ADAPTIVE_TERM 200`
- Enabled features in the active keymap include combos, dynamic macros, repeat key, leader, mouse keys, raw HID, and bootmagic.

## Build / Flash Workflow
- User’s normal workflow from this directory:
```bash
nd qmk && sleep 2 ; qmk compile && sudo mount /dev/sda1 /mnt && sudo cp -v .build/ergohaven_imperial44_veyxov.uf2 /mnt && sudo umount /mnt && sleep 5 && echo "done"
```
- The final `sleep 5` exists because flashing takes about 3-5 seconds.
- Bootloader key is present on the base layer as `QK_BOOTLOADER`.
- Preferred automated path for future agent runs:
```bash
./reflash.sh
```
- After upstream QMK changes, this board needs a `keyboard.json` build marker. `reflash.sh` exposes this external keyboard to `/home/iz/qmk_firmware` by ensuring the `ergohaven` path points back to this repo copy, then builds with `make ergohaven/imperial44:veyxov`.
- `reflash.sh` then tries to trigger bootloader over Raw HID with `bootloader_rawhid.py`, waits for the `RPI-RP2` drive, and copies the UF2 manually.
- QMK 0.32.x may place the fresh UF2 either in `qmk_firmware/<target>.uf2` or `qmk_firmware/.build/<target>.uf2`; `reflash.sh` must accept either, but only if the file is newer than the current build start time.
- `reflash.sh` must verify that a fresh UF2 was produced before flashing so it cannot deploy a stale build artifact after a failed compile.
- `RAW_ENABLE = yes` in the active keymap, and `raw_hid_receive()` lives in `features.c`; it recognizes the `BOOTLDR1` command and calls `reset_keyboard()`.
- Bootstrap requirement: the first flash after introducing Raw HID still needs a manual bootloader entry, because the currently running firmware does not yet expose the Raw HID interface.
- For this split keyboard, flash both halves after firmware changes. It uses one shared UF2 and `SPLIT_HAND_PIN` for handedness, but split communication and user RPC state still need matching firmware on both sides; mixed versions can make the offhand appear dead until it is reflashed too.

## Working Notes
- Prefer preserving the existing ergonomic model over introducing standard-QWERTY assumptions.
- Neovim has its own mapping layer.
- When changing symbols, navigation, thumbs, or language keys, also inspect the Neovim and Hyprland bindings for conflicts.
- When changing the keymap, also update the visualization files so they stay truthful.
- Prefer direct layer key definitions over adding `process_record_user()` custom handlers when standard QMK mod-tap or mod-combo keycodes are sufficient.
- For monitor actions on this setup, prefer ergonomic single-tap actions from the `NAV` layer over awkward Hyprland punctuation chords.
- User has two monitors only, so monitor focus and move-window actions should use single toggle actions rather than separate previous/next buttons.

## User Preferences
- Uses Neovim (QMK leader ≠ Neovim leader — they are independent)
- Uses Hyprland
- Uses Fish shell
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
