#!/usr/bin/env bash

THEME_FILE="$HOME/.config/theming/current-theme.conf"

# Extract colors from the theme file
foreground=$(grep '^foreground' "$THEME_FILE" | awk '{print $2}')
background=$(grep '^background' "$THEME_FILE" | awk '{print $2}')
selection_foreground=$(grep '^selection_foreground' "$THEME_FILE" | awk '{print $2}')
selection_background=$(grep '^selection_background' "$THEME_FILE" | awk '{print $2}')
cursor=$(grep '^cursor' "$THEME_FILE" | awk '{print $2}')
cursor_text_color=$(grep '^cursor_text_color' "$THEME_FILE" | awk '{print $2}')
border_color=$(grep '^active_border_color' "$THEME_FILE" | awk '{print $2}')

# Launch Bemenu with the extracted colors
bemenu-run \
    --nb "$background" \
    --nf "$foreground" \
    --hb "$selection_background" \
    --hf "$selection_foreground" \
    --bdr "$border_color" \
    --tb "$background" \
    --tf "$foreground" \
    --fb "$background" \
    --ab "$background" \
    --af "$foreground" \