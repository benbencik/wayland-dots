#!/usr/bin/env bash

# Paths to the theme and style files
THEME_FILE="$1"
STYLE_FILE="$HOME/.config/waybar/style.css"

# Function to convert hex color to rgba
hex_to_rgba() {
    hex=$1
    alpha=$2
    r=$(printf '%d' 0x${hex:1:2})
    g=$(printf '%d' 0x${hex:3:2})
    b=$(printf '%d' 0x${hex:5:2})
    echo "rgba($r, $g, $b, $alpha)"
}

# Read colors from the theme file
foreground=$(grep '^foreground' "$THEME_FILE" | awk '{print $2}')
background_hex=$(grep '^background' "$THEME_FILE" | awk '{print $2}')
selection_background_hex=$(grep '^selection_background' "$THEME_FILE" | awk '{print $2}')
color2=$(grep '^color2' "$THEME_FILE" | awk '{print $2}')  # green - accent

# Convert hex colors to rgba
background=$(hex_to_rgba "$background_hex" 0.95)
background_alt="$selection_background_hex"

# Update the style.css file
sed -i "s/@define-color foreground .*/@define-color foreground $foreground;/" "$STYLE_FILE"
sed -i "s/@define-color background .*/@define-color background $background;/" "$STYLE_FILE"
sed -i "s/@define-color background-alt .*/@define-color background-alt $background_alt;/" "$STYLE_FILE"
sed -i "s/@define-color accent .*/@define-color accent $color2;/" "$STYLE_FILE"

echo "Waybar style updated with current theme colors."