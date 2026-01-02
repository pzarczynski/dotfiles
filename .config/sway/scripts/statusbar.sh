#!/bin/sh

# ---------------- Battery ----------------
cap=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)
case $cap in
    9[0-9]|100) bat_icon="󰁹" ;;
    8[0-9]) bat_icon="󰂂" ;;
    [6-7][0-9]) bat_icon="󰂀" ;;
    5[0-9]) bat_icon="󰁿" ;;
    4[0-9]) bat_icon="󰁽" ;;
    3[0-9]) bat_icon="󰁼" ;;
    2[0-9]) bat_icon="󰁻" ;;
    1[0-9]) bat_icon="󰁺" ;;
    *) bat_icon="󰂎" ;;
esac
[ "$status" = "Charging" ] && bat_icon="󰂄"
bat_mode=$(~/.config/sway/scripts/auto-battery-mode.sh)
[ "$bat_mode" = "power-saver" ] && bat_icon="󰂏"
battery="$bat_icon $cap%"
    
# ---------------- Network ----------------
wifi=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
if nmcli -t -f DEVICE,TYPE,STATE device status \
        | grep -qE '^[^:]+:ethernet:connected$'; then
    net_icon="󰈁"
    network="$net_icon"
elif [ -n "$wifi" ]; then
    net_icon="󰖩"
    network="$net_icon $wifi"
else
    net_icon="󰖪"
    network="$net_icon"
fi

# ---------------- Volume ----------------
vol_line=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
vol_val=$(echo "$vol_line" | awk '{printf "%d\n", $2 * 100}')
if echo "$vol_line" | grep -q "MUTED"; then
    vol_icon="󰖁"
elif [ "$vol_val" -ge 50 ]; then
    vol_icon="󰕾"
else
    vol_icon="󰖀"
fi
volume="$vol_icon $vol_val%"

# ---------------- Clock ----------------
clock="$(date '+󰃭 %a %d-%m-%Y | 󰥔 %H:%M')"

# --------------- Bluetooth ---------------
bt_val=$(bluetoothctl info)
if echo "$bt_val" | grep -E "Device|Connected"; then
    bt_icon="ᛒ |"
else
    bt_icon=""
fi
bluetooth="$bt_icon"

# ---------------- Combine ----------------

echo "$bluetooth $network | $volume | $clock | $battery "
