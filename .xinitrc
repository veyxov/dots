# the compositor (blur, animations)
picom -b --config $HOME/.config/picom.conf

# Increase key speed via a rate change
xset r rate 300 55
# Map the caps lock key to super
setxkbmap -option caps:super

# Set keyboard to eng and rus (phonetic)
setxkbmap -layout us,ru -variant ,phonetic -option grp:alt_shift_toggle
# Set the bar to show the date
xsetroot -name "$(date "+%A %e %B %Y")"

# Run the desktop
exec dwm
