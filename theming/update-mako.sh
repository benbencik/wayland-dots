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

# Border + progress bar follow the theme accent, but leave the battery block
# (last section) alone so it keeps its own red "urgent" styling.
sed -i "/^\[category=osd-boost\]/,\$!s/^border-color=.*/border-color=$border_color_hex/" "$MAKO_CONFIG"
sed -i "/^\[category=osd-boost\]/,\$!s/^progress-color=.*/progress-color=over ${border_color_hex}33/" "$MAKO_CONFIG"

echo "Mako config updated with current theme colors."

# Restart mako to apply the changes
pkill mako && mako &