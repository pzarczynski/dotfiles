#!/bin/sh

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

echo "$bluetooth $network | $volume | $clock "
