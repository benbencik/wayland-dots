#!/usr/bin/env bash

THEME_FILE="$HOME/.config/theming/current-theme.conf"

# Check if the file exists
if [ ! -f "$THEME_FILE" ]; then
    echo "Error: File '$THEME_FILE' not found."
    exit 1
fi

echo "Applying theme from: $THEME_FILE"

# Execute all update scripts
"$HOME/.config/theming/update-hyprland.sh" "$THEME_FILE"
"$HOME/.config/theming/update-waybar.sh" "$THEME_FILE"
"$HOME/.config/theming/update-mako.sh" "$THEME_FILE"
"$HOME/.config/theming/update-conky.sh" "$THEME_FILE"
"$HOME/.config/theming/update-obsidian.sh" "$THEME_FILE"

pkill waybar && waybar &

echo "All configs updated successfully!"