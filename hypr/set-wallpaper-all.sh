#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <wallpaper-number>" >&2
    exit 1
fi

wallpaper_number="$1"
wallpaper_path="$HOME/.config/wallpapers/${wallpaper_number}.png"

if [[ ! -f "$wallpaper_path" ]]; then
    echo "Wallpaper not found: $wallpaper_path" >&2
    exit 1
fi

mapfile -t monitors < <(hyprctl monitors | awk '/^Monitor / {print $2}')

if [[ ${#monitors[@]} -eq 0 ]]; then
    echo "No monitors detected by hyprctl monitors" >&2
    exit 1
fi

for monitor in "${monitors[@]}"; do
    hyprctl hyprpaper wallpaper "$monitor,$wallpaper_path"
done
