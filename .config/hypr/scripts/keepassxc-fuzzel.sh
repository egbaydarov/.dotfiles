#!/usr/bin/env bash
set -euo pipefail

DB="$HOME/keepassxc/Passwords.kdbx"
SLOT=1

notify_fdo() {
    local title="$1"
    local body="$2"

    busctl --user call \
      org.freedesktop.Notifications \
      /org/freedesktop/Notifications \
      org.freedesktop.Notifications Notify \
      susssasa{sv}i \
      "twitch-chat" 0 "" "$title" "$body" 0 0 7000 >/dev/null 2>&1 || true
}

# Pick first connected YubiKey
serial=$(ykman list --serials 2>/dev/null | head -n1 || true)
if [ -z "$serial" ]; then
    notify_fdo "KeePassXC" "No YubiKey detected"
    exit 1
fi

YUBI_OPT="${SLOT}:${serial}"

cleanup() {
    MASTERPW=""
    password=""
    unset MASTERPW password 2>/dev/null || true
}
trap cleanup EXIT

# Password prompt
MASTERPW=$(
    fuzzel --dmenu --prompt-only "KeePass password: " --password --cache /dev/null </dev/null 2>/dev/null
)
[ -z "$MASTERPW" ] && exit 0

notify_fdo "KeePassXC" "Touch your YubiKey to unlock"

# Unlock & list entries
entries=$(printf '%s\n' "$MASTERPW" \
    | keepassxc-cli ls -R -f -y "$YUBI_OPT" "$DB" 2>/dev/null \
    | sed -e '/\/$/d' -e '/^Recycle Bin\//d')

if [ -z "$entries" ]; then
    notify_fdo "KeePassXC" "Unlock failed or no entries found"
    exit 1
fi

# Choose entry
choice=$(printf '%s\n' "$entries" \
    | fuzzel --dmenu -w 50 -l 20 --prompt "KeePass entry: " 2>/dev/null)

[ -z "$choice" ] && exit 0

notify_fdo "KeePassXC" "Touch your YubiKey to reveal password"

# Extract password manually
password=$(printf '%s\n' "$MASTERPW" \
    | keepassxc-cli show -s -a password -y "$YUBI_OPT" "$DB" "$choice" 2>/dev/null)

if [ -z "$password" ]; then
    notify_fdo "KeePassXC" "Failed to read password or empty"
    exit 1
fi

printf '%s' "$password" | wl-copy --primary

(sleep 10 && wl-copy --primary --clear) &

notify_fdo "KeePassXC" "Password copied to primary"

