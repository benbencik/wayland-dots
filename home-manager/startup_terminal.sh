#!/usr/bin/env bash

CURRENT_WS=$(hyprctl activeworkspace | awk '/workspace ID/ { print $3 }')

hyprctl dispatch workspace 8
sleep 0.3

kitty --class="grid_terminal" --title="top_left" -- bluetuith &
sleep 0.5

hyprctl dispatch layoutmsg preselect right
kitty --class="grid_terminal" --title="top_right" -- wiremix &
sleep 0.5

hyprctl dispatch focuswindow title:^top_left$
sleep 0.2
hyprctl dispatch layoutmsg preselect down
kitty --class="grid_terminal" --title="bottom_left" --hold -- ~/.config/home-manager/hello-duck.sh &
sleep 0.5

hyprctl dispatch focuswindow title:^top_right$
sleep 0.2
hyprctl dispatch layoutmsg preselect down
kitty --class="grid_terminal" --title="bottom_right" &
sleep 0.3

hyprctl dispatch workspace $CURRENT_WS
