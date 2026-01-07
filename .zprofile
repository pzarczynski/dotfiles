if [[ -n $SSH_CONNECTION ]]; then
    echo "Welcome to $(hostnamectl --static)!"
    echo
elif [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec sway --unsupported-gpu
fi

