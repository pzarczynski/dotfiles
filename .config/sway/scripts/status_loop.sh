#!/bin/sh

interrupted=0
trap 'interrupted=1' USR1

while :; do
    interrupted=0
    
    echo "$($HOME/.config/sway/scripts/statusbar.sh)"

    for i in 1; do
        [ $interrupted -eq 1 ] && break
        sleep 1
    done
done
