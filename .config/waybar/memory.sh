# Get memory stats
MEM_INFO=$(free -b)
TOTAL=$(echo "$MEM_INFO" | grep Mem | awk '{print $2}')
USED=$(echo "$MEM_INFO" | grep Mem | awk '{print $3}')

# Calculate percentages
PERCENTAGE=$(awk "BEGIN {printf \"%.0f\", ($USED/$TOTAL)*100}")
USED_GB=$(awk "BEGIN {printf \"%.2f\", $USED/1024/1024/1024}")
TOTAL_GB=$(awk "BEGIN {printf \"%.2f\", $TOTAL/1024/1024/1024}")

# Get top 10 processes by memory usage (skip header, get top 10)
TOP_PROCESSES=$(ps aux --sort=-%mem | awk 'NR>1 && NR<=11 {
    cmd = $11
    for (i=12; i<=NF; i++) {
        if (i == 12 && $i !~ /^-/) continue
        cmd = cmd " " $i
    }
    # Clean up paths: remove /nix/store/hash- and /run/current-system
    gsub(/\/nix\/store\/[^\/]+\//, "", cmd)
    gsub(/\/run\/current-system\//, "", cmd)
    # Extract just the executable name if it is still a long path
    if (match(cmd, /\/[^\/]+$/)) {
        cmd = substr(cmd, RSTART+1)
    }
    # Truncate process name to 35 chars max for consistent width
    proc_name = substr(cmd, 1, 35)
    # Pad process name to fixed width (35 chars) and format percentage
    printf "%-35s %6.1f%%\n", proc_name, $4
}')

# Build tooltip text
TOOLTIP_TEXT="Memory Usage: ${PERCENTAGE}%
Used: ${USED_GB} GiB / ${TOTAL_GB} GiB

Top 10 Processes by Memory:
${TOP_PROCESSES}"

# Escape for JSON (escape backslashes, quotes, and newlines)
TOOLTIP_JSON=$(printf '%s' "$TOOLTIP_TEXT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

# Determine class based on percentage
CLASS=""
if [ "$PERCENTAGE" -ge 90 ]; then
    CLASS="critical"
elif [ "$PERCENTAGE" -ge 80 ]; then
    CLASS="warning"
fi

# Output JSON with icon (U+F9C5 - same as original memory module)
if [ -n "$CLASS" ]; then
    echo "{\"text\": \"${ICON} ${PERCENTAGE}%\", \"tooltip\": \"${TOOLTIP_JSON}\", \"percentage\": ${PERCENTAGE}, \"class\": \"${CLASS}\"}"
else
    echo "{\"text\": \"${ICON} ${PERCENTAGE}%\", \"tooltip\": \"${TOOLTIP_JSON}\", \"percentage\": ${PERCENTAGE}}"
fi

