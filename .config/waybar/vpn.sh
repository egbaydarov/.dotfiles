#!/usr/bin/env bash

# Usage:
#   vpn.sh <index>
#   vpn.sh <index> --toggle
#
# Username auto-detected

INDEX="$1"
ACTION="$2"

# Retrieve username running Waybar
USER_NAME="$(whoami)"

# Decide mapping based on username
UNIT=""

case "$USER_NAME" in
  boogie)
    # OpenVPN mapping
    case "$INDEX" in
      0) UNIT="openvpn-whVPN.service" ;;
      1) UNIT="openvpn-iVPN.service" ;;
      2) UNIT="openvpn-pVPN.service" ;;
      *) ;;
    esac
    ;;
  byda)
    # WireGuard mapping
    case "$INDEX" in
      0) UNIT="wg-quick-wgru" ;;
      1) UNIT="wg-quick-wgvisi" ;;
      2) UNIT="wg-quick-wgokolo" ;;
      *) ;;
    esac
    ;;
  *)
    echo '{"text": "", "class": "vpn-unknown"}'
    exit 1
    ;;
esac

# No matching unit?
if [ -z "$UNIT" ]; then
  echo '{"text": "", "class": "vpn-unknown"}'
  exit 1
fi

# Toggle mode
if [ "$ACTION" = "--toggle" ]; then
  if systemctl is-active --quiet "$UNIT"; then
    systemctl stop "$UNIT"
  else
    systemctl start "$UNIT"
  fi
  exit 0
fi

# Status mode
if systemctl is-active --quiet "$UNIT"; then
  echo '{"text": "", "class": "on"}'
else
  echo '{"text": "", "class": "off"}'
fi

