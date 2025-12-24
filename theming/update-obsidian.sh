#!/usr/bin/env bash

# Paths to the theme and obsidian config files
THEME_FILE="${1:-$HOME/.config/theming/current-theme.conf}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OBSIDIAN_THEME="$SCRIPT_DIR/../obsidian/themes/Custom/theme.css"

echo "Updating Obsidian Custom theme with: $THEME_FILE"

# Check if theme file exists
if [ ! -f "$THEME_FILE" ]; then
    echo "Error: Theme file '$THEME_FILE' not found."
    exit 1
fi

# Check if Custom theme exists
if [ ! -f "$OBSIDIAN_THEME" ]; then
    echo "Error: Custom theme file '$OBSIDIAN_THEME' not found."
    exit 1
fi

# Function to lighten a hex color
lighten_color() {
    hex=${1#\#}
    r=$(printf '%d' 0x${hex:0:2})
    g=$(printf '%d' 0x${hex:2:2})
    b=$(printf '%d' 0x${hex:4:2})
    
    r=$((r + $2 > 255 ? 255 : r + $2))
    g=$((g + $2 > 255 ? 255 : g + $2))
    b=$((b + $2 > 255 ? 255 : b + $2))
    
    printf "#%02x%02x%02x" $r $g $b
}

# Read colors from the theme file
foreground=$(grep '^foreground' "$THEME_FILE" | awk '{print $2}')
background=$(grep '^background' "$THEME_FILE" | awk '{print $2}')
selection_foreground=$(grep '^selection_foreground' "$THEME_FILE" | awk '{print $2}')
selection_background=$(grep '^selection_background' "$THEME_FILE" | awk '{print $2}')
color0=$(grep '^color0' "$THEME_FILE" | awk '{print $2}')
color2=$(grep '^color2' "$THEME_FILE" | awk '{print $2}')  # accent
color3=$(grep '^color3' "$THEME_FILE" | awk '{print $2}')  # h3, bold
color4=$(grep '^color4' "$THEME_FILE" | awk '{print $2}')  # italic
color5=$(grep '^color5' "$THEME_FILE" | awk '{print $2}')  # h2

bg5_light=$(lighten_color "$background" 20)

# Update CSS variables in :root and theme sections
sed -i "s|--bg-dark:.*|--bg-dark:        $background;|" "$OBSIDIAN_THEME"
sed -i "s|--fg-dark:.*|--fg-dark:        $foreground;|" "$OBSIDIAN_THEME"
sed -i "s|--bg0-dark:.*|--bg0-dark:       $color0;|" "$OBSIDIAN_THEME"
sed -i "s|--bg5-dark:.*|--bg5-dark:       $bg5_light;|" "$OBSIDIAN_THEME"

# Update accent and selection colors in theme sections
sed -i "/\.theme-dark/,/^}/s|--text-selection:.*|--text-selection:             $selection_background;|" "$OBSIDIAN_THEME"
sed -i "/\.theme-light/,/^}/s|--text-selection:.*|--text-selection:             $selection_background;|" "$OBSIDIAN_THEME"
sed -i "/\.theme-dark/,/^}/s|--interactive-accent:.*|--interactive-accent:         $color2;|" "$OBSIDIAN_THEME"
sed -i "/\.theme-dark/,/^}/s|--text-accent:.*|--text-accent:                $color2;|" "$OBSIDIAN_THEME"

# Remove old auto-generated section
sed -i '/\/\* AUTO-GENERATED: Custom text styling \*\//,/\/\* END AUTO-GENERATED \*\//d' "$OBSIDIAN_THEME"

# Append new styling
cat >> "$OBSIDIAN_THEME" << EOF

/* AUTO-GENERATED: Custom text styling */
.theme-dark ::selection,
.theme-light ::selection {
    background-color: var(--text-selection) !important;
    color: $selection_foreground !important;
}

.suggestion-item.is-selected {
    background-color: $selection_background !important;
    color: $selection_foreground !important;
}

strong, .cm-strong {
    color: $color3 !important;
}

em, .cm-em {
    color: $color4 !important;
}

h2, .cm-header-2 {
    color: $color5 !important;
}

h3, .cm-header-3 {
    color: $color3 !important;
}

h4, .cm-header-4 {
    color: $color2 !important;
}
/* END AUTO-GENERATED */
EOF

echo "Obsidian Custom theme updated successfully."