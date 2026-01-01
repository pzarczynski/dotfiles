#!/usr/bin/bash
if pgrep -f 'foot -a gotop gotop -a -l simple' >/dev/null; then
  pkill -f 'foot -a gotop gotop -a -l simple'
else
  foot -a gotop gotop -a -l simple &
fi
