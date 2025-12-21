#!/usr/bin/env bash

# Paths to the theme and conky config files
THEME_FILE="$1"
CONKY_CONFIG="$HOME/.config/conky/conky.conf"

echo "Updating Conky with theme: $THEME_FILE"

# Read colors from the theme file
default_color=$(grep '^foreground' "$THEME_FILE" | awk '{print $2}')
color1=$(grep '^active_border_color' "$THEME_FILE" | awk '{print $2}')
color2=$(grep '^inactive_border_color' "$THEME_FILE" | awk '{print $2}')
color3=$(grep '^cursor' "$THEME_FILE" | awk '{print $2}')
color4=$(grep '^selection_foreground' "$THEME_FILE" | awk '{print $2}')
color5=$(grep '^selection_background' "$THEME_FILE" | awk '{print $2}')
bg_color=$(grep '^background' "$THEME_FILE" | awk '{print $2}')

# Update the conky config file - note: conky uses variables, so we update the assignments
sed -i "s/default_color = '[^']*'/default_color = '$default_color'/" "$CONKY_CONFIG"
sed -i "s/color1 = '[^']*'/color1 = '$color1'/" "$CONKY_CONFIG"
sed -i "s/color2 = '[^']*'/color2 = '$color2'/" "$CONKY_CONFIG"
sed -i "s/color3 = '[^']*'/color3 = '$color3'/" "$CONKY_CONFIG"
sed -i "s/color4 = '[^']*'/color4 = '$color4'/" "$CONKY_CONFIG"
sed -i "s/color5 = '[^']*'/color5 = '$color5'/" "$CONKY_CONFIG"
sed -i "s/own_window_colour = '[^']*'/own_window_colour = '$bg_color'/" "$CONKY_CONFIG"

# Restart conky to apply changes
pkill conky && sleep 0.5 && conky -c "$CONKY_CONFIG" &

echo "Conky config updated with current theme colors."