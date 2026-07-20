#!/bin/bash

# Directory containing wallpapers (including subdirectories)
WALLS_DIR="$HOME/.local/walls"

# Hyprpaper configuration file
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"

# Find all image files recursively and select one randomly
WALLPAPER=$(find "$WALLS_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | shuf -n 1)

# Exit if no wallpapers found
if [[ -z "$WALLPAPER" ]]; then
    echo "Error: No wallpapers found in $WALLS_DIR"
    exit 1
fi

# Ensure the config directory exists
mkdir -p "$(dirname "$CONFIG_FILE")"

# Write the hyprpaper configuration
echo "preload = $WALLPAPER" > "$CONFIG_FILE"
echo "wallpaper = ,$WALLPAPER" >> "$CONFIG_FILE"

# Restart hyprpaper to apply the new wallpaper
pkill hyprpaper
hyprpaper &
