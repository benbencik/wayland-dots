#!/usr/bin/env bash

# Paths to the theme and mako config files
THEME_FILE="$1"
MAKO_CONFIG="$HOME/.config/mako/config"

# Read colors from the theme file
foreground=$(grep '^foreground' "$THEME_FILE" | sed 's/.*#/#/')
background_hex=$(grep '^background' "$THEME_FILE" | sed 's/.*#/#/')
border_color_hex=$(grep '^active_border_color' "$THEME_FILE" | sed 's/.*#/#/')

# Update the mako config file
sed -i "s/^background-color=.*/background-color=$background_hex/" "$MAKO_CONFIG"
sed -i "s/^text-color=.*/text-color=$foreground/" "$MAKO_CONFIG"
sed -i "s/^border-color=.*/border-color=$border_color_hex/" "$MAKO_CONFIG"

echo "Mako config updated with current theme colors."

# Restart mako to apply the changes
pkill mako && mako &