#!/usr/bin/env bash
BAT_DEV="$(upower -e | grep BAT)"
state=$(upower -i "$BAT_DEV" | \
    awk '/state:/ {print $2}')
bat=$(upower -i "$BAT_DEV" | awk '/percentage:/ {gsub("%", ""); print$2}')

if [ "$state" != "discharging" ]; then
    sudo tlp ac >> /dev/null
else
    if [ "$bat" -le 30 ]; then
        sudo tlp power-saver >> /dev/null
    else
        sudo tlp bat >> /dev/null
    fi
fi

status=$(tlp-stat -m | cut -d'/' -f1)
echo "$status"
