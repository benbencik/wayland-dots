#!/usr/bin/env bash


# Get the filename from the argument
THEME_FILE="$HOME/.config/theming/current-theme.conf"

# Check if the file exists
if [ ! -f "$THEME_FILE" ]; then
    echo "Error: File '$FILE' not found."
    exit 1
fi

# execute the script for hyprland
"$HOME/.config/theming/update-hyprland.sh" "$THEME_FILE"

"$HOME/.config/theming/update-waybar.sh" "$THEME_FILE"