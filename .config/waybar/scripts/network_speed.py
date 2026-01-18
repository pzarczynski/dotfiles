#!/usr/bin/env python3
import json
import time
import os

iface = "wlan0"  # change to your interface, e.g. "wlan0"
state_file = "/tmp/waybar_net_state"

with open(f"/sys/class/net/{iface}/operstate") as f:
    if f.read().strip() != "up":
        print(json.dumps({"text": "󱘖"}))
        exit()

def read_bytes(iface):
    with open("/proc/net/dev") as f:
        for line in f:
            if iface + ":" in line:
                parts = line.split()
                rx = int(parts[1])
                tx = int(parts[9])
                return rx, tx
    return None, None

rx, tx = read_bytes(iface)

total = rx + tx
now = time.time()

prev_total = None
prev_time = None

if os.path.exists(state_file):
    try:
        with open(state_file) as f:
            data = json.load(f)
            prev_total = data.get("total")
            prev_time = data.get("time")
    except Exception:
        pass

with open(state_file, "w") as f:
    json.dump({"total": total, "time": now}, f)

mibs = 0.0
if prev_total is not None and prev_time is not None:
    dt = now - prev_time
    if dt > 0:
        diff = max(0, total - prev_total)
        mibs = diff / dt / 1024 / 1024

print(json.dumps({"text": f" {mibs:.1f}M"}))

