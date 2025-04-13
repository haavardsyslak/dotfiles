#!/bin/bash

CONFIG_DIR="$HOME/.config/hypr"
SELECTED=$(ls "$CONFIG_DIR" | grep '.conf$' | bemenu -p "Select monitor config:")

if [ -n "$SELECTED" ]; then
    cp "$CONFIG_DIR/$SELECTED" "$CONFIG_DIR/monitors.conf"
    hyprctl reload
    notify-send "Loaded $SELECTED"
else
    notify-send "No config selected."
fi
