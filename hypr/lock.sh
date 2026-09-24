#!/usr/bin/env bash

# Avoid stacking multiple hyprlock instances.
pidof hyprlock && exit 0

SHADER="$HOME/.config/hypr/shaders/crt-glitch.frag"

# Unset shader with the [[EMPTY]] after unlock
restore() { hyprctl keyword decoration:screen_shader "[[EMPTY]]"; }
trap restore EXIT

hyprctl keyword decoration:screen_shader "$SHADER"
hyprlock
