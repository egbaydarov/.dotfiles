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

# Get VPN name/label based on index and username
VPN_TEXT=""
case "$USER_NAME" in
  boogie)
    case "$INDEX" in
      0) VPN_TEXT="w" ;;
      1) VPN_TEXT="i" ;;
      2) VPN_TEXT="p" ;;
      *) VPN_TEXT="" ;;
    esac
    ;;
  byda)
    case "$INDEX" in
      0) VPN_TEXT=" ru " ;;
      1) VPN_TEXT=" visi " ;;
      2) VPN_TEXT=" okolo " ;;
      *) VPN_TEXT="" ;;
    esac
    ;;
  *)
    VPN_TEXT=""
    ;;
esac

# Status mode
if systemctl is-active --quiet "$UNIT"; then
  echo "{\"text\": \"${VPN_TEXT}\", \"class\": \"on\"}"
else
  echo "{\"text\": \"${VPN_TEXT}\", \"class\": \"off\"}"
fi

