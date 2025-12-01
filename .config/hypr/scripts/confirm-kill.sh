# Get active window info as JSON
win_json=$(hyprctl -j activewindow 2>/dev/null) || exit 0
[ -z "$win_json" ] && exit 0

title=$(printf '%s\n' "$win_json" | jq -r '.title // .initialTitle // "unknown"')
class=$(printf '%s\n' "$win_json" | jq -r '.class // .initialClass // "unknown"')
floating=$(printf '%s\n' "$win_json" | jq -r '.floating')

# If the window is floating -> just kill it, no prompt
if [ "$floating" = "true" ]; then
    hyprctl dispatch killactive
    exit 0
fi

# Truncate long titles for the prompt
maxlen=50
if [ "${#title}" -gt "$maxlen" ]; then
    short_title="${title:0:maxlen}…"
else
    short_title="$class"
fi

# Ask for confirmation with window title in the prompt
choice=$(printf "Yes\nNo" | fuzzel -w 25 -l 2 -x 15 --dmenu --prompt "Kill: $short_title ?                                    ")

if [ "$choice" = "Yes" ]; then
    hyprctl dispatch killactive
fi

