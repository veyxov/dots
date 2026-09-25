# Imperial44 displays and lighting

The physical left OLED runs Keycat. The physical right OLED shows the active
layer, QMK's rolling WPM estimate, and highlighted Caps Word, Caps Lock, and
Hyper indicators. Placement is independent of which half has the USB cable.

Both OLEDs sleep after ten minutes without keyboard activity and wake when
activity resumes. QMK synchronizes the activity timestamps, WPM, layers,
modifiers, and host LEDs. Caps Word uses a small custom split transaction,
sent on changes with a one-second refresh and rate-limited retries.

The status display writes only when its values change. Keycat updates every
200 ms using the upstream behavior: idle at 0–30 WPM, raised paws at 31–39 WPM,
and alternating taps at 40+ WPM. The renderer does not own display power.

Both RGB LEDs indicate the active layer: dim white for BASE, cyan for CYR,
green for NAV, amber for NUM, and blue for SYM. RGB initialization is independent of OLED
rendering. The hardware data pin is GP28.

## Artwork source

All eight 512-byte bitmap frames are preserved from
[isaacsa51/lily58-keycat](https://github.com/isaacsa51/lily58-keycat/tree/30979bffea752c7422620e19bf4d10ac80660e8a),
whose README credits jordi-7's Lily58 keymap. The frame order and WPM thresholds
are preserved; rendering is separated from Imperial44's sleep/wake policy.

## Build and flash

Build with `qmk compile -kb ergohaven/imperial44 -km veyxov`.
Run the board's `reflash.sh` for each half, moving USB between them.
Both halves must receive the same firmware, especially after split transport
configuration changes.

## macOS input-source sync

The helper source is installed by chezmoi at
`~/.local/bin/qmk-input-source-sync.swift`. Compile it with
`swiftc -O -o ~/.local/bin/qmk-input-source-sync ~/.local/bin/qmk-input-source-sync.swift`.
The LaunchAgent is `~/Library/LaunchAgents/com.shekhovismoil.qmk-input-source-sync.plist`.
Give the compiled binary Input Monitoring access in macOS Privacy & Security,
then load the agent with
`launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.shekhovismoil.qmk-input-source-sync.plist`.
The helper reads the active macOS keyboard input source and sends `SETLANG0`
or `SETLANG1` to keep the firmware base layer aligned. Run
`~/.local/bin/qmk-input-source-sync --status` to check the input source and
keyboard connection, or `--once` to send one synchronization report.
