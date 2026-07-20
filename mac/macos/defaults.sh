#!/bin/sh
# macOS system defaults. Idempotent, safe to re-run.
# Not applied automatically by chezmoi — run manually: ./macos/defaults.sh
set -e

# Finder
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # search current folder
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 40
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock wvous-br-corner -int 13 # bottom-right: lock screen
defaults write com.apple.dock wvous-br-modifier -int 0

# Trackpad
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -bool true

# Keyboard: fast repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Snappiness: cut animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1
defaults write com.apple.dock launchanim -bool false

# Spotlight: stop indexing the heavy firmware checkout, cuts mdworker background load
touch "${HOME}/dots/qmk/qmk_firmware/.metadata_never_index"

# Menu bar
defaults write com.apple.controlcenter BatteryShowPercentage -bool true
defaults write com.apple.Spotlight MenuItemHidden -bool true # Raycast owns launcher duties now

killall Finder Dock SystemUIServer 2>/dev/null || true

echo "Done. Some changes (trackpad, keyboard repeat) may need logout/restart to fully apply."
