#!/usr/bin/env bash

# Paths to the theme and hyprlock configuration files
THEME_FILE="$1"
HYPRLOCK_CONF="$HOME/.config/hypr/hyprlock.conf"

echo "Updating hyprlock with theme: $THEME_FILE"

# Grab a hex color (no #) for a given key from the theme file.
get_color() {
    grep -E "^$1[[:space:]]" "$THEME_FILE" | head -1 | awk '{print $2}' | sed 's/#//'
}

# Convert 6-digit hex to an opaque hyprlock "rgba(r, g, b, 1.0)" string.
hex2rgba() {
    local hex="$1"
    printf 'rgba(%d, %d, %d, 1.0)' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

# Map theme roles to hyprlock fields.
fg=$(hex2rgba "$(get_color foreground)")   # text / clock / labels
bg=$(hex2rgba "$(get_color background)")   # input field inner
outer=$(hex2rgba "$(get_color color3)")    # input field outline (accent)
check=$(hex2rgba "$(get_color color2)")    # correct-password green
fail=$(hex2rgba "$(get_color color1)")     # wrong-password red
caps=$(hex2rgba "$(get_color color11)")    # caps-lock yellow

# Rewrite the color fields in hyprlock.conf (comments after the value are kept).
sed -i "s/font_color = rgba([^)]*)/font_color = $fg/"       "$HYPRLOCK_CONF"
sed -i "s/inner_color = rgba([^)]*)/inner_color = $bg/"     "$HYPRLOCK_CONF"
sed -i "s/outer_color = rgba([^)]*)/outer_color = $outer/"  "$HYPRLOCK_CONF"
sed -i "s/check_color = rgba([^)]*)/check_color = $check/"  "$HYPRLOCK_CONF"
sed -i "s/fail_color = rgba([^)]*)/fail_color = $fail/"     "$HYPRLOCK_CONF"
sed -i "s/capslock_color = rgba([^)]*)/capslock_color = $caps/" "$HYPRLOCK_CONF"

# Standalone label color lines (clock, date, layout) -> foreground.
sed -i "s/^  color = rgba([^)]*)/  color = $fg/"            "$HYPRLOCK_CONF"

echo "hyprlock colors updated successfully."
