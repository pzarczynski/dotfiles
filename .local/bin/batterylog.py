#!/usr/bin/env python3
import csv
import os
import time
from datetime import datetime, timezone

INTERVAL = int(os.environ.get("BAT_LOG_INTERVAL", "60"))
FIELDS = ["status", "capacity", "charge_now", "charge_full"] 

OUT_DIR = os.path.expanduser("~/.local/share/batterylog")
OUT_FILE = os.path.join(OUT_DIR, "log.csv")


def read_battery(field):
    base = f"/sys/class/power_supply/BAT0"
    path = os.path.join(base, field)
    try:
        with open(path) as f:
            return f.read().strip()
    except FileNotFoundError:
        return ""


def write_headers(file, fields):
    if not os.path.exists(file):
        with open(file, "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=fields)
            w.writeheader()


def write_row(file, row, fields):
    with open(file, "a", newline="") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writerow(row)


def sample(fields):
    timestamp = datetime.now(timezone.utc).isoformat()
    samples = {field: read_battery(field) for field in fields}    
    return {"timestamp": timestamp, **samples} 


if __name__ == "__main__":        
    os.makedirs(OUT_DIR, exist_ok=True)

    out_fields = ["timestamp", *FIELDS]
    write_headers(OUT_FILE, out_fields)

    while True:
        row = sample(FIELDS)       
        write_row(OUT_FILE, row, out_fields) 
        time.sleep(INTERVAL)

