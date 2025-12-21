#!/usr/bin/env bash

# Paths to the theme and Hyprland configuration files
THEME_FILE="$1"
HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"

echo "Updating Hyprland with theme: $THEME_FILE"

# Extract colors from the theme file and remove the #
active_border=$(grep '^active_border_color' "$THEME_FILE" | awk '{print $2}' | sed 's/#//')
inactive_border=$(grep '^inactive_border_color' "$THEME_FILE" | awk '{print $2}' | sed 's/#//')

# Replace the colors in the Hyprland configuration file
sed -i "s/col.active_border = rgb([^)]*)/col.active_border = rgb($active_border)/" "$HYPRLAND_CONF"
sed -i "s/col.inactive_border = rgb([^)]*)/col.inactive_border = rgb($inactive_border)/" "$HYPRLAND_CONF"

echo "Hyprland border colors updated successfully."