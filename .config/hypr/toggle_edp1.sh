#!/bin/bash

status=$(hyprctl monitors | grep "eDP-1")
if [[ -z "$status" ]]; then
    hyprctl keyword monitor "eDP-1, preferred, auto, 1"
else
    hyprctl keyword monitor "eDP-1, disable"
fi
