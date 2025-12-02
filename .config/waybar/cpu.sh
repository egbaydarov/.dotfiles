# Get CPU stats by sampling /proc/stat over 1 second
# Read first sample
CPU1=$(grep '^cpu ' /proc/stat | awk '{idle=$5; total=0; for(i=2;i<=NF;i++) total+=$i; print idle" "total}')
sleep 1
# Read second sample
CPU2=$(grep '^cpu ' /proc/stat | awk '{idle=$5; total=0; for(i=2;i<=NF;i++) total+=$i; print idle" "total}')

# Calculate difference
IDLE1=$(echo $CPU1 | awk '{print $1}')
TOTAL1=$(echo $CPU1 | awk '{print $2}')
IDLE2=$(echo $CPU2 | awk '{print $1}')
TOTAL2=$(echo $CPU2 | awk '{print $2}')

IDLE=$((IDLE2 - IDLE1))
TOTAL=$((TOTAL2 - TOTAL1))

# Calculate percentage
if [ "$TOTAL" -gt 0 ]; then
    PERCENTAGE=$(awk "BEGIN {printf \"%.0f\", (1 - $IDLE/$TOTAL) * 100}")
else
    PERCENTAGE=0
fi

# Get top 10 processes by CPU usage (skip header, get top 10)
TOP_PROCESSES=$(ps aux --sort=-%cpu | awk 'NR>1 && NR<=11 {
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
    printf "%-35s %6.1f%%\n", proc_name, $3
}')

# Get CPU info
CPU_MODEL=$(lscpu | grep "Model name" | cut -d: -f2 | sed 's/^[ \t]*//' | head -c 50)
CPU_CORES=$(nproc)

# Build tooltip text
TOOLTIP_TEXT="CPU Usage: ${PERCENTAGE}%
CPU: ${CPU_MODEL}
Cores: ${CPU_CORES}

Top 10 Processes by CPU:
${TOP_PROCESSES}"

# Escape for JSON (escape backslashes, quotes, and newlines)
TOOLTIP_JSON=$(printf '%s' "$TOOLTIP_TEXT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

# Determine class based on percentage
CLASS=""
if [ "$PERCENTAGE" -ge 95 ]; then
    CLASS="critical"
elif [ "$PERCENTAGE" -ge 80 ]; then
    CLASS="warning"
fi

# Output JSON with icon
if [ -n "$CLASS" ]; then
    echo "{\"text\": \"${PERCENTAGE}%\", \"tooltip\": \"${TOOLTIP_JSON}\", \"percentage\": ${PERCENTAGE}, \"class\": \"${CLASS}\"}"
else
    echo "{\"text\": \"${PERCENTAGE}%\", \"tooltip\": \"${TOOLTIP_JSON}\", \"percentage\": ${PERCENTAGE}}"
fi

