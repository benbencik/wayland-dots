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

# Read colors from the theme file
foreground=$(grep '^foreground' "$THEME_FILE" | awk '{print $2}')
background=$(grep '^background' "$THEME_FILE" | awk '{print $2}')
selection_background=$(grep '^selection_background' "$THEME_FILE" | awk '{print $2}')
color0=$(grep '^color0' "$THEME_FILE" | awk '{print $2}')
color8=$(grep '^color8' "$THEME_FILE" | awk '{print $2}')
color2=$(grep '^color2' "$THEME_FILE" | awk '{print $2}')   # green - for bold
color6=$(grep '^color6' "$THEME_FILE" | awk '{print $2}')   # cyan - for italic
color15=$(grep '^color15' "$THEME_FILE" | awk '{print $2}') # bright white - for borders

# Update the Custom theme CSS file directly
# Update dark theme variables in the :root section
sed -i "s|--bg-dark:.*|--bg-dark:        $background;|" "$OBSIDIAN_THEME"
sed -i "s|--fg-dark:.*|--fg-dark:        $foreground;|" "$OBSIDIAN_THEME"
sed -i "s|--bg0-dark:.*|--bg0-dark:       $color0;|" "$OBSIDIAN_THEME"
sed -i "s|--bg5-dark:.*|--bg5-dark:       $color15;|" "$OBSIDIAN_THEME"
sed -i "s|--text-selection:.*|--text-selection:             $selection_background;|" "$OBSIDIAN_THEME"

# Add custom CSS for bold and italic styling at the end of the file
# First, remove any existing custom styling section
sed -i '/\/\* AUTO-GENERATED: Custom text styling \*\//,/\/\* END AUTO-GENERATED \*\//d' "$OBSIDIAN_THEME"

# Then append new styling
cat >> "$OBSIDIAN_THEME" << EOF

/* AUTO-GENERATED: Custom text styling */
strong, .cm-strong {
    color: $color2 !important;
}

em, .cm-em {
    color: $color6 !important;
}

.workspace-leaf-content[data-type="markdown"] .view-content {
    border-color: $color15 !important;
}

.markdown-source-view.mod-cm6 .cm-line {
    border-color: $color15 !important;
}
/* END AUTO-GENERATED */
EOF

echo "Obsidian Custom theme updated successfully."
echo "The following colors were updated:"
echo "  Background: $background"
echo "  Foreground: $foreground"
echo "  Selection: $selection_background"
echo "  Border: $color15 (brighter)"
echo "  Bold text: $color2 (green)"
echo "  Italic text: $color6 (cyan)"
