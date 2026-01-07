#!/usr/bin/env bash
iface="${1:-$(ip route get 1.1.1.1 | awk '/dev/ {for (i=1;i<=NF;i++) if ($i==\"dev\") print $(i+1)}')}"
prev_rx=$(cat /sys/class/net/"$iface"/statistics/rx_bytes)
sleep 1
while true; do
  cur_rx=$(cat /sys/class/net/"$iface"/statistics/rx_bytes)
  diff=$((cur_rx - prev_rx))
  prev_rx=$cur_rx
  mb=$(awk -v d="$diff" 'BEGIN {printf "%.1f", d/1024/1024}')
  printf "%s\n" "$mb"
  sleep 1
done
