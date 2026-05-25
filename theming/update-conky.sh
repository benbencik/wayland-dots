#!/usr/bin/env bash

# Paths to the theme and conky config files
THEME_FILE="$1"
CONKY_CONFIG="$HOME/.config/conky/conky.conf"

echo "Updating Conky with theme: $THEME_FILE"

# Read colors from the theme file
foreground=$(grep '^foreground' "$THEME_FILE" | awk '{print $2}')
background=$(grep '^background' "$THEME_FILE" | awk '{print $2}')
header_color=$(grep '^url_color' "$THEME_FILE" | awk '{print $2}')              # blue for headers
label_color=$(grep '^color8' "$THEME_FILE" | awk '{print $2}')                  # muted gray for labels
bar_color=$(grep '^color3' "$THEME_FILE" | awk '{print $2}')                    # pink for bars
highlight_color=$(grep '^color2' "$THEME_FILE" | awk '{print $2}')              # purple for highlights
accent_color=$(grep '^active_tab_background' "$THEME_FILE" | awk '{print $2}')  # light blue for accents

# Update the conky config file assignments
sed -i "s/default_color = '[^']*'/default_color = '$foreground'/" "$CONKY_CONFIG"
sed -i "s/color1 = '[^']*'/color1 = '$header_color'/" "$CONKY_CONFIG"
sed -i "s/color2 = '[^']*'/color2 = '$label_color'/" "$CONKY_CONFIG"
sed -i "s/color3 = '[^']*'/color3 = '$bar_color'/" "$CONKY_CONFIG"
sed -i "s/color4 = '[^']*'/color4 = '$highlight_color'/" "$CONKY_CONFIG"
sed -i "s/color5 = '[^']*'/color5 = '$accent_color'/" "$CONKY_CONFIG"
sed -i "s/own_window_colour = '[^']*'/own_window_colour = '$background'/" "$CONKY_CONFIG"

# Restart conky to apply changes
pkill conky && sleep 0.5 && conky -c "$CONKY_CONFIG" &

echo "Conky config updated with current theme colors."