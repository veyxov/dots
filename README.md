# dots

Dotfiles for macOS and Linux, managed with [chezmoi](https://chezmoi.io).

## Layout

- `mac/` — current macOS setup:
  - `home/` — chezmoi source state (`.chezmoiroot` points here). Targets `~`:
    `dot_config/` → `~/.config/`, plus `dot_zshenv`, `Library/`, etc.
  - `Brewfile` — Homebrew packages and casks (`brew bundle`).
  - `macos/launchdaemons/` — LaunchDaemon plists for kanata and the
    Karabiner VirtualHIDDevice daemon (install instructions in each plist).
  - `macos/defaults.sh` — Finder/Dock/trackpad/keyboard/screenshot defaults,
    not applied automatically; run manually with `./mac/macos/defaults.sh`.
- `linux/` — Arch Linux (stow-era) configs: hyprland, fish, mako, etc.
- `install.sh` — bootstrap: clone the repo, point chezmoi at it, `chezmoi apply`.
- `qmk/` — QMK keyboard firmware/layout.
- `bin/`, `sony/` — personal utility scripts.

## Usage

```sh
./install.sh          # first-time bootstrap
brew bundle --file mac/Brewfile
chezmoi apply         # re-apply after edits
chezmoi diff          # preview changes
```

Edit files in `mac/home/` directly (the repo is the chezmoi source dir), then
`chezmoi apply`.
