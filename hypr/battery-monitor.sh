#!/usr/bin/env bash
# Warn on low battery while discharging: orange at <=20%, red at <=10%.
# Run from exec-once. No progress bar, plain popup.

set -euo pipefail

BAT=/sys/class/power_supply/BAT0
WARN=20
CRIT=10
INTERVAL=60       # seconds between checks
level=none        # none | warn | crit -> what we've already alerted

alert() {
	# $1 category  $2 urgency  $3 icon-title  $4 body
	notify-send \
		-u "$2" \
		-h "string:x-canonical-private-synchronous:battery" \
		-h "string:category:$1" \
		"$3" "$4"
}

while true; do
	cap=$(cat "$BAT/capacity")
	status=$(cat "$BAT/status")

	if [[ "$status" == "Discharging" ]]; then
		if (( cap <= CRIT )); then
			[[ "$level" != "crit" ]] && alert battery-crit critical "󰂃  Battery critical" "$cap% — plug in now"
			level=crit
		elif (( cap <= WARN )); then
			[[ "$level" != "warn" ]] && alert battery-warn normal "󰁻  Battery low" "$cap% remaining"
			level=warn
		else
			level=none
		fi
	else
		level=none
	fi

	sleep "$INTERVAL"
done
