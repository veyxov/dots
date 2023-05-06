sudo ~/kanata/target/release/kanata -c ~/.config/keyboard/hands.kbd &

telegram-desktop &
firefox &
dunst &
wl-paste -t text --watch clipman store &
wl-paste -p -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json" &
setwall &
