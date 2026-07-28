#!/usr/bin/env bash
# On-screen-display for volume + brightness: a pango glyph bar in a mako popup.
# The synchronous hint makes repeats replace instead of stack.
# Usage: osd.sh {vol-up|vol-down|vol-mute|bright-up|bright-down}

set -euo pipefail

STEP=5
SEGMENTS=25            # glyph bar width in cells
FULL="▰"
EMPTY="▱"
DIM_COLOR="#665c54"    # empty-cell color

glyph_bar() {
	# $1 percent(0-100)  $2 fill-color  ->  pango-marked bar string
	local pct=$1 color=$2 filled i out=""
	filled=$(( (pct * SEGMENTS + 50) / 100 ))
	(( filled > SEGMENTS )) && filled=SEGMENTS
	(( filled < 0 )) && filled=0
	out="<span color='${color}'>"
	for ((i = 0; i < filled; i++)); do out+="$FULL"; done
	out+="</span><span color='${DIM_COLOR}'>"
	for ((i = filled; i < SEGMENTS; i++)); do out+="$EMPTY"; done
	out+="</span>"
	printf '%s' "$out"
}

# $1 sync-key  $2 category  $3 title  $4 real-%  $5 bar-fill-% (0-100)  $6 fill-color
send() {
	notify-send \
		-h "string:x-canonical-private-synchronous:$1" \
		-h "string:category:$2" \
		"$3" "$(glyph_bar "$5" "$6")  $4%"
}

vol_notify() {
	local vol muted
	vol=$(pamixer --get-volume)
	muted=$(pamixer --get-mute)
	if [[ "$muted" == "true" ]]; then
		send volume osd "󰝟  Muted" 0 0 "$DIM_COLOR"
	else
		# Bar maps 0-150% onto a 0-100 fill; >100% turns orange (boost).
		local fill=$(( vol * 100 / 150 )) cat=osd color="#a9b665"
		if (( vol > 100 )); then cat=osd-boost; color="#e78a4e"; fi
		send volume "$cat" "󰕾  Volume" "$vol" "$fill" "$color"
	fi
}

bright_notify() {
	local cur max pct
	cur=$(brightnessctl get)
	max=$(brightnessctl max)
	pct=$(( cur * 100 / max ))
	send brightness osd "󰃟  Brightness" "$pct" "$pct" "#a9b665"
}

case "${1:-}" in
	vol-up)      pamixer --allow-boost --set-limit 150 -i "$STEP"; vol_notify ;;
	vol-down)    pamixer --allow-boost --set-limit 150 -d "$STEP"; vol_notify ;;
	vol-mute)    pamixer -t;         vol_notify ;;
	bright-up)   brightnessctl set "${STEP}%+" -q; bright_notify ;;
	bright-down) brightnessctl set "${STEP}%-" -q; bright_notify ;;
	*) echo "usage: $0 {vol-up|vol-down|vol-mute|bright-up|bright-down}" >&2; exit 1 ;;
esac
