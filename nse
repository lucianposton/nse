#!/bin/bash

for ((i=0; i < "$#"; ++i)); do
    if [ "--" = "${!i}" ]; then
        SPLIT="$i"
        break
    fi
done
if [ -z "$SPLIT" ]; then
    echo "usage: $(basename "$0") [nsenter args] -- CMD"
    exit 1
fi
NSENTER_PARAMS=("${@:1:$SPLIT-1}")
SUDO_PARAMS=("${@:$SPLIT+1}")

[ "$(id -u)" == "0" ] || exec sudo -- "$0" "$@"

if [ -z "${SUDO_USER}" ]; then
    echo "SUDO_USER not set"
    exit 1
fi

nsenter "${NSENTER_PARAMS[@]}" -- \
    sudo -u "#${SUDO_UID}" -g "#${SUDO_GID}" -- "${SUDO_PARAMS[@]}"
