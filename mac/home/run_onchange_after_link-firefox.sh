#!/bin/bash
# Symlink the managed Firefox files into the default profile; the folder name differs per machine.
set -e
ff="$HOME/Library/Application Support/Firefox"
rel=$(awk -F= '/^\[Install/{i=1} i&&/^Default=/{print $2; exit}' "$ff/profiles.ini")
profile="$ff/$rel"
[ -d "$profile" ] || { echo "firefox profile not found: $profile" >&2; exit 1; }
mkdir -p "$profile/chrome"
ln -sf "$HOME/.config/firefox/userChrome.css" "$profile/chrome/userChrome.css"
ln -sf "$HOME/.config/firefox/user.js" "$profile/user.js"
