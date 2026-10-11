#!/bin/sh
# Installs the pinned Karabiner DriverKit driver and the kanata LaunchDaemons.
# Idempotent; run manually: ./mac/macos/install-kanata.sh (asks for sudo).
# Pinned to 6.2.0: kanata 1.12 can't talk to the 8.x daemon (different socket
# layout). Bump only together with kanata >= 1.13 (VirtualHIDDevice v8 support).
set -e

VERSION=6.2.0
SHA256=9e8c46239f0748161241e42444857901224e5c82f5b58a1731df4c70bf0736a8
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DAEMONS=/Library/LaunchDaemons
VHID=org.pqrs.Karabiner-VirtualHIDDevice-Daemon
APP_DIR="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice"

installed=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' \
  "$APP_DIR/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/Info.plist" 2>/dev/null || true)

if [ "$installed" != "$VERSION" ]; then
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT
  pkg="Karabiner-DriverKit-VirtualHIDDevice-$VERSION.pkg"
  curl -fsSL -o "$tmp/$pkg" \
    "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v$VERSION/$pkg"
  echo "$SHA256  $tmp/$pkg" | shasum -a 256 -c -
  pkgutil --check-signature "$tmp/$pkg" | grep -q 'Developer ID Installer: Fumihiko Takayama (G43BCU2T37)'
  sudo launchctl bootout "system/$VHID" 2>/dev/null || true
  sudo installer -pkg "$tmp/$pkg" -target /
fi

for label in "$VHID" dev.kanata.kanata; do
  sudo install -m 644 -o root -g wheel "$SCRIPT_DIR/launchdaemons/$label.plist" "$DAEMONS/$label.plist"
  sudo launchctl bootout "system/$label" 2>/dev/null || true
  sudo launchctl bootstrap system "$DAEMONS/$label.plist"
  sleep 2
done
